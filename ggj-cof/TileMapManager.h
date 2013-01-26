//
//  TileMapManager.h
//  ggj-cof
//
//  Created by Shingo Tamura on 25/01/13.
//
//

#import "cocos2d.h"

@class GamePlayRenderingLayer;

@interface TileMapManager: NSObject
{
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_meta;
    CCTMXObjectGroup* _objects;
    CGSize _tileSizeInPoints;
    NSMutableArray* _enemySpawnPoints;
    NSMutableArray* _enemyDestinationPoints;
}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *meta;
@property (nonatomic, retain) CCTMXObjectGroup *objects;
@property (nonatomic, retain) NSMutableArray *enemySpawnPoints;
@property (nonatomic, retain) NSMutableArray *enemyDestinationPoints;
@property (nonatomic, assign) CGSize tileSizeInPoints;

-(id)initWithTileMap:(CCTMXTiledMap*)tileMap;
-(BOOL)isCollidable:(CGPoint)position forMeta:(NSDictionary*)meta;
-(CGPoint) getPlayerSpawnPoint;
-(BOOL)isValidTileCoord:(CGPoint)tileCoord;
-(BOOL)isWallAtTileCoord:(CGPoint)tileCoord;
-(NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord;
@end
