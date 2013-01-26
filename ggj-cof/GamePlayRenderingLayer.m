//
//  GameRenderingLayer.m
//  ggj-cof
//
//  Created by Shingo Tamura on 24/01/13.
//
//

#import "GamePlayRenderingLayer.h"
#import "GamePlayInputLayer.h"
#import "TileMapManager.h"
#import "GamePlayStatusLayer.h"
#import "GameCharacter.h"
#import "ColoredSquareSprite.h"
#import "Card.h"
#import "PositioningHelper.h"
#import "ShingoTestLayer.h"

@implementation GamePlayRenderingLayer

@synthesize inputLayer = _inputLayer;
@synthesize statusLayer = _statusLayer;
@synthesize player = _player;
@synthesize mapManager = _mapManager;
@synthesize sceneBatchNode = _sceneBatchNode;

- (void) dealloc
{
    self.inputLayer = nil;
    self.statusLayer = nil;
	self.player = nil;
	self.mapManager = nil;
	self.sceneBatchNode = nil;
    
	[_inputLayer release];
    [_statusLayer release];
    [_player release];
    [_mapManager release];
    [_sceneBatchNode release];
    
	[super dealloc];
}

-(void)update:(ccTime)delta {}

-(void) postMovePlayer:(CGPoint)destination facing:(FacingDirection)direction {}

-(void) initPlayer:(CGSize)winSize
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"card-sprite.plist"];
    _sceneBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"card-sprite.png"] retain];
    [self addChild:_sceneBatchNode];
    
    _player = [[Card alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"card.png"]];
    
    CGPoint position = [_mapManager getPlayerSpawnPoint];
    
    [_player setPosition:position];
    _player.speed = 20.0f;
    
    [_sceneBatchNode addChild:_player z:0];
    
    self.position = [PositioningHelper getViewpointPosition:_player.position]; // TODO: get spawning point from tilemap
}

-(void) initTouchEventHandlers {}

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
    BOOL doMove = NO;
    
    CGPoint fittedPos = [PositioningHelper computeTileFittingPositionInPoints:destination tileMap:_mapManager.tileMap tileSizeInPoints:_mapManager.tileSizeInPoints];
    
    // Make sure the player won't go outside the map
    if (fittedPos.x <= (_mapManager.tileMap.mapSize.width * _mapManager.tileSizeInPoints.width) && fittedPos.y <= (_mapManager.tileMap.mapSize.height * _mapManager.tileSizeInPoints.height) && fittedPos.y >= 0 && fittedPos.x >= 0) {
        doMove = YES;
    }
    
    if (!doMove) {
        return;
    }
    
    if (_player.isMoving) {
        return;
    }
    
    CGPoint tileCoord = [PositioningHelper tileCoordForPositionInPoints:fittedPos tileMap:_mapManager.tileMap tileSizeInPoints:_mapManager.tileSizeInPoints];
    
    int metaGid = [_mapManager.meta tileGIDAt:tileCoord];
    if (metaGid) {
        NSDictionary *properties = [_mapManager.tileMap propertiesForGID:metaGid];
        if (properties) {
            if ([_mapManager isCollidable:fittedPos forMeta:properties]) {
                return;
            }
        }
    }
    
    [self postMovePlayer:destination facing:direction];
    
    id actionMove = [CCMoveTo actionWithDuration:0.2f position:fittedPos];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(playerMoved:)];
    CGPoint viewPointPosition = [PositioningHelper getViewpointPosition:fittedPos];
    id actionViewpointMove = [CCMoveTo actionWithDuration:0.2f position:viewPointPosition];
    
    _player.isMoving = YES;
    
    [_player runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    [self runAction:[CCSequence actions:actionViewpointMove, nil]];
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        [self initTileMap];
        [self initPlayer:winSize];
        [self initTouchEventHandlers];
	}
	return self;
}

@end
