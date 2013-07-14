//
//  Level.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 7/13/13.
//
//

#import "Level.h"

@implementation Level

- (id) initWithLevelNumber:(int)levelNumber {
    if ((self = [super init])) {
        self.levelNumber = levelNumber;
    }
}

@end
