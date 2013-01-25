//
//  GameRenderingLayer.h
//  ggj-cof
//
//  Created by Shingo Tamura on 24/01/13.
//
//

#import "cocos2d.h"

@class GamePlayInputLayer;
@class GamePlayStatusLayer;
@class Human;

@interface ShingoTestLayer : CCLayer
{
    CCSpriteBatchNode *_sceneBatchNode;
    Human *_player;

    GamePlayInputLayer *_inputLayer;
    GamePlayStatusLayer *_statusLayer;
}

@property (nonatomic, retain) GamePlayInputLayer *inputLayer;
@property (nonatomic, retain) GamePlayStatusLayer *statusLayer;
@property (nonatomic, retain) Human *player;

+(CCScene *) scene;

@end
