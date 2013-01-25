//
//  CardManager.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CardManager.h"
#import "GameObject.h"
#import "Card.h"
#import "PositioningHelper.h"
#import "TileMapManager.h"

@implementation CardManager

@synthesize cardDeckSpriteBatchNode = _cardDeckSpriteBatchNode;

-(id) initCardsFromTileMap:(CCTMXTiledMap*)tileMap {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"zombie.plist"];
    self.cardDeckSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"zombie.png"];
    return self;
}

-(void) addCard:(CGPoint)spawnLocationInPixels withZValue:(int)zValue {
    Card *card = [[Card alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"zombie-front-1.png"]];
    
    CGPoint spawnPoint = [PositioningHelper convertPixelsToPoints:spawnLocationInPixels retina:true];
    [card setPosition:spawnPoint];
    [self.cardDeckSpriteBatchNode addChild:card z:zValue];
    [card setDelegate:self];
    [card release];
}

-(void) updateCardState:(GameObject*)object tileMapManager:(TileMapManager *)tileMapManager tileMap:(CCTMXTiledMap*)tileMap {
    Card *card = (Card *)object; //cast object to Card type
    
    //[self moveRandomly:card tileMapManager:(TileMapManager *)tileMapManager tileMap:tileMap target:(CGPoint)target];
}

-(void) moveRandomly:(Card *)card tileMapManager:(TileMapManager *)tileMapManager tileMap:(CCTMXTiledMap*)tileMap target:(CGPoint)target {
    if (card.currentStepAction) {
        return;
    }
    
    card.spOpenSteps = [NSMutableArray array];
	card.spClosedSteps = [NSMutableArray array];
	card.shortestPath = nil;
    
    CGPoint fromTileCoor = [PositioningHelper computeTileFittingPositionInPoints:card.position tileMap:tileMap tileSizeInPoints:tileMapManager.tileSizeInPoints];
    CGPoint toTileCoord = [PositioningHelper computeTileFittingPositionInPoints:target tileMap:tileMap tileSizeInPoints:tileMapManager.tileSizeInPoints];
    
	//Check if target has been reached
	if (CGPointEqualToPoint(fromTileCoor, toTileCoord)) {
		return;
	}

    [card insertInOpenSteps:[[[ShortestPathStep alloc] initWithPosition:fromTileCoor] autorelease]];
    
    
}

@end
