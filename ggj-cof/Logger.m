//
//  Logger.m
//  ggj-cof
//
//  Created by Shingo Tamura on 20/07/13.
//
//

#import "Logger.h"

@implementation Logger

+(id)sharedInstance {
    static Logger *sharedLogger = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedLogger = [[self alloc] init];
    });
    
    return sharedLogger;
}

-(id)init {
    if (self = [super init]) {
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
}

-(void)enable {
    _enabled = YES;
}

-(void)disable {
    _enabled = NO;
}

-(void)setFeature:(LogType)type doEnable:(BOOL)doEnable {
    switch (type) {
        case LogType_AIHelper:
            _logAiHelper = doEnable;
            break;
        case LogType_GameObjects:
            _logGameObjects = doEnable;
            break;
        default:
            _logGeneral = doEnable;
            break;
    }
}

-(void)log:(LogType)type content:(NSString*)formatString, ... NS_FORMAT_FUNCTION(2,3)
{
    if (!_enabled) { return; }
    if ((type == LogType_General) && !_logGeneral) { return; }
    if ((type == LogType_AIHelper) && !_logAiHelper) { return; }
    if ((type == LogType_GameObjects) && !_logGameObjects) { return; }

    va_list args;
    va_start(args, formatString);
    CCLOG(formatString, args);
    va_end(args);
}

@end
