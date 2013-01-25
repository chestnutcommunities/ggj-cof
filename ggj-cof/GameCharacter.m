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

-(void) dealloc { 
    [super dealloc];
}

-(id) init {
	if ((self = [super init])) {
        CCLOG(@"GameCharacter init");
		gameObjectType = kObjectTypePlayer;
    }
    return self;
}

@end