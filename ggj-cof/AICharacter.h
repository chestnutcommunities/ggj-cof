//
//  AICharacter.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameCharacter.h"
#import "ShortestPathStep.h"
#import "TileMapManager.h"

@interface AICharacter : GameCharacter {
	NSMutableArray *_spOpenSteps;
	NSMutableArray *_spClosedSteps;
	NSMutableArray *_shortestPath;
	CCAction *_currentStepAction;
	NSValue *_pendingMove;
}

@property (nonatomic, retain) NSMutableArray *spOpenSteps;
@property (nonatomic, retain) NSMutableArray *spClosedSteps;
@property (nonatomic, retain) NSMutableArray *shortestPath;
@property (nonatomic, retain) CCAction *currentStepAction;
@property (nonatomic, retain) NSValue *pendingMove;

- (void)popStepAndAnimate:(id)sender data:(TileMapManager*)tileMapManager;

@end
