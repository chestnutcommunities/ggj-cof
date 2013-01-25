//
//  GameRenderingLayer.m
//  ggj-cof
//
//  Created by Shingo Tamura on 24/01/13.
//
//

#import "ShingoTestLayer.h"
#import "TileMapManager.h"
#import "Human.h"
#import "GamePlayInputLayer.h"
#import "GamePlayStatusLayer.h"

@implementation ShingoTestLayer

-(void)update:(ccTime)delta {}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ShingoTestLayer *renderingLayer = [ShingoTestLayer node];
	
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
        Human* enemy = [[Human alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninja-normal.png"]];
		[enemy setPosition:spawnPoint];
		[self.sceneBatchNode addChild:enemy z:100];
        [enemy release];
    }
}

-(id) init {
    if ((self = [super init])) {
        [self initFriendsAndEnemies];
	}
	return self;
}

@end
