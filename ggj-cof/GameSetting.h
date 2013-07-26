//
//  GameSetting.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 7/26/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum gametype {
	easy = 1,
	medium,
	hard
} gametype;

@interface GameSetting : NSObject {
    uint difficultyLevel;
}

@property(nonatomic) uint difficultyLevel;
@property(nonatomic) BOOL hasSound;

+(GameSetting *) instance;
-(void)resetGameProperties;

@end
