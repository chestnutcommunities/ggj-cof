//
//  GameCharacter.m
//  TileGame
//
//  Created by Sam Christian Lee on 9/22/12.
//  Copyright 2012 Chopsticks On Fire. All rights reserved.
//

#import "GameCharacter.h"
#import "CommonProtocol.h"

@implementation GameCharacter

@synthesize characterHealth;
@synthesize characterState; 
@synthesize speed = _speed;
@synthesize isMoving = _isMoving;

-(void) dealloc { 
    [super dealloc];
}

- (void) pauseGame:(NSNotification *) notification {
    [self pauseSchedulerAndActions];
    for (CCNode* child in [self children]) {
        [child pauseSchedulerAndActions];
    }
}

- (void) resumeGame:(NSNotification *) notification {
    [self resumeSchedulerAndActions];
    for (CCNode* child in [self children]) {
        [child resumeSchedulerAndActions];
    }
}

-(id) init {
	if ((self = [super init])) {
        CCLOG(@"GameCharacter init");
        self.speed = 0.0f;
        self.isMoving = NO;
		gameObjectType = kObjectTypePlayer;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseGame:) name:@"pauseGame" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeGame:) name:@"resumeGame" object:nil];
    }
    return self;
}

@end