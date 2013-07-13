//
//  GamePlayGoldLayer.h
//  TileGame
//
//  Created by Shingo Tamura on 11/10/12.
//
//

#import "cocos2d.h"
#import "CommonProtocol.h"
#import "ColoredSquareSprite.h"

@class GamePlayRenderingLayer;

@interface GamePlayStatusLayer : CCLayer
{
    ColoredSquareSprite* _backPanel;
    ColoredSquareSprite* _menuButton;
    ColoredSquareSprite* _audioButton;
    ColoredSquareSprite* _pauseButton;
    ColoredSquareSprite* _playButton;
    
    GamePlayRenderingLayer *_gameLayer;
}

@property (nonatomic, retain) GamePlayRenderingLayer *gameLayer;

-(void)showPanel;
-(void)hidePanel;

@end