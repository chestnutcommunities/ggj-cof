//
//  CountdownLayer.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 3/10/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CommonProtocol.h"
#import "ColoredSquareSprite.h"

@class GamePlayRenderingLayer;

@interface CountdownLayer : CCLayer
{
    CCLabelTTF *_playerLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_preyLabel;
    ColoredSquareSprite *_blackOut;
    CGSize _winSize;
    int _currentAnimation;
    BOOL _instructionsDone;
}

@property (nonatomic, retain) GamePlayRenderingLayer *gameLayer;

@end
