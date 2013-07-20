//
//  GameObject.m
//  TileGame
//
//  Created by Sam Christian Lee on 9/22/12.
//  Copyright 2012 GameCurry. All rights reserved.
//

#import "GameObject.h"
#import "Logger.h"

@implementation GameObject

@synthesize screenSize;
@synthesize gameObjectType;

-(CGRect)adjustedBoundingBox {
    return [self boundingBox];
}

-(void)changeState:(CharacterStates)newState {}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andGameObject:(GameObject*)gameObject {}
-(id)init {
	if((self=[super init])){
        [[Logger sharedInstance] log:LogType_GameObjects content:@"GameObject initialized"];
        
        screenSize = [CCDirector sharedDirector].winSize;
		gameObjectType = kObjectTypeNone;
    }
    return self;
}

@end
