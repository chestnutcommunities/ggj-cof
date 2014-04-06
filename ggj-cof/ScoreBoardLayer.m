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
#import "SimpleAudioEngine.h"
#import "ColoredSquareSprite.h"

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
        self.isTouchEnabled = YES;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGSize pixelSize = [[CCDirector sharedDirector] winSizeInPixels];
        
        // add background
        ColoredSquareSprite *greenBackground = [[[ColoredSquareSprite alloc] initWithColor:ccc4(32, 84, 43, 250) size:winSize] retain];
        greenBackground.position = ccp(winSize.width * 0.5f, winSize.height * 0.5f);
        greenBackground.visible = YES;
        [self addChild:greenBackground z:0];
        
        CCSprite *scoreBoardBackground = [[[CCSprite alloc] init] autorelease];
        [scoreBoardBackground setTextureRectInPixels:CGRectMake(0, 0, pixelSize.width * 0.5f, pixelSize.height * 2)
                                             rotated:YES
                                       untrimmedSize:CGSizeMake(pixelSize.width * 0.5f, pixelSize.height * 2)];
        scoreBoardBackground.position = ccp(winSize.width * 0.85f, winSize.height);
        scoreBoardBackground.color = ccc3(90, 58, 26);
        [self addChild:scoreBoardBackground z:1];
        
        [[DBManager getSharedInstance] saveScore:newScore];
        int topCount = 3;
        NSMutableArray *topList = [[DBManager getSharedInstance] getTopScores:topCount];
        
        CCLabelTTF *topScoresText = [CCLabelTTF labelWithString:@"TOP SCORES" fontName:@"SoupofJustice" fontSize:35];
        topScoresText.position = ccp(winSize.width * 0.80f, winSize.height * 0.90f);
        topScoresText.color = ccc3(188, 146, 104);
        [self addChild:topScoresText z:2];
        
        CCLabelTTF *topScoreList[topCount];
        CCLabelTTF *topScoreMessage[topCount];
        int counter = 1;
        for (ScoreMessage *record in topList)
        {
            //record.score
            topScoreList[counter] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"~ %d ~", record.score]
                                                       fontName:@"SoupofJustice"
                                                       fontSize:50];
            topScoreMessage[counter] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", record.message]
                                                       fontName:@"SoupofJustice"
                                                       fontSize:30];
            
            topScoreList[counter].position = ccp(winSize.width * 0.80f, winSize.height - (counter * 0.25f * winSize.height));
            topScoreList[counter].color = ccWHITE;
            [self addChild:topScoreList[counter] z:4];
            
            topScoreMessage[counter].position = ccp(winSize.width * 0.80f, winSize.height - (counter * 0.25f * winSize.height) - (winSize.height * 0.10f));
            topScoreMessage[counter].color = ccWHITE;
            [topScoreMessage[counter] setOpacity:150];
            [self addChild:topScoreMessage[counter] z:3];
            
            counter++;
        }
        
        // show latest score
        CCLabelTTF *latestText = [CCLabelTTF labelWithString:@"NEW" fontName:@"SoupofJustice" fontSize:70];
        latestText.position = ccp(winSize.width * 0.15f, winSize.height * 0.83f);
        latestText.color = ccYELLOW;
        latestText.rotation = 330;
        [latestText setOpacity:200];
        [self addChild:latestText z:5];
        
        CCLabelTTF *scoreText = [CCLabelTTF labelWithString:@"SCORE!" fontName:@"SoupofJustice" fontSize:70];
        scoreText.position = ccp(winSize.width * 0.25f, winSize.height * 0.65f);
        scoreText.color = ccYELLOW;
        scoreText.rotation = 330;
        [scoreText setOpacity: 200];
        [self addChild:scoreText z:5];
        
        CCLabelTTF *score = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", newScore]
                                               fontName:@"SoupofJustice"
                                               fontSize:180];
        
        score.position = ccp(winSize.width * 0.30f, winSize.height * 0.20f);
        score.color = ccYELLOW;
        [self addChild:score z:6];
        
        CCMenuItem* backToTitleButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-resume-normal.png"]
                                                         selectedSprite:[CCSprite spriteWithSpriteFrameName:@"button-resume-pressed.png"]
                                                                 target:self
                                                               selector:@selector(backToTitleTapped:)];
        backToTitleButton.position = ccp(winSize.width * 0.95f, winSize.height * 0.05f);
        CCMenu *menuList = [CCMenu menuWithItems:backToTitleButton, nil];
        menuList.position = CGPointZero;
        [self addChild:menuList z:7];
        
        [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:YES];
    }
    return self;
}

-(void)backToTitleTapped:(CCMenuItem *)sender {
    [[SimpleAudioEngine sharedEngine] playEffect:@"3-key-strum.caf"];
    TitleScreenScene *titleScene = [TitleScreenScene node];
    [[CCDirector sharedDirector] replaceScene:titleScene];
}

-(void)dealloc {
    [super dealloc];
}

@end
