//
//  GameOverScene.h
//  TileGame
//
//  Created by Shingo Tamura on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface GameCompleteLayer : CCLayerColor
@end

@interface GameCompleteScene : CCScene {
    GameCompleteLayer *layer;
}
@property (nonatomic, retain) GameCompleteLayer *layer;
@end