//
//  AICharacter.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/26/13.
//  Copyright 2013 Groovy Vision. All rights reserved.
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

@end
