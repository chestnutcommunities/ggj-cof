//
//  DBManager.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 3/17/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "cocos2d.h"

@interface DBManager : NSObject {
    NSString *databasePath;
}

+(DBManager *)getSharedInstance;
-(BOOL)createDB;
-(BOOL)saveScore:(int)newScore;
-(NSMutableArray*)getTopScores:(int)topList;
-(BOOL)createMessages;

@end
