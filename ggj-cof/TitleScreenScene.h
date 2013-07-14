//
//  TitleScreenScene.h
//  TileGame
//
//  Created by Shingo Tamura on 26/07/12.
//  Copyright (c) 2012 Chopsticks On Fire. All rights reserved.
//

#import "cocos2d.h"

@interface TitleScreenLayer : CCLayerColor {
}

+(CCScene *) scene;

@end

@interface TitleScreenScene : CCScene {
    TitleScreenLayer *layer;
}
@property (nonatomic, retain) TitleScreenLayer *layer;
@end