//
//  CardManager.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CardManager.h"

@implementation CardManager

@synthesize cardDeckSpriteBatchNode = _cardDeckSpriteBatchNode;

-(id) initCardsFromTileMap:(CCTMXTiledMap*)tileMap {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"zombie.plist"];
    self.cardDeckSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"zombie.png"];
    return self;
}

@end
