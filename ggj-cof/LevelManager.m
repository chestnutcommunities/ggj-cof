//
//  LevelManager.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 7/13/13.
//
//

#import "LevelManager.h"

@implementation LevelManager {
    NSArray *_levels;
    int _currentLevelIndex;
}

+ (LevelManager *)sharedInstance {
    static dispatch_once_t once;
    static LevelManager * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if ((self = [super init])) {
        _currentLevelIndex = 0;
        Level * level1 = [[[Level alloc] initWithLevelNumber:1] autorelease];
        Level * level2 = [[[Level alloc] initWithLevelNumber:2] autorelease];
        _levels = [@[level1, level2] retain];
    }
    return self;
}

- (Level *)curLevel {
    if (_currentLevelIndex >= _levels.count) {
        return nil;
    }
    return _levels[_currentLevelIndex];
}

- (void)nextLevel {
    _currentLevelIndex++;
}

- (void)reset {
    _currentLevelIndex = 0;
}

- (void)dealloc {
    [_levels release];
    _levels = nil;
    [super dealloc];
}

@end
