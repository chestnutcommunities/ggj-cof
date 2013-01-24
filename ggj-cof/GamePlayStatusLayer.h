//
//  GamePlayGoldLayer.h
//  TileGame
//
//  Created by Shingo Tamura on 11/10/12.
//
//

#import "cocos2d.h"
#import "CommonProtocol.h"

@class GamePlayRenderingLayer;

@interface GamePlayStatusLayer : CCLayer
{
    GamePlayRenderingLayer *_gameLayer;
}

@property (nonatomic, retain) GamePlayRenderingLayer *gameLayer;

@end