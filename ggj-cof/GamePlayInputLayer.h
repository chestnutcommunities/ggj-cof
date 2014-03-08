//
//  GamePlayerInputLayer.h
//  TileGame
//
//  Created by Shingo Tamura on 8/09/12.
//
//

#import "cocos2d.h"
#import "CommonProtocol.h"

@class ColoredSquareSprite;
@class GamePlayRenderingLayer;

@interface GamePlayInputLayer : CCLayer
{
    GamePlayRenderingLayer *_gameLayer;
    InputStates _inputState;
    
    UISwipeGestureRecognizer *_swipeLeftRecognizer;
    UISwipeGestureRecognizer *_swipeRightRecognizer;
    UISwipeGestureRecognizer *_swipeUpRecognizer;
    UISwipeGestureRecognizer *_swipeDownRecognizer;
    
    bool _enabled;
    ccTime _tmpMovingDelta;
    ccTime _movingThreshold;
}

@property (nonatomic, retain) GamePlayRenderingLayer *gameLayer;

@property (retain) UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (retain) UISwipeGestureRecognizer *swipeRightRecognizer;
@property (retain) UISwipeGestureRecognizer *swipeUpRecognizer;
@property (retain) UISwipeGestureRecognizer *swipeDownRecognizer;

@property (nonatomic, assign) ccTime movingThreshold;
@property (nonatomic, assign) bool enabled;

@end

