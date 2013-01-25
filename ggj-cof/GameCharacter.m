//
//  GameCharacter.m
//  TileGame
//
//  Created by Sam Christian Lee on 9/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
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

-(id) init {
	if ((self = [super init])) {
        CCLOG(@"GameCharacter init");
        self.speed = 0.0f;
        self.isMoving = NO;
		gameObjectType = kObjectTypePlayer;
    }
    return self;
}

@end