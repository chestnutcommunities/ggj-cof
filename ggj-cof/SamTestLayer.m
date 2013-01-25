//
//  SamTestLayer.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SamTestLayer.h"
#import "GamePlayInputLayer.h"
#import "GamePlayStatusLayer.h"
#import "GameCharacter.h"
#import "ColoredSquareSprite.h"
#import "Human.h"

@implementation SamTestLayer

@synthesize inputLayer = _inputLayer;
@synthesize statusLayer = _statusLayer;
@synthesize player = _player;
@synthesize mapManager = _mapManager;

- (void) dealloc
{
    self.inputLayer = nil;
    self.statusLayer = nil;
	self.player = nil;
    
	[_inputLayer release];
    [_statusLayer release];
    [_player release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[super dealloc];
}

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

-(void)update:(ccTime)delta
{
}

-(void) handleTouchCompleted:(NSNotification *)notification {
	NSDictionary *data = [notification userInfo];
    float x = [[data objectForKey:@"x"] floatValue];
    float y = [[data objectForKey:@"y"] floatValue];
    
    CCLOG(@"Touched at (%f, %f)", x, y);
}

-(void) handleTouchSwipedDown:(NSNotification *)notification {
    CCLOG(@"Swiped down");
    if (_player.characterState == kStateJumping) {
        [_player initiateLanding];
    }
    else {
        [_player initiateCrouch];
    }
}

-(void) handleTouchSwipedUp:(NSNotification *)notification {
    CCLOG(@"Swiped up");
    [_player initiateJump];
}

-(void) handleTouchHeld:(NSNotification *)notification {
	NSDictionary *data = [notification userInfo];
    float x = [[data objectForKey:@"x"] floatValue];
    float y = [[data objectForKey:@"y"] floatValue];
    
    CCLOG(@"Held at (%f, %f)", x, y);
}

-(void) initPlayer:(CGSize)winSize
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ninja.plist"];
    _sceneBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"ninja.png"] retain];
    [self addChild:_sceneBatchNode];
    
    _player = [[Human alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninja-normal.png"]];
    CGPoint position = ccp(winSize.width / 2.0f, winSize.height / 2.0f);
    [_player setPosition:position];
    
    [_sceneBatchNode addChild:_player z:0];
}

-(void) initTouchEventHandlers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTouchCompleted:) name:@"touchEnded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTouchSwipedDown:) name:@"touchSwipedDown" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTouchSwipedUp:) name:@"touchSwipedUp" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTouchHeld:) name:@"touchHeld" object:nil];
}

-(void) initTileMap
{
    CCTMXTiledMap* map = [CCTMXTiledMap tiledMapWithTMXFile:@"casino.tmx"];
    self.mapManager = [TileMapManager initWithTileMap:map forLayer:(GamePlayRenderingLayer*)self];
}

#pragma mark Cards

-(void) initCards
{
    
}


-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
    if ((self=[super init])) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        [self initTileMap];
        [self initCards];
        [self initPlayer:winSize];
        [self initTouchEventHandlers];
        
		[self scheduleUpdate];
	}
	return self;
}



@end
