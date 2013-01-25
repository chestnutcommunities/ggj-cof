//
//  TileMapManager.m
//  ggj-cof
//
//  Created by Shingo Tamura on 25/01/13.
//
//

#import "TileMapManager.h"

@implementation TileMapManager

@synthesize tileMap = _tileMap;
@synthesize background = _background;
@synthesize meta = _meta;
@synthesize tileSizeInPoints = _tileSizeInPoints;

- (void) dealloc
{
	self.tileMap = nil;
    self.background = nil;
    self.meta = nil;
    
	[_tileMap release];
	[_background release];
	[_meta release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
