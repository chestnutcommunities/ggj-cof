//
//  AIHelper.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//
#import "cocos2d.h"
#import "Card.h"
#import "ShortestPathStep.h"
#import "TileMapManager.h"

@interface PopStepAnimateData : NSObject
{
    Card *_card;
    TileMapManager *_tileMapManager;
}

@property (nonatomic, retain) Card *card;
@property (nonatomic, retain) TileMapManager *tileMapManager;

@end

@interface AIHelper : CCLayer

+ (void)insertInOpenSteps:(Card *)card step:(ShortestPathStep *)step;
+ (void)constructPathAndStartAnimationFromStep:(Card *)card step:(ShortestPathStep *)step;
+ (int)costToMoveFromStep:(ShortestPathStep *)fromStep toAdjacentStep:(ShortestPathStep *)toStep;
+ (int)computeHScoreFromCoord:(CGPoint)fromCoord toCoord:(CGPoint)toCoord;
+ (void)popStepAndAnimate:(id)sender data:(void*)popStepAnimateData;
+(void) moveToTarget:(Card *)card tileMapManager:(TileMapManager *)tileMapManager tileMap:(CCTMXTiledMap*)tileMap target:(CGPoint)target;
+(void) moveAwayFromChaser:(Card *)card tileMapManager:(TileMapManager *)tileMapManager tileMap:(CCTMXTiledMap*)tileMap;
+(BOOL)sawPlayer:(Card *)observerCard tileMapManager:(TileMapManager *)tileMapManager player:(Card *)player;
+(CGPoint)getLastTileWhereCardIsFacing:(Card *)observerCard tileMapManager:(TileMapManager *)tileMapManager facing:(FacingDirection)facing;
+(CCArray *)getTilesInStraightLine:(Card *)observerCard tileMapManager:(TileMapManager *)tileMapManager facing:(FacingDirection)facing;
@end
