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
    
    BOOL _heldUp;
    BOOL _heldDown;
    BOOL _heldLeft;
    BOOL _heldRight;
    
    ColoredSquareSprite* _up;
    ColoredSquareSprite* _down;
    ColoredSquareSprite* _left;
    ColoredSquareSprite* _right;
    
    ccTime _tmpMovingDelta;
    ccTime _movingThreshold;
}

@property (nonatomic, retain) GamePlayRenderingLayer *gameLayer;

@property (nonatomic, retain) ColoredSquareSprite *up;
@property (nonatomic, retain) ColoredSquareSprite *down;
@property (nonatomic, retain) ColoredSquareSprite *left;
@property (nonatomic, retain) ColoredSquareSprite *right;

@property (nonatomic, assign) ccTime movingThreshold;
@property (nonatomic, assign) BOOL heldUp;
@property (nonatomic, assign) BOOL heldDown;
@property (nonatomic, assign) BOOL heldLeft;
@property (nonatomic, assign) BOOL heldRight;

@end

