//
//  TileMapManager.m
//  ggj-cof
//
//  Created by Shingo Tamura on 25/01/13.
//
//

#import "TileMapManager.h"
#import "GamePlayRenderingLayer.h"

@implementation TileMapManager

@synthesize tileMap = _tileMap;
@synthesize meta = _meta;
@synthesize tileSizeInPoints = _tileSizeInPoints;

- (void) dealloc
{
	self.tileMap = nil;
    self.meta = nil;
    
	[_tileMap release];
	[_meta release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id) initWithTileMap:(CCTMXTiledMap*)tileMap forLayer:(GamePlayRenderingLayer*)layer
{
    self.tileMap = tileMap;
    
    // Set the tile size in points (this is universal across normal and retina displays)
    self.tileSizeInPoints = CGSizeMake(32.0f, 32.0f);
    
    self.meta = [_tileMap layerNamed:@"Meta"];
    _meta.visible = NO;
    
    // Add the map to the layer
    [layer addChild:_tileMap];
    
    return self;
}

@end
