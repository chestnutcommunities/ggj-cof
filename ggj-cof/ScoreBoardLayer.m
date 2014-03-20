//
//  ScoreBoardLayer.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 3/17/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "ScoreBoardLayer.h"
#import "DBManager.h"
#import "ScoreMessage.h"
#import "TitleScreenScene.h"

@implementation ScoreBoardScene

@synthesize layer = _layer;

- (id)init {
    if ((self = [super init])) {
        self.layer = [ScoreBoardLayer node];
        [self addChild:_layer];
    }
    return self;
}

- (id)initWithNewScore:(int)newScore {
    if ((self = [super init])) {
        self.layer = [[ScoreBoardLayer node] initWithNewScore:newScore];
        [self addChild:_layer];
    }
    return self;
}

- (void)dealloc {
    [_layer release];
    [super dealloc];
}

@end

@implementation ScoreBoardLayer

-(id) init {
    if ((self=[super initWithColor:ccc4(255, 255, 255, 255)])) {

    }
    return self;
}

-(id)initWithNewScore:(int)newScore {
    if ((self=[super initWithColor:ccc4(255, 255, 255, 255)])) {
        self.color = ccBLACK;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        [[DBManager getSharedInstance] saveScore:newScore];
        int topCount = 3;
        NSMutableArray *topList = [[DBManager getSharedInstance] getTopScores:topCount];
        
        CCLabelTTF *topScoreList[topCount];
        int counter = topCount;
        for (ScoreMessage *record in topList)
        {
            topScoreList[counter] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d - %@", record.score, record.message] fontName:@"SoupofJustice" fontSize:30];
            topScoreList[counter].position = ccp(winSize.width * 0.5f, winSize.height * counter * 0.28);
            topScoreList[counter].color = ccWHITE;
            [self addChild:topScoreList[counter] z:2];
            counter--;
        }
        
        // show latest score
        CCLabelTTF *score = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Latest Score: %d", newScore] fontName:@"IntotheVortex-Regular" fontSize:40];
        score.position = ccp(winSize.width * 0.5f, winSize.height * 0.10f);
        score.color = ccRED;
        [self addChild:score z:1];
        id actionTitleMove = [CCMoveTo actionWithDuration:1.0f position:ccp(winSize.width * 0.5f, winSize.height * 0.15f)];
        id bounceTitleMove = [CCEaseBounceOut actionWithAction:actionTitleMove];
        [score runAction:bounceTitleMove];
        
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:5], [CCCallFunc actionWithTarget:self selector:@selector(redirectToTitleScreen)], nil]];
        
    }
    return self;
}

-(void)redirectToTitleScreen {
    TitleScreenScene *titleScene = [TitleScreenScene node];
    [[CCDirector sharedDirector] replaceScene:titleScene];
}

-(void)dealloc {
    
    [super dealloc];
}

@end
