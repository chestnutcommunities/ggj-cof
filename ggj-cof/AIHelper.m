//
//  AIHelper.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "AIHelper.h"
#import "Card.h"
#import "PositioningHelper.h"
#import "TileMapManager.h"
#import "ShortestPathStep.h"
#import "Constants.h"

@implementation PopStepAnimateData

@synthesize card = _card;
@synthesize tileMapManager = _tileMapManager;

- (void) dealloc
{
	self.tileMapManager = nil;
    self.card = nil;
    
	[_tileMapManager release];
	[_card release];
    
    [super dealloc];
}

@end

@implementation AIHelper

// Insert a path step (ShortestPathStep) in the ordered open steps list (spOpenSteps)
+ (void)insertInOpenSteps:(Card *)card step:(ShortestPathStep *)step
{
	int stepFScore = [step fScore];
	int count = [card.spOpenSteps count];
	int i = 0;
	for (; i < count; i++) {
		// if the step F score's is lower or equals to the step at index i
		if (stepFScore <= [[card.spOpenSteps objectAtIndex:i] fScore]) {
			// Then we found the index at which we have to insert the new step
			break;
		}
	}
	// Insert the new step at the good index to preserve the F score ordering
	[card.spOpenSteps insertObject:step atIndex:i];
}

+ (void)popStepAndAnimate:(id)sender data:(void*)popStepAnimateData {
    PopStepAnimateData *data = (PopStepAnimateData *) popStepAnimateData;
    Card *card = data.card;
    TileMapManager *tileMapManager = data.tileMapManager;
    
    card.currentStepAction = nil;
	
    // Check if there is a pending move
    if (card.pendingMove != nil) {
        CGPoint moveTarget = [card.pendingMove CGPointValue];
        card.pendingMove = nil;
		card.shortestPath = nil;
        [self moveToTarget:card tileMapManager:tileMapManager tileMap:tileMapManager.tileMap target:moveTarget];
        return;
    }
    
	// Check if there is still shortestPath
	if (card.shortestPath == nil) {
		return;
	}
	
	// Check if there remains path steps to go trough
	if ([card.shortestPath count] == 0) {
		card.shortestPath = nil;
		return;
	}
	
	// Get the next step to move to
	ShortestPathStep *s = [card.shortestPath objectAtIndex:0];
	
    CGPoint destination = [PositioningHelper positionInPointsForTileCoord:s.position tileMap:tileMapManager.tileMap tileSizeInPoints:tileMapManager.tileSizeInPoints];
    
    if (card.position.x != destination.x) {
        if (card.position.x < destination.x) {
            [card face:kFacingRight];
        }
        else {
            [card face:kFacingLeft];
        }
    }
    
	// Prepare the action and the callback
	id moveAction = [CCMoveTo actionWithDuration:1.0f position:destination];
    
    
	// set the method itself as the callback
    id moveCallback = [CCCallFuncND actionWithTarget:self selector:@selector(popStepAndAnimate:data:) data:data];
    card.currentStepAction = [CCSequence actions:moveAction, moveCallback, nil];
	
	// Remove the step
	[card.shortestPath removeObjectAtIndex:0];
	
	// Play actions
	[card runAction:card.currentStepAction];
}

// Go backward from a step (the final one) to reconstruct the shortest computed path
+ (void)constructPathAndStartAnimationFromStep:(Card *)card step:(ShortestPathStep *)step tileMapManager:(TileMapManager *)tileMapManager {
	card.shortestPath = [NSMutableArray array];
	
	do {
		if (step.parent != nil) { // Don't add the last step which is the start position (remember we go backward, so the last one is the origin position ;-)
			[card.shortestPath insertObject:step atIndex:0]; // Always insert at index 0 to reverse the path
		}
		step = step.parent; // Go backward
	} while (step != nil); // Until there is no more parent
    
    PopStepAnimateData *data = [[PopStepAnimateData alloc] init];
    data.card = card;
    data.tileMapManager = tileMapManager;
    
	[AIHelper popStepAndAnimate:self data:data];
}

// Compute the cost of moving from a step to an adjecent one
+(int) costToMoveFromStep:(ShortestPathStep *)fromStep toAdjacentStep:(ShortestPathStep *)toStep
{
	return ((fromStep.position.x != toStep.position.x) && (fromStep.position.y != toStep.position.y)) ? 14 : 10;
}

+(int) computeHScoreFromCoord:(CGPoint)fromCoord toCoord:(CGPoint)toCoord
{
	// Manhattan distance
	return abs(toCoord.x - fromCoord.x) + abs(toCoord.y - fromCoord.y);
}

+(void) moveToTarget:(Card *)card tileMapManager:(TileMapManager *)tileMapManager tileMap:(CCTMXTiledMap*)tileMap target:(CGPoint)target {
    if (card.currentStepAction) {
        if (card.characterState == kStateChasing) {
            card.pendingMove = [NSValue valueWithCGPoint:target];
        }
        return;
    }
    
    card.spOpenSteps = [NSMutableArray array];
	card.spClosedSteps = [NSMutableArray array];
	card.shortestPath = nil;
    
    CGPoint fromTileCoor = [PositioningHelper tileCoordForPositionInPoints:card.position tileMap:tileMap tileSizeInPoints:tileMapManager.tileSizeInPoints];
    CGPoint toTileCoord = [PositioningHelper tileCoordForPositionInPoints:target tileMap:tileMap tileSizeInPoints:tileMapManager.tileSizeInPoints];
    
	//Check if target has been reached
	if (CGPointEqualToPoint(fromTileCoor, toTileCoord)) {
        card.currentDestinationPath = card.currentDestinationPath + 1;
		return;
	}
    
    [AIHelper insertInOpenSteps:card step:[[[ShortestPathStep alloc] initWithPosition:fromTileCoor] autorelease]];
    
    do
	{
        // Because the list is ordered, the first step is always the one with the lowest F cost
		ShortestPathStep *currentStep = [card.spOpenSteps objectAtIndex:0];
		
		[card.spClosedSteps addObject:currentStep]; // Add the current step to the closed set
		[card.spOpenSteps removeObjectAtIndex:0]; // Remove it from the open list
        
        // If currentStep is at the desired tile coordinate, we are done
		if (CGPointEqualToPoint(currentStep.position, toTileCoord)) {
			[AIHelper constructPathAndStartAnimationFromStep:card step:currentStep tileMapManager:tileMapManager];
			card.spOpenSteps = nil; // Set to nil to release unused memory
			card.spClosedSteps = nil; // Set to nil to release unused memory
			break;
		}
        
        // Get the adjacent tiles coord of the current step
        NSArray *adjSteps = [tileMapManager walkableAdjacentTilesCoordForTileCoord:currentStep.position];
		for (NSValue *v in adjSteps) {
			ShortestPathStep *step = [[ShortestPathStep alloc] initWithPosition:[v CGPointValue]];
			
			// Check if the step isn't already in the closed set
			if ([card.spClosedSteps containsObject:step]) {
				[step release]; // Must releasing it to not leaking memory ;-)
				continue; // Ignore it
			}
			
			// Compute the cost form the current step to that step
			int moveCost = [AIHelper costToMoveFromStep:currentStep toAdjacentStep:step];
			
			// Check if the step is already in the open list
			NSUInteger index = [card.spOpenSteps indexOfObject:step];
			
			// if not on the open list, so add it
			if (index == NSNotFound) {
				// Set the current step as the parent
				step.parent = currentStep;
				// The G score is equal to the parent G score + the cost to move from the parent to it
				step.gScore = currentStep.gScore + moveCost;
				step.hScore = [AIHelper computeHScoreFromCoord:step.position toCoord:toTileCoord];
				
				[AIHelper insertInOpenSteps:card step:step];
				[step release];
			}
			else {
				// Already in the open list
				[step release]; // Release the freshly created one
				step = [card.spOpenSteps objectAtIndex:index]; // To retrieve the old one (which has its scores already computed ;-)
				
				// Check to see if the G score for that step is lower if we use the current step to get there
				if ((currentStep.gScore + moveCost) < step.gScore) {
					
					// The G score is equal to the parent G score + the cost to move from the parent to it
					step.gScore = currentStep.gScore + moveCost;
					
					// Because the G Score has changed, the F score may have changed too
					// So to keep the open list ordered we have to remove the step, and re-insert it with
					// the insert function which is preserving the list ordered by F score
					
					// We have to retain it before removing it from the list
					[step retain];
					
					// Now we can removing it from the list without be afraid that it can be released
					[card.spOpenSteps removeObjectAtIndex:index];
					
					// Re-insert it with the function which is preserving the list ordered by F score
					[AIHelper insertInOpenSteps:card step:step];
					
					// Now we can release it because the oredered list retain it
					[step release];
				}
			}
		}
        
	} while ([card.spOpenSteps count] > 0);
}

//Bresenenham line drawing algorithm
+(void) getPointsOnLine:(int)x0 y0:(int)y0 x1:(int)x1 y1:(int)y1 pointsArray:(NSMutableArray *)pointsArray {
	int pointsOnLineGranularity = 1;
	
	int Dx = x1 - x0;
	int Dy = y1 - y0;
	int steep = (abs(Dy) >= abs(Dx));
	if (steep) {
		//swap x and y values
		int temp = x0;
		x0 = y0;
		y0 = temp;
		temp = x1;
		x1 = y1;
		y1 = temp;
		// recompute Dx, Dy after swap
		Dx = x1 - x0;
		Dy = y1 - y0;
	}
	int xstep = pointsOnLineGranularity;
	if (Dx < 0) {
		xstep = -pointsOnLineGranularity;
		Dx = -Dx;
	}
	int ystep = pointsOnLineGranularity;
	if (Dy < 0) {
		ystep = -pointsOnLineGranularity;
		Dy = -Dy;
	}
	int TwoDy = 2*Dy;
	int TwoDyTwoDx = TwoDy - 2*Dx; // 2*Dy - 2*Dx
	int E = TwoDy - Dx; //2*Dy - Dx
	int y = y0;
	int xDraw, yDraw;
	int x = x0;
	while (abs(x-x1) > pointsOnLineGranularity) {
		x += xstep;
		//for (int x = x0; x != x1; x += xstep) {
		if (steep) {
			xDraw = y;
			yDraw = x;
		} else {
			xDraw = x;
			yDraw = y;
		}
		// Add point to array.
		[pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(xDraw, yDraw)]];
		
		// next
		if (E > 0) {
			E += TwoDyTwoDx; //E += 2*Dy - 2*Dx;
			y = y + ystep;
		} else {
			E += TwoDy; //E += 2*Dy;
		}
	}
}

+(BOOL) checkIfPointIsInSight:(CGPoint)targetPos card:(Card *)card tileMapManager:(TileMapManager*)tileMapManager {
    CGPoint attackerPos = card.position;
    
    CGPoint diff = ccpSub(targetPos, attackerPos);
    if ((abs(diff.x) > kMaxLineOfSight) || (abs(diff.y) > kMaxLineOfSight)){
        return NO;
    }
    
    NSMutableArray *points = [NSMutableArray array];
	[self getPointsOnLine:targetPos.x y0:targetPos.y x1:attackerPos.x y1:attackerPos.y pointsArray:points];
	
    BOOL lineOfSight = YES;
    for (int i=0; i<[points count]; i++) {
		CGPoint thisPoint = [[points objectAtIndex:i] CGPointValue];
		CGPoint thisTile = [PositioningHelper computeTileFittingPositionInPoints:thisPoint
                                                                         tileMap:tileMapManager.tileMap
                                                                tileSizeInPoints:tileMapManager.tileSizeInPoints];
		if ([tileMapManager isWallAtTileCoord:thisTile]) {
			lineOfSight = NO;
		}
	}
	
	 if (lineOfSight) {
         glColor4ub(255,0,255,255); // Or whatever drawing setup you need
         ccDrawLine(ccp(targetPos.x, targetPos.y), ccp(attackerPos.x, attackerPos.y));
     }
	 
	return lineOfSight;
}

@end
