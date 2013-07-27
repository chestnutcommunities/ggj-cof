//
//  GameSetting.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 7/26/13.
//
//

#import "GameSetting.h"
#import "JSONKit.h"

@implementation GameSetting

@synthesize difficultyLevel, hasSound, enemySpeed, enemyAcceleratedSpeed, cardLimit, cardRange, predatorToPreyRatio;

static GameSetting *instance = nil;

+(GameSetting *)instance {
    if (instance == nil) {
        instance = [[GameSetting alloc] init];
    }
    return instance;
}

-(void)dealloc {
    [super dealloc];
}

-(id)init {
    if ((self = [super init])) {
        [self resetGameProperties];
    }
    return self;
}

-(void)resetGameProperties {
    difficultyLevel = 1; //reset to easy
}

-(void)loadGameProperties {
    enemySpeed = 0.65f;
    enemyAcceleratedSpeed = 0.375f;
    cardLimit = difficultyLevel * 8;
    cardRange = 4 + difficultyLevel;
    predatorToPreyRatio = difficultyLevel + 1;

    /*
    NSString *fileName = [NSString stringWithFormat:@"level-%d", difficultyLevel];
    fileName = [[NSBundle mainBundle] pathForResource:fileName ofType:@"dat" inDirectory:@"Levels"];
    NSDictionary* state = [[NSString stringWithContentsOfFile:fileName encoding:NSASCIIStringEncoding error:nil] objectFromJSONString];
    
    for(NSDictionary* data in state) {
        enemySpeed = [[data objectForKey:@"enemySpeed"] floatValue];
        enemyAcceleratedSpeed = [[data objectForKey:@"enemyAcceleratedSpeed"] floatValue];
        cardLimit = [[data objectForKey:@"cardLimit"] intValue];
        cardRange = [[data objectForKey:@"cardRange"] intValue];
        predatorToPreyRatio = [[data objectForKey:@"predatorToPreyRatio"] intValue];
    }
     */
}

-(void) setHasSound:(BOOL)b {
	hasSound = b;
}

@end
