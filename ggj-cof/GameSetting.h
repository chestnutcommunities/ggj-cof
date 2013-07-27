//
//  GameSetting.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 7/26/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameSetting : NSObject {
    uint difficultyLevel;
    float enemySpeed;
    float enemyAcceleratedSpeed;
    int cardLimit;
    int cardRange;
    int predatorToPreyRatio;
}

@property(nonatomic) uint difficultyLevel;
@property(nonatomic) BOOL hasSound;
@property(nonatomic) float enemySpeed;
@property(nonatomic) float enemyAcceleratedSpeed;
@property(nonatomic) int cardLimit;
@property(nonatomic) int cardRange;
@property(nonatomic) int predatorToPreyRatio;

+(GameSetting *) instance;
-(void)resetGameProperties;
-(void)loadGameProperties;

@end
