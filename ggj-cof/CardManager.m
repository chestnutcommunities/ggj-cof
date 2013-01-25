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

+(CCTMXObjectGroup *)getCardsFromTileMap:(CCTMXTiledMap*)tileMap {    
    CCTMXObjectGroup *cards = [tileMap objectGroupNamed:@"Cards"];
    return cards;
}

+(void)setCardPositionOnTileMap:(CCTMXObjectGroup*)cards onMap:(CCTMXTiledMap*)tileMap {
    int x, y; //positions of spawn points
    NSMutableDictionary *objectTile;
    for (objectTile in [cards objects]) {
        x = [[objectTile valueForKey:@"x"] intValue];
        y = [[objectTile valueForKey:@"y"] intValue];
        
        if ([[objectTile valueForKey:@"Card"] intValue] == 1) {
            
        }
    }
}

@end
