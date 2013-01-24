//
//  TitleScreenScene.m
//  TileGame
//
//  Created by Shingo Tamura on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleScreenScene.h"
#import "GamePlayRenderingLayer.h"
#import "SimpleAudioEngine.h"
#import "ColoredCircleSprite.h"
#import "ColoredSquareSprite.h"

@implementation TitleScreenScene
@synthesize layer = _layer;

- (id)init {
    if ((self = [super init])) {
        self.layer = [TitleScreenLayer node];
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

@implementation TitleScreenLayer

- (void)startButtonTapped:(id)sender
{
    CCLOG(@"Start Button Tapped");
    
    [[CCDirector sharedDirector] replaceScene:[GamePlayRenderingLayer scene]];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TitleScreenLayer *layer = [TitleScreenLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

-(id) init {
    if ((self=[super initWithColor:ccc4(0, 0, 0, 255)])) {
        self.isTouchEnabled = YES;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        ColoredSquareSprite* normal = [ColoredSquareSprite squareWithColor:ccc4(150, 150, 150, 255) size:CGSizeMake(100, 100)];
        ColoredSquareSprite* hover = [ColoredSquareSprite squareWithColor:ccc4(255, 255, 255, 255) size:CGSizeMake(100, 100)];
        
        CCMenuItemSprite* item = [CCMenuItemSprite itemFromNormalSprite:normal selectedSprite:hover target:self selector:@selector(startButtonTapped:)];        item.position = ccp(winSize.width * 0.5, winSize.height * 0.5);
        
        CCMenu *starMenu = [CCMenu menuWithItems:item, nil];
        starMenu.position = CGPointZero;
        [self addChild:starMenu];

    }
    return self;
}

-(void)dealloc {
    [super dealloc];
}

@end
