//
//  ScoreLayer.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 3/15/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CommonProtocol.h"

@class GamePlayRenderingLayer;

@interface ScoreLayer : CCLayer {
    CCLabelTTF *_score;
}

@property (nonatomic, retain) GamePlayRenderingLayer *gameLayer;
@property (nonatomic, retain) CCLabelTTF *score;

-(void)reflectScore:(int)newScore;
-(void)animateScore:(CGPoint)startPoint newScore:(int)newScore;

@end
