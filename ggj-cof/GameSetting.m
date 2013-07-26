//
//  GameSetting.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 7/26/13.
//
//

#import "GameSetting.h"

@implementation GameSetting

@synthesize difficultyLevel, hasSound;

static GameSetting *instance = nil;

+(GameSetting *)instance {
    if (instance == nil) {
        instance = [[GameSetting alloc] init];
    }
    return instance;
}

-(id)init {
    if ((self = [super init])) {
        [self resetGameProperties];
    }
    return self;
}

-(void)resetGameProperties {
    difficultyLevel = easy;
}

-(void) setHasSound:(BOOL)b {
	hasSound = b;
}

@end
