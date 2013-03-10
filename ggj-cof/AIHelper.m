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
            card.facing = kFacingRight;
        }
        else {
            [card face:kFacingLeft];
            card.facing = kFacingLeft;
        }
    }
    if (card.position.y != destination.y) {
        if (card.position.y > destination.y) {
            card.facing = kFacingDown;
        }
        else {
            card.facing = kFacingUp;
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

// Player detection is linear based on facing direction of card
+(BOOL)sawPlayer:(Card *)observerCard tileMapManager:(TileMapManager *)tileMapManager player:(Card *)player {
    CGPoint tileOfPlayer = [PositioningHelper tileCoordForPositionInPoints:player.position
                                                                   tileMap:tileMapManager.tileMap
                                                          tileSizeInPoints:tileMapManager.tileSizeInPoints];
    CGPoint currentTileOfCard = [PositioningHelper tileCoordForPositionInPoints:observerCard.position
                                                                        tileMap:tileMapManager.tileMap
                                                               tileSizeInPoints:tileMapManager.tileSizeInPoints];
    //NSMutableArray *tempTiles = [[NSMutableArray alloc] init];
    CGPoint tempTile = CGPointMake(currentTileOfCard.x, currentTileOfCard.y);
    
    int x, y;
    
    do {
        x = tempTile.x;
        y = tempTile.y;
        
        switch (observerCard.facing) {
            case kFacingRight:
                x = x + 1;
                break;
            case kFacingLeft:
                x = x - 1;
                break;
            case kFacingDown:
                y = y + 1;
                break;
            case kFacingUp:
                y = y - 1;
                break;
            default:
                break;
        }
        tempTile = CGPointMake(x, y);
        if (CGPointEqualToPoint(tempTile, tileOfPlayer)) {
            return YES;
        }
    } while ([tileMapManager isWalkableTile:tempTile]);
    return NO;
}

+(void) moveAwayFromChaser:(Card *)card tileMapManager:(TileMapManager *)tileMapManager tileMap:(CCTMXTiledMap*)tileMap {
    if (card.characterState != kStateRunningAway) {
        card.facing = [PositioningHelper getOppositeDirection:card.facing];
        [card changeState:kStateRunningAway];
    }
    
    CGPoint tileOfCard = [PositioningHelper tileCoordForPositionInPoints:card.position
                                                                 tileMap:tileMap
                                                        tileSizeInPoints:tileMapManager.tileSizeInPoints];
    CGPoint lastTile = [self getLastTileWhereCardIsFacing:card tileMapManager:tileMapManager facing:card.facing];
    
    // go perpendicular when last tile of the line is where card is standing
    if (CGPointEqualToPoint(tileOfCard, lastTile)) {
        if ([PositioningHelper isMovingLateral:card.facing] == YES) {
            lastTile = [self getLastTileWhereCardIsFacing:card tileMapManager:tileMapManager facing:kFacingUp];
            if ([tileMapManager isWalkableTile:lastTile] == NO || CGPointEqualToPoint(tileOfCard, lastTile)) {
                lastTile = [self getLastTileWhereCardIsFacing:card tileMapManager:tileMapManager facing:kFacingDown];
            }
        }
        else {
            lastTile = [self getLastTileWhereCardIsFacing:card tileMapManager:tileMapManager facing:kFacingRight];
            if ([tileMapManager isWalkableTile:lastTile] == NO || CGPointEqualToPoint(tileOfCard, lastTile)) {
                lastTile = [self getLastTileWhereCardIsFacing:card tileMapManager:tileMapManager facing:kFacingLeft];
            }
        }
        
        // dead end for card! charge to the player!
        if ([tileMapManager isWalkableTile:lastTile] == NO || CGPointEqualToPoint(tileOfCard, lastTile)) {
            lastTile = [self getLastTileWhereCardIsFacing:card
                                           tileMapManager:tileMapManager
                                                   facing:[PositioningHelper getOppositeDirection:card.facing]];
        }
    }
    
    // Run away path
    CGPoint target = [PositioningHelper positionInPointsForTileCoord:lastTile
                                                             tileMap:tileMapManager.tileMap
                                                    tileSizeInPoints:tileMapManager.tileSizeInPoints];
    if (card.currentStepAction) {
        if (card.characterState == kStateRunningAway) {
            card.pendingMove = [NSValue valueWithCGPoint:target];
        }
        return;
    }
    
    card.spOpenSteps = [NSMutableArray array];
	card.spClosedSteps = [NSMutableArray array];
	card.shortestPath = nil;
    
    CGPoint fromTileCoor = [PositioningHelper tileCoordForPositionInPoints:card.position
                                                                   tileMap:tileMap
                                                          tileSizeInPoints:tileMapManager.tileSizeInPoints];
    CGPoint toTileCoord = [PositioningHelper tileCoordForPositionInPoints:target
                                                                  tileMap:tileMap
                                                         tileSizeInPoints:tileMapManager.tileSizeInPoints];
    
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
        
        CCArray *tileSteps = [self getTilesInStraightLine:card tileMapManager:tileMapManager facing:card.facing];
        for (NSValue *item in tileSteps) {
            ShortestPathStep *step = [[ShortestPathStep alloc] initWithPosition:[item CGPointValue]];
			
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
        }
	} while ([card.spOpenSteps count] > 0);
}

// Get last tile of where card is facing
+(CGPoint)getLastTileWhereCardIsFacing:(Card *)observerCard tileMapManager:(TileMapManager *)tileMapManager facing:(FacingDirection)facing {
    /*
    CCArray *tilesFromStraightLine = [self getTilesInStraightLine:observerCard tileMapManager:tileMapManager facing:facing];
    CGPoint lastTile = [[tilesFromStraightLine lastObject] CGPointValue];
    [tilesFromStraightLine release];
    return lastTile;
    */
    
    CGPoint currentTileOfCard = [PositioningHelper tileCoordForPositionInPoints:observerCard.position
                                                                        tileMap:tileMapManager.tileMap
                                                               tileSizeInPoints:tileMapManager.tileSizeInPoints];
    CGPoint tempTile = CGPointMake(currentTileOfCard.x, currentTileOfCard.y);
    CGPoint prevTile = tempTile;
    int x, y;
    
    do {
        x = tempTile.x;
        y = tempTile.y;
        
        switch (facing) {
            case kFacingRight:
                x = x + 1;
                break;
            case kFacingLeft:
                x = x - 1;
                break;
            case kFacingDown:
                y = y + 1;
                break;
            case kFacingUp:
                y = y - 1;
                break;
            default:
                break;
        }
        tempTile = CGPointMake(x, y);
        
        if ([tileMapManager isWalkableTile:tempTile]) {
            prevTile = tempTile;
        }
    } while ([tileMapManager isWalkableTile:tempTile]);
    
    return prevTile;
}

+(CCArray *)getTilesInStraightLine:(Card *)observerCard tileMapManager:(TileMapManager *)tileMapManager facing:(FacingDirection)facing {
    CCArray *tempTileList = [[CCArray alloc] init];
    
    CGPoint currentTileOfCard = [PositioningHelper tileCoordForPositionInPoints:observerCard.position
                                                                        tileMap:tileMapManager.tileMap
                                                               tileSizeInPoints:tileMapManager.tileSizeInPoints];
    CGPoint tempTile = CGPointMake(currentTileOfCard.x, currentTileOfCard.y);
    int x, y;
    
    do {
        x = tempTile.x;
        y = tempTile.y;
        
        switch (facing) {
            case kFacingRight:
                x = x + 1;
                break;
            case kFacingLeft:
                x = x - 1;
                break;
            case kFacingDown:
                y = y + 1;
                break;
            case kFacingUp:
                y = y - 1;
                break;
            default:
                break;
        }
        tempTile = CGPointMake(x, y);
        
        if ([tileMapManager isWalkableTile:tempTile]) {
            [tempTileList addObject:[NSValue valueWithCGPoint:tempTile]];
        }
    } while ([tileMapManager isWalkableTile:tempTile]);
    
    return tempTileList;
}

+(CCArray *)getTilesForEscapePath:(Card *)observerCard tileMapManager:(TileMapManager *)tileMapManager facing:(FacingDirection)facing {
    
    //Get straight escape
    
    
    //Go perpendicular (random maybe?)
    
    
    //Go perpendicular again (random)
    
    
    //Go perpendicular last time (random)
    
}

@end
