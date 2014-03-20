//
//  ScoreLayer.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 3/15/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "ScoreLayer.h"

@implementation ScoreLayer

@synthesize gameLayer = _gameLayer;
@synthesize score = _score;

- (void) dealloc
{
	[super dealloc];
}

-(id) init
{
    if ((self = [super init])) {
        [self initScore];
    }
    return self;
}

-(void)reflectScore:(id)sender data:(int)newScore {
    [_score setString:[NSString stringWithFormat:@"%d",newScore]];
}

-(void) initScore
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    // show score
    _score = [CCLabelTTF labelWithString:@"0" fontName:@"SoupofJustice" fontSize:30];
    _score.position = ccp(winSize.width * 0.95f, winSize.height * 0.93f);
    _score.color = ccRED;
    
    [self addChild:_score z:1];
    
    // show crown
    CCSprite *crown = [CCSprite spriteWithFile:@"crown.png"];
    crown.tag = 1;
    crown.position = ccp(winSize.width * 0.90f, winSize.height * 0.95f);
    [self addChild:crown z:0];
    
}

-(void)animateScore:(CGPoint)startPoint newScore:(int)newScore {
    // get player's location
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *pointEffect = [CCSprite spriteWithFile:@"crown.png"];
    pointEffect.tag = 1;
    pointEffect.position = ccp(winSize.width * 0.50f, winSize.height * 0.60f);
    pointEffect.opacity = 0;
    
    [self addChild:pointEffect z:1];
    
    // pop crown on top of player's head then animate to upper right corner
    [pointEffect runAction: [CCSequence actions:
        [CCFadeIn actionWithDuration:0.35f],
        [CCMoveTo actionWithDuration:1.0f position:ccp(winSize.width * 0.90f, winSize.height * 0.95f)],
        [CCFadeOut actionWithDuration:0.35f],
        [CCCallFuncND actionWithTarget:self selector:@selector(reflectScore:data:) data:newScore],
        nil]
     ];
    
}

@end
