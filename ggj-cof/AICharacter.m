//
//  AICharacter.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "AICharacter.h"

#import "PositioningHelper.h"

@implementation AICharacter

@synthesize spOpenSteps = _spOpenSteps;
@synthesize spClosedSteps = _spClosedSteps;
@synthesize shortestPath = _shortestPath;
@synthesize currentStepAction = _currentStepAction;
@synthesize pendingMove = _pendingMove;

-(void) dealloc {
    self.spOpenSteps = nil;
    [_spOpenSteps release];
    
    self.spClosedSteps = nil;
	[_spClosedSteps release];
	
    self.shortestPath = nil;
	[_shortestPath release];
    
    self.currentStepAction = nil;
	[_currentStepAction release];
    
    self.pendingMove = nil;
	[_pendingMove release];
    
    [super dealloc];
}

- (void)popStepAndAnimate:(id)sender tileMapManager:(TileMapManager*)tileMapManager {
    self.currentStepAction = nil;
	
    // Check if there is a pending move
    if (self.pendingMove != nil) {
        CGPoint moveTarget = [self.pendingMove CGPointValue];
        self.pendingMove = nil;
		self.shortestPath = nil;
        //[self chaseHero:moveTarget];
        return;
    }
    
	// Check if there is still shortestPath
	if (self.shortestPath == nil) {
		return;
	}
	
	// Check if there remains path steps to go trough
	if ([self.shortestPath count] == 0) {
		self.shortestPath = nil;
		return;
	}
	
	// Get the next step to move to
	ShortestPathStep *s = [self.shortestPath objectAtIndex:0];
	
    //+(CGPoint)positionInPointsForTileCoord:(CGPoint)tileCoord tileMap:(CCTMXTiledMap*)tileMap tileSizeInPoints:(CGSize)tileSizeInPoints
	// Prepare the action and the callback
	id moveAction = [CCMoveTo actionWithDuration:1.0f position:[PositioningHelper positionInPointsForTileCoord:s.position tileMap:tileMapManager.tileMap tileSizeInPoints:tileMapManager.tileSizeInPoints]];
	// set the method itself as the callback
    id moveCallback = [CCCallFuncND actionWithTarget:self selector:@selector(popStepAndAnimate:tileMapManager:) tileMapManager:tileMapManager];
    self.currentStepAction = [CCSequence actions:moveAction, moveCallback, nil];
	
	// Remove the step
	[self.shortestPath removeObjectAtIndex:0];
	
	// Play actions
	[self runAction:self.currentStepAction];
}


@end
