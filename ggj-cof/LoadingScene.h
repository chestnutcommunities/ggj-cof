//
//  Loading
//  TileGame
//
//  Created by Shingo Tamura on 26/07/12.
//  Copyright (c) 2013 Groovy Vision. All rights reserved.
//

#import "cocos2d.h"

@interface LoadingLayer : CCLayerColor {
}

+(CCScene *) scene;

@end

@interface LoadingScene : CCScene {
    LoadingLayer *layer;
}

@property (nonatomic, retain) LoadingLayer *layer;
@end