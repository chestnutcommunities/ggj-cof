//
//  AICharacter.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "AICharacter.h"

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

// Insert a path step (ShortestPathStep) in the ordered open steps list (spOpenSteps)
- (void)insertInOpenSteps:(ShortestPathStep *)step
{
	int stepFScore = [step fScore];
	int count = [self.spOpenSteps count];
	int i = 0;
	for (; i < count; i++) {
		// if the step F score's is lower or equals to the step at index i
		if (stepFScore <= [[self.spOpenSteps objectAtIndex:i] fScore]) {
			// Then we found the index at which we have to insert the new step
			break;
		}
	}
	// Insert the new step at the good index to preserve the F score ordering
	[self.spOpenSteps insertObject:step atIndex:i];
}

@end
