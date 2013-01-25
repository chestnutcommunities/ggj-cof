//
//  TileMapManager.m
//  ggj-cof
//
//  Created by Shingo Tamura on 25/01/13.
//
//

#import "TileMapManager.h"
#import "GamePlayRenderingLayer.h"
#import "PositioningHelper.h"

@implementation TileMapManager

@synthesize tileMap = _tileMap;
@synthesize meta = _meta;
@synthesize objects = _objects;
@synthesize tileSizeInPoints = _tileSizeInPoints;

- (void) dealloc
{
	self.tileMap = nil;
    self.meta = nil;
    self.objects = nil;
    
	[_tileMap release];
	[_meta release];
    [_objects release];
    
    [super dealloc];
}

-(CGPoint) getPlayerSpawnPoint {
    // by putting the object group into a NSMutableDictionary you get access to a lot of useful properties
    NSMutableDictionary *spawnPoint = [_objects objectNamed:@"SpawnPoint"];
    NSAssert(spawnPoint != nil, @"SpawnPoint object not found");
    int x = [[spawnPoint valueForKey:@"x"] intValue];
    int y = [[spawnPoint valueForKey:@"y"] intValue];
    
    CGPoint tileFittingPositionInPixels = [PositioningHelper computeTileFittingPositionInPixels:ccp(x, y) tileMap:_tileMap tileSizeInPoints:_tileSizeInPoints];
    CGPoint initialSpawnPoint = [PositioningHelper convertPixelsToPoints:tileFittingPositionInPixels retina:YES];
    
    return initialSpawnPoint;
}

-(NSDictionary*)getTileProperties:(CGPoint)position {
    CGPoint tileCoord = [PositioningHelper tileCoordForPositionInPoints:position tileMap:self.tileMap tileSizeInPoints:self.tileSizeInPoints];
    
    int metaGid = [_meta tileGIDAt:tileCoord];
    
    if (metaGid) {
        NSDictionary* meta = [_tileMap propertiesForGID:metaGid];
        return meta;
    }
    return nil;
}

-(BOOL)isCollidable:(CGPoint)position forMeta:(NSDictionary*)meta {
    if (!meta) {
        meta = [self getTileProperties:position];
    }
    
    if (meta) {
        NSString *collision = [meta valueForKey:@"Collidable"];
        if (collision && [collision compare:@"True"] == NSOrderedSame) {
            return YES;
        }
    }
    
    return NO;
}

-(id) initWithTileMap:(CCTMXTiledMap*)tileMap
{
    self.tileMap = tileMap;
    
    // Set the tile size in points (this is universal across normal and retina displays)
    self.tileSizeInPoints = CGSizeMake(32.0f, 32.0f);
    
    self.meta = [_tileMap layerNamed:@"Meta"];
    NSAssert(self.meta != nil, @"'Meta' layer not found");
    _meta.visible = NO;
    
    self.objects = [_tileMap objectGroupNamed:@"Objects"];
    NSAssert(self.objects != nil, @"'Objects' object group not found");
    
    return self;
}

@end
