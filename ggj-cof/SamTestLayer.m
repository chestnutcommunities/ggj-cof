//
//  SamTestLayer.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SamTestLayer.h"

#import "TileMapManager.h"
#import "Card.h"
#import "GamePlayInputLayer.h"
#import "GamePlayStatusLayer.h"

#import "GameObject.h"
#import "CardManager.h"
#import "AIHelper.h"

@implementation SamTestLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SamTestLayer *renderingLayer = [SamTestLayer node];
	
	// add layer as a child to scene
	[scene addChild: renderingLayer];
	
    GamePlayInputLayer *inputLayer = [GamePlayInputLayer node];
    [scene addChild: inputLayer];
    renderingLayer.inputLayer = inputLayer;
    inputLayer.gameLayer = (GamePlayRenderingLayer*)renderingLayer;
	
    GamePlayStatusLayer *statusDisplayLayer = [GamePlayStatusLayer node];
    [scene addChild: statusDisplayLayer];
    renderingLayer.statusLayer = statusDisplayLayer;
    statusDisplayLayer.gameLayer = (GamePlayRenderingLayer*)renderingLayer;
    
	// return the scene
	return scene;
}

-(void) initFriendsAndEnemies {
    for (NSValue* val in _mapManager.enemySpawnPoints) {
        CGPoint spawnPoint = [val CGPointValue];
        
        Card* enemy = [[Card alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"card.png"]];
        [enemy setNumber:1];
        
		[enemy setPosition:spawnPoint];
		[self.sceneBatchNode addChild:enemy z:100];
        [enemy release];
    }
}

-(void) update:(ccTime)delta
{
    CCArray *cards = [self.sceneBatchNode children];
    CGPoint target = [self.mapManager getPlayerSpawnPoint];
    
    for (GameObject *card in cards) {
        [AIHelper moveToTarget:(Card *)card tileMapManager:self.mapManager tileMap:self.mapManager.tileMap target:(CGPoint)target];
    }

}

-(id) init {
    if ((self = [super init])) {
        [self initFriendsAndEnemies];
        [self scheduleUpdate];
	}
	return self;
}

@end
