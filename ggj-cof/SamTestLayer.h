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
}

+(CCScene *) scene;

@end
