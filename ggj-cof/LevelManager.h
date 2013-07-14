//
//  LevelManager.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 7/13/13.
//
//

#import <Foundation/Foundation.h>
#import "Level.h"

@interface LevelManager : NSObject

+ (LevelManager *)sharedInstance;
- (Level *)currentLevel;
- (void)nextLevel;
- (void)reset;

@end
