//
//  GameRenderingLayer.m
//  ggj-cof
//
//  Created by Shingo Tamura on 24/01/13.
//
//

#import "ShingoTestLayer.h"
#import "GamePlayInputLayer.h"
#import "TileMapManager.h"
#import "GamePlayStatusLayer.h"
#import "GameCharacter.h"
#import "ColoredSquareSprite.h"
#import "Human.h"
#import "PositioningHelper.h"

@implementation ShingoTestLayer

@synthesize inputLayer = _inputLayer;
@synthesize statusLayer = _statusLayer;
@synthesize player = _player;
@synthesize mapManager = _mapManager;

- (void) dealloc
{
    self.inputLayer = nil;
    self.statusLayer = nil;
	self.player = nil;
	self.mapManager = nil;
    
	[_inputLayer release];
    [_statusLayer release];
    [_player release];
    [_mapManager release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[super dealloc];
}

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
    
    CGPoint position = [_mapManager getPlayerSpawnPoint];
    
    [_player setPosition:position];
    
    [_sceneBatchNode addChild:_player z:0];
    
    self.position = [PositioningHelper getViewpointPosition:_player.position]; // TODO: get spawning point from tilemap
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
    self.mapManager = [[[TileMapManager alloc] initWithTileMap:map] retain];
    [self addChild:self.mapManager.tileMap];
}

- (void) playerMoved:(id)sender {
    GameCharacter* player = (GameCharacter*)sender;
    player.isMoving = NO;
}

-(void) movePlayer:(CGPoint)destination facing:(FacingDirection)direction {
    CGPoint pos = destination;
    BOOL doMove = NO;
    
    // Make sure the player won't go outside the map
    if (pos.x <= (_mapManager.tileMap.mapSize.width * _mapManager.tileSizeInPoints.width) && pos.y <= (_mapManager.tileMap.mapSize.height * _mapManager.tileSizeInPoints.height) && pos.y >= 0 && pos.x >= 0) {
        doMove = YES;
    }
    
    if (!doMove) {
        return;
    }
    
    if (_player.isMoving) {
        return;
    }
    
    CGPoint tileCoord = [PositioningHelper tileCoordForPositionInPoints:destination tileMap:_mapManager.tileMap tileSizeInPoints:_mapManager.tileSizeInPoints];
    
    int metaGid = [_mapManager.meta tileGIDAt:tileCoord];
    if (metaGid) {
        NSDictionary *properties = [_mapManager.tileMap propertiesForGID:metaGid];
        if (properties) {
            if ([_mapManager isCollidable:destination forMeta:properties]) {
                return;
            }
        }
    }
    
    id actionMove = [CCMoveTo actionWithDuration:0.2f position:destination];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(playerMoved:)];
    CGPoint viewPointPosition = [PositioningHelper getViewpointPosition:destination];
    id actionViewpointMove = [CCMoveTo actionWithDuration:0.2f position:viewPointPosition];
    
    _player.isMoving = YES;
    
    [_player runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    [self runAction:[CCSequence actions:actionViewpointMove, nil]];
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
    if ((self=[super initWithColor:ccc4(255, 255, 255, 255)])) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        [self initTileMap];
        [self initPlayer:winSize];
        [self initTouchEventHandlers];
        
		[self scheduleUpdate];
	}
	return self;
}

@end
