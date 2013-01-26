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
@synthesize enemySpawnPoints = _enemySpawnPoints;
@synthesize enemyDestinationPoints = _enemyDestinationPoints;

- (void) dealloc
{
	self.tileMap = nil;
    self.meta = nil;
    self.objects = nil;
    self.enemySpawnPoints = nil;
    self.enemyDestinationPoints = nil;
    
	[_tileMap release];
	[_meta release];
    [_objects release];
    [_enemySpawnPoints release];
    [_enemyDestinationPoints release];
    
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

-(id) initWithTileMap:(CCTMXTiledMap*)tileMap {
    if (self = [super init]) {
        self.tileMap = tileMap;
        
        // Set the tile size in points (this is universal across normal and retina displays)
        self.tileSizeInPoints = CGSizeMake(32.0f, 32.0f);
        
        self.meta = [_tileMap layerNamed:@"Meta"];
        NSAssert(self.meta != nil, @"'Meta' layer not found");
        _meta.visible = NO;
        
        self.objects = [_tileMap objectGroupNamed:@"Objects"];
        NSAssert(self.objects != nil, @"'Objects' object group not found");
        
        int x = 0, y = 0;
        
        self.enemySpawnPoints = [[[NSMutableArray alloc] init] retain];
        self.enemyDestinationPoints = [[[NSMutableArray alloc] init] retain];
        
        NSMutableDictionary *obj;
        for (obj in [self.objects objects]) {
            x = [[obj valueForKey:@"x"] intValue];
            y = [[obj valueForKey:@"y"] intValue];
            
            CGPoint tileFittingPositionInPixels = [PositioningHelper computeTileFittingPositionInPixels:ccp(x, y) tileMap:_tileMap tileSizeInPoints:_tileSizeInPoints];
            CGPoint objPos = [PositioningHelper convertPixelsToPoints:tileFittingPositionInPixels retina:YES];
            
            if ([[obj valueForKey:@"Card"] intValue] == 1) {
                [self.enemySpawnPoints addObject:[NSValue valueWithCGPoint:objPos]];
            }
            else if ([[obj valueForKey:@"Destination"] intValue] == 1) {
                [self.enemyDestinationPoints addObject:[NSValue valueWithCGPoint:objPos]];
            }
            else {
                // do nothing
            }
        }
    }
    
    return self;
}

-(BOOL)isValidTileCoord:(CGPoint)tileCoord {
    if (tileCoord.x < 0 || tileCoord.y < 0 ||
        tileCoord.x >= _tileMap.mapSize.width ||
        tileCoord.y >= _tileMap.mapSize.height) {
        return FALSE;
    } else {
        return TRUE;
    }
}


-(BOOL)isProp:(NSString*)prop atTileCoord:(CGPoint)tileCoord forLayer:(CCTMXLayer *)layer {
    if (![self isValidTileCoord:tileCoord]) return NO;
    int gid = [self.meta tileGIDAt:tileCoord];
    NSDictionary * properties = [_tileMap propertiesForGID:gid];
    if (properties == nil) return NO;
    return [properties objectForKey:prop] != nil;
}

-(BOOL)isWallAtTileCoord:(CGPoint)tileCoord {
    return [self isProp:@"Collidable" atTileCoord:tileCoord forLayer:_meta];
}

-(NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord
{
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:8];
    
    BOOL t = NO;
    BOOL l = NO;
    BOOL b = NO;
    BOOL r = NO;
	
	// Top
	CGPoint p = CGPointMake(tileCoord.x, tileCoord.y - 1);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        t = YES;
	}
	
	// Left
	p = CGPointMake(tileCoord.x - 1, tileCoord.y);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        l = YES;
	}
	
	// Bottom
	p = CGPointMake(tileCoord.x, tileCoord.y + 1);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        b = YES;
	}
	
	// Right
	p = CGPointMake(tileCoord.x + 1, tileCoord.y);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        r = YES;
	}
    
    
	// Top Left
	p = CGPointMake(tileCoord.x - 1, tileCoord.y - 1);
	if (t && l && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
	
	// Bottom Left
	p = CGPointMake(tileCoord.x - 1, tileCoord.y + 1);
	if (b && l && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
	
	// Top Right
	p = CGPointMake(tileCoord.x + 1, tileCoord.y - 1);
	if (t && r && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
	
	// Bottom Right
	p = CGPointMake(tileCoord.x + 1, tileCoord.y + 1);
	if (b && r && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
	
	return [NSArray arrayWithArray:tmp];
}

@end
