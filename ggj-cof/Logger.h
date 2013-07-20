//
//  Logger.h
//  ggj-cof
//
//  Created by Shingo Tamura on 20/07/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    LogType_AIHelper,
    LogType_GameObjects,
    LogType_General,
} LogType;

@interface Logger: NSObject
{
    BOOL _enabled;
    BOOL _logGeneral;
    BOOL _logAiHelper;
    BOOL _logGameObjects;
}

+(id)sharedInstance;
-(void)enable;
-(void)disable;
-(void)setFeature:(LogType)type doEnable:(BOOL)doEnable;
-(void)log:(LogType)type content:(NSString*)formatString, ... NS_FORMAT_FUNCTION(2,3);

@end
