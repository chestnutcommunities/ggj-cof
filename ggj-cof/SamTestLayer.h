//
//  SamTestLayer.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GamePlayRenderingLayer.h"

@class GameCompleteLayer;
@class GameOverLayer;
@class CardManager;

@interface SamTestLayer : GamePlayRenderingLayer {
    CCSpriteBatchNode *_enemyBatchNode;
    GameCompleteLayer *_completeLayer;
    GameOverLayer *_gameOverLayer;
    CardManager* _cardManager;
}

+(CCScene *) scene;
-(void) postMovePlayer:(CGPoint)destination facing:(FacingDirection)direction;
@property (nonatomic, retain) GameCompleteLayer *completeLayer;
@property (nonatomic, retain) GameOverLayer *gameOverLayer;

@end
