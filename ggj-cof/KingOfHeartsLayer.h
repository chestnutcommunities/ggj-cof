//
//  KingOfHeartsLayer.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/27/13.
//  Copyright 2013 Chopsticks On Fire. All rights reserved.
//

#import "cocos2d.h"
#import "GamePlayRenderingLayer.h"

@class GameCompleteLayer;
@class GameOverLayer;
@class CardManager;

@interface KingOfHeartsLayer : GamePlayRenderingLayer {
    CCSpriteBatchNode *_enemyBatchNode;
    GameCompleteLayer *_completeLayer;
    GameOverLayer *_gameOverLayer;
    CardManager* _cardManager;
    ccTime _tmpPathFindingDelta;
}

+(CCScene *) scene;
@property (nonatomic, retain) GameCompleteLayer *completeLayer;
@property (nonatomic, retain) GameOverLayer *gameOverLayer;

@end
