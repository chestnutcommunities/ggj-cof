//
//  GameOverScene.m
//  TileGame
//
//  Created by Shingo Tamura on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameCompleteLayer.h"
#import "TitleScreenScene.h"

@implementation GameCompleteScene
@synthesize layer = _layer;

- (id)init {
    if ((self = [super init])) {
        self.layer = [GameCompleteLayer node];
        [self addChild:_layer];
    }
    return self;
}

- (void)dealloc {
    [_layer release];
    _layer = nil;
    [super dealloc];
}
@end

@implementation GameCompleteLayer

-(id) init {
    if ((self=[super initWithColor:ccc4(255, 255, 255, 255)])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        // Add sprites that make up the title screen
        CCSprite *title = [CCSprite spriteWithFile:@"you-win.png"];
        
        title.tag = 1;
        title.position = ccp(winSize.width * 0.5, winSize.height * 0.75f);
        
        id actionTitleMove = [CCMoveTo actionWithDuration:1.0f position:ccp(winSize.width * 0.5f, winSize.height * 0.5f)];
        id bounceTitleMove = [CCEaseBounceOut actionWithAction:actionTitleMove];
        
        [self addChild:title z:0];
        
        [title runAction:bounceTitleMove];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:5], [CCCallFunc actionWithTarget:self selector:@selector(gameCompleteDone)], nil]];
    }
    return self;
}

-(void)gameCompleteDone {
    TitleScreenScene *titleScene = [TitleScreenScene node];
    [[CCDirector sharedDirector] replaceScene:titleScene];
}

-(void)dealloc {
    [super dealloc];
}

@end