//
//  ScoreBoardLayer.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 3/17/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScoreBoardLayer : CCLayerColor

@end

@interface ScoreBoardScene : CCScene {
    ScoreBoardLayer *layer;
}
@property (nonatomic, retain) ScoreBoardLayer *layer;

-(id)initWithNewScore:(int)newScore;

@end