//
//  CardManager.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface CardManager : NSObject
{
    CCSpriteBatchNode* _enemyBatchNode;
}

@property (nonatomic, retain) CCSpriteBatchNode *enemyBatchNode;

-(void) spawnCards:(int)baseNumber spawnPoints:(NSMutableArray*) spawnPoints;
-(void) shuffleCards:(int)baseNumber;

@end
