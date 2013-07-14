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
    NSString* _audioOnButtonNormalName;
    NSString* _audioOnButtonPressedName;
    NSString* _audioOffButtonNormalName;
    NSString* _audioOffButtonPressedName;

    ColoredSquareSprite* _background;
    ColoredSquareSprite* _menuPanel;
    CCMenu *_pauseButtonMenu;
    CCMenuItemSprite *_audioButton;
    GamePlayRenderingLayer *_gameLayer;
    BOOL _audioOn;
}

@property (nonatomic, retain) GamePlayRenderingLayer *gameLayer;

-(void)showPanel;
-(void)hidePanel;

@end