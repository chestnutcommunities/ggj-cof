//
//  GameRenderingLayer.h
//  ggj-cof
//
//  Created by Shingo Tamura on 24/01/13.
//
//

#import "GamePlayRenderingLayer.h"

@class GameCompleteLayer;
@class GameOverLayer;
@class CardManager;

@interface ShingoTestLayer : GamePlayRenderingLayer
{
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
