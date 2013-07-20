//
//  Level.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 7/13/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Level : NSObject

@property (nonatomic, assign) int levelNumber;

- (id)initWithLevelNumber:(int)levelNumber;

@end
