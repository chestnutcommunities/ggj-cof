//
//  ScoreMessage.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 3/18/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScoreMessage : NSObject {
    int score;
    int lowerLimit;
    int upperLimit;
    NSString *message;
}

@property(nonatomic, retain) NSString *message;
@property(nonatomic, assign) int score;
@property(nonatomic, assign) int lowerLimit;
@property(nonatomic, assign) int upperLimit;

@end
