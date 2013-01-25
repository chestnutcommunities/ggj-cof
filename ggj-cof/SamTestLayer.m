//
//  SamTestLayer.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SamTestLayer.h"

#import "TileMapManager.h"
#import "Human.h"
#import "GamePlayInputLayer.h"
#import "GamePlayStatusLayer.h"

#import "GameObject.h"
#import "CardManager.h"

@implementation SamTestLayer

@synthesize cardManager = _cardManager;

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
        Card* enemy = [[Card alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninja-normal.png"]];
		[enemy setPosition:spawnPoint];
		[self.sceneBatchNode addChild:enemy z:100];
        [enemy release];
    }
}

-(void) initCard
{
    self.cardManager = [[[CardManager alloc] initCardsFromTileMap:self.mapManager.tileMap] retain];
    [self addChild:self.cardManager.cardDeckSpriteBatchNode];
    
    CCTMXObjectGroup *objects = [self.mapManager.tileMap objectGroupNamed:@"Objects"];
    NSMutableDictionary *objectTile;
    int x, y;
    for (objectTile in [objects objects]) {
        x = [[objectTile valueForKey:@"x"] intValue];
        y = [[objectTile valueForKey:@"y"] intValue];
        
        if ([[objectTile valueForKey:@"Card"] intValue] == 1) {
            [self.cardManager addCard:ccp(x,y) withZValue:2];
        }
    }
}

-(void) update:(ccTime)delta
{
    CCArray *cards = [self.cardManager.cardDeckSpriteBatchNode children];
    for (GameObject *card in cards) {
        [self.cardManager updateCardState:card];
    }
}

-(id) init {
    if ((self = [super init])) {
        [self initFriendsAndEnemies];
	}
	return self;
}

@end
