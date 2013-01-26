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
#import "ShortestPathStep.h"
#import "AIHelper.h"

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

@end
