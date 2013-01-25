//
//  TileMapManager.h
//  ggj-cof
//
//  Created by Shingo Tamura on 25/01/13.
//
//

#import "cocos2d.h"

@class GamePlayRenderingLayer;

@interface TileMapManager
{
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_meta;
    CGSize _tileSizeInPoints;
}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *meta;
@property (nonatomic, assign) CGSize tileSizeInPoints;

-(id)initWithTileMap:(CCTMXTiledMap*)tileMap forLayer:(GamePlayRenderingLayer*)layer;

@end
