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
#import "Player.h"
#import "PositioningHelper.h"
#import "SimpleAudioEngine.h"

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
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"character-sprite.plist"];
    _sceneBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"character-sprite.png"] retain];
    [self addChild:_sceneBatchNode];
    
    _player = [[Player alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-front-1.png"]];
    
    CGPoint position = [_mapManager getPlayerSpawnPoint];
    
    [_player setPosition:position];
    [_player setRealPosition:position];
    
    _player.speed = 40.0f;
    
    [_sceneBatchNode addChild:_player z:0];
    
    self.position = [PositioningHelper getViewpointPosition:_player.realPosition]; // TODO: get spawning point from tilemap
}

-(void) initTouchEventHandlers {}

-(void) initTileMap
{
    CCTMXTiledMap* map = [CCTMXTiledMap tiledMapWithTMXFile:@"city.tmx"];
    self.mapManager = [[TileMapManager alloc] initWithTileMap:map];
    [self addChild:self.mapManager.tileMap];
}

- (void) playerMoved:(id)sender {
    GameCharacter* player = (GameCharacter*)sender;
    player.isMoving = NO;
}

-(void) movePlayer:(CGPoint)destination facing:(FacingDirection)direction {
    BOOL doMove = NO;
    BOOL foundPossibleDestination = NO;
    CGPoint positionInPointsForNextTileCoord;
    CGPoint positionInPointsForFinalTileCoord;
    
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
                foundPossibleDestination = NO;
                CGPoint finalTileCoord = [PositioningHelper getFinalTileCoordForCurveMovement:tileCoord tileMap:_mapManager.tileMap previous: _player.previousDirection];
                
                CGPoint nextTileCoord = [PositioningHelper getAdjacentTileCoordForCurveMovement:tileCoord tileMap:_mapManager.tileMap currentDirection:direction previous: _player.previousDirection];
                
                int metaPossibleGid = [_mapManager.meta tileGIDAt:nextTileCoord];
                int metaPossibleFinalGid = [_mapManager.meta tileGIDAt:finalTileCoord];
                
                if (metaPossibleGid && metaPossibleFinalGid) {
                    NSDictionary *possibleProperties = [_mapManager.tileMap propertiesForGID:metaPossibleGid];
                    NSDictionary *possibleFinalProperties = [_mapManager.tileMap propertiesForGID:metaPossibleFinalGid];
                    
                    if (possibleProperties && possibleFinalProperties) {
                        positionInPointsForNextTileCoord = [PositioningHelper positionInPointsForTileCoord:nextTileCoord tileMap:_mapManager.tileMap tileSizeInPoints:_mapManager.tileSizeInPoints];
                        positionInPointsForFinalTileCoord = [PositioningHelper positionInPointsForTileCoord:finalTileCoord tileMap:_mapManager.tileMap tileSizeInPoints:_mapManager.tileSizeInPoints];
                        if (![_mapManager isCollidable:positionInPointsForNextTileCoord forMeta:possibleProperties] &&
                            ![_mapManager isCollidable:positionInPointsForFinalTileCoord forMeta:possibleFinalProperties]) {
                            foundPossibleDestination = YES;
                        }
                    }
                }
                if (!foundPossibleDestination) {
                    return;
                }
            }
        }
    }
    if (foundPossibleDestination) {
        // Curve assist
        _player.previousDirection = [PositioningHelper getPreviousDirectionBasedFromCurveMovement:positionInPointsForNextTileCoord finalDestination:positionInPointsForFinalTileCoord];
        [_player face:_player.previousDirection];
        ccBezierConfig playerMoveBezier;
        playerMoveBezier.controlPoint_1 = _player.realPosition;
        playerMoveBezier.controlPoint_2 = positionInPointsForNextTileCoord;
        playerMoveBezier.endPosition = positionInPointsForFinalTileCoord;
        
        id actionCurveMove = [CCBezierTo actionWithDuration:0.4f bezier:playerMoveBezier];
        id actionCurveMoveDone = [[CCCallFuncN actionWithTarget:self selector:@selector(playerMoved:)] retain];
        
        _player.isMoving = YES;
        
        CGPoint viewPointPosition = [PositioningHelper getViewpointPosition:_player.realPosition];
        CGPoint viewPointNextTilePosition = [PositioningHelper getViewpointPosition:positionInPointsForNextTileCoord];
        CGPoint viewPointCurvePosition = [PositioningHelper getViewpointPosition:positionInPointsForFinalTileCoord];
        
        ccBezierConfig viewPortMoveBezier;
        viewPortMoveBezier.controlPoint_1 = viewPointPosition;
        viewPortMoveBezier.controlPoint_2 = viewPointNextTilePosition;
        viewPortMoveBezier.endPosition = viewPointCurvePosition;
        id actionCurveViewpointMove = [CCBezierTo actionWithDuration:0.4f bezier:viewPortMoveBezier];
        
        [_player runAction:[[CCSequence actions:actionCurveMove, actionCurveMoveDone, nil] retain]];
        [_player setRealPosition:positionInPointsForFinalTileCoord];
        [self runAction:[[CCSequence actions:actionCurveViewpointMove, nil] retain]];    }
    else {
        
        // No curve movements
        _player.previousDirection = direction;
        [_player face:direction];
        
        id actionMove = [[CCMoveTo actionWithDuration:0.35f position:fittedPos] retain];
        id actionMoveDone = [[CCCallFuncN actionWithTarget:self selector:@selector(playerMoved:)] retain];
        CGPoint viewPointPosition = [PositioningHelper getViewpointPosition:fittedPos];
        id actionViewpointMove = [[CCMoveTo actionWithDuration:0.35f position:viewPointPosition] retain];
        
        _player.isMoving = YES;
        
        [_player runAction:[[CCSequence actions:actionMove, actionMoveDone, nil] retain]];
        [_player setRealPosition:fittedPos];
        [self runAction:[[CCSequence actions:actionViewpointMove, nil] retain]];

    }
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
        
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.6f];
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:1.5f];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"main-theme.mp3" loop:YES];
	}
	return self;
}

@end
