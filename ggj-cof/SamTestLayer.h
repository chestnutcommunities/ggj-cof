//
//  SamTestLayer.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GamePlayRenderingLayer.h";

@class CardManager;

@interface SamTestLayer : GamePlayRenderingLayer {
    CCSpriteBatchNode *_cardBatchNode;
    CardManager* _cardManager;
}

@property (nonatomic, retain) CardManager *cardManager;

+(CCScene *) scene;
-(void) initCard;

@end
