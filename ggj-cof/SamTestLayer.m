//
//  SamTestLayer.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SamTestLayer.h"
#import "GamePlayRenderingLayer.h"
#import "TileMapManager.h"
#import "CardManager.h"

@implementation SamTestLayer

@synthesize cardManager = _cardManager;

-(void) initCard
{
    self.cardManager = [[[CardManager alloc] initCardsFromTileMap:self.mapManager.tileMap] retain];
    [self addChild:self.cardManager.cardDeckSpriteBatchNode];
}

@end
