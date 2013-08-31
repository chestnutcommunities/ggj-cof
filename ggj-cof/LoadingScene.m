//
//  TitleScreenScene.m
//  TileGame
//
//  Created by Shingo Tamura on 26/07/12.
//  Copyright (c) 2013 Groovy Vision. All rights reserved.
//

#import "LoadingScene.h"
#import "TitleScreenScene.h"
#import "GameSetting.h"

@implementation LoadingScene
@synthesize layer = _layer;

- (id)init {
    if ((self = [super init])) {
        self.layer = [LoadingLayer node];
        [self addChild:_layer];
    }
    return self;
}

- (void)dealloc {
    [_layer release];
    [super dealloc];
}
@end

@implementation LoadingLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LoadingLayer *layer = [LoadingLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

-(void)loadingFinished {
    TitleScreenScene *titleScene = [TitleScreenScene node];
    [[CCDirector sharedDirector] replaceScene:titleScene];
}

-(id) init {
    if ((self=[super initWithColor:ccc4(26, 37, 45, 255)])) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *logo = [CCSprite spriteWithFile:@"logo.png"];
        
        logo.position = ccp(winSize.width * 0.5, winSize.height * 0.5f);
        logo.opacity = 0;        
        
        [self addChild:logo z:0];
        
        [logo runAction: [CCSequence actions:
            [CCDelayTime actionWithDuration:0.65f],
            [CCFadeIn actionWithDuration:0.35f],
            [CCDelayTime actionWithDuration:1.5f],
            [CCFadeOut actionWithDuration:0.35f],
            [CCDelayTime actionWithDuration:0.65f],
            [CCCallFunc actionWithTarget:self selector:@selector(loadingFinished)],
            nil]
        ];
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
}

@end
