//
//  TitleScreenScene.h
//  TileGame
//
//  Created by Shingo Tamura on 26/07/12.
//  Copyright (c) 2013 Groovy Vision. All rights reserved.
//

#import "cocos2d.h"

@interface TitleScreenLayer : CCLayerColor {
    NSString* _audioOnButtonNormalName;
    NSString* _audioOnButtonPressedName;
    NSString* _audioOffButtonNormalName;
    NSString* _audioOffButtonPressedName;
    
    BOOL _audioOn;
    
    CCMenuItemSprite *_audioButton;
}

+(CCScene *) scene;

@end

@interface TitleScreenScene : CCScene {
    TitleScreenLayer *layer;}

@property (nonatomic, retain) TitleScreenLayer *layer;
@end