//
//  AIHelper.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/26/13.
//  Copyright 2013 Groovy Vision. All rights reserved.
//
#import "cocos2d.h"
#import "Card.h"
#import "ShortestPathStep.h"
#import "TileMapManager.h"

@interface AIHelper : CCLayer

+(BOOL)isPlayerWithinSight:(Card *)observerCard tileMapManager:(TileMapManager *)tileMapManager player:(Card *)player;
+(void)thinkAndMove:(Card*)card previouslyOfState:(CharacterStates)state targets:(CGPoint)target mapManager:(TileMapManager*)mapManager map:(CCTMXTiledMap*)map;

@end
