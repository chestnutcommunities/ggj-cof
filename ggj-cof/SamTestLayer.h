//
//  SamTestLayer.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "TileMapManager.h"

@class GamePlayInputLayer;
@class GamePlayStatusLayer;
@class Human;

@interface SamTestLayer : CCLayer {
    CCSpriteBatchNode *_sceneBatchNode;
    Human *_player;
    TileMapManager* _mapManager;
    GamePlayInputLayer *_inputLayer;
    GamePlayStatusLayer *_statusLayer;
}

@property (nonatomic, retain) GamePlayInputLayer *inputLayer;
@property (nonatomic, retain) GamePlayStatusLayer *statusLayer;
@property (nonatomic, retain) TileMapManager *mapManager;
@property (nonatomic, retain) Human *player;

+(CCScene *) scene;

@end
