//
//  TitleScreenScene.m
//  TileGame
//
//  Created by Shingo Tamura on 26/07/12.
//  Copyright (c) 2012 Chopsticks On Fire. All rights reserved.
//

#import "TitleScreenScene.h"
#import "SimpleAudioEngine.h"
#import "ColoredCircleSprite.h"
#import "ColoredSquareSprite.h"
#import "KingOfHeartsLayer.h"
#import "Logger.h"
#import "GameSetting.h"

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

- (void)replaceScene:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[KingOfHeartsLayer scene]];
}

- (void)startButtonTapped:(CCMenuItem *)sender {
    [[SimpleAudioEngine sharedEngine] playEffect:@"selection.caf"];
    GameSetting *gs = [GameSetting instance];
    [gs resetGameProperties];
    
    gs.difficultyLevel = (NSObject *)sender.userData;
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2.0f], [CCCallFunc actionWithTarget:self selector:@selector(replaceScene:)], nil]];
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
        
        // Turn on/off audio
        [[SimpleAudioEngine sharedEngine] setEnabled:YES];
        
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"main-theme.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"win!.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"lose!.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"selection.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"draw-card.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"consumed.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"press.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"hurt.caf"];
        
        // Set up logger
        //[[Logger sharedInstance] enable];
        //[[Logger sharedInstance] setFeature:LogType_GameObjects doEnable:YES];
        //[[Logger sharedInstance] setFeature:LogType_AIHelper doEnable:YES];
        //[[Logger sharedInstance] setFeature:LogType_General doEnable:YES];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGSize pixelSize = [[CCDirector sharedDirector] winSizeInPixels];
        
        // Add sprites that make up the title screen
        CCSprite *bg, *title;
        
        if (pixelSize.width == 1136) {
            // iPhone 5
            bg = [CCSprite spriteWithFile:@"bg-1136x640.png"];
        }
        else {
            // iPhone 4
            bg = [CCSprite spriteWithFile:@"bg-960x640.png"];
        }
        
        title = [CCSprite spriteWithFile:@"title.png"];
        
        bg.tag = 1;
        bg.anchorPoint = CGPointMake(0, 0);
        title.tag = 1;
        title.position = ccp(winSize.width * 0.5, winSize.height * 0.95f);
        
        id actionTitleMove = [CCMoveTo actionWithDuration:1.0f position:ccp(winSize.width * 0.5f, winSize.height * 0.65f)];
        id bounceTitleMove = [CCEaseBounceOut actionWithAction:actionTitleMove];
        
        [self addChild:bg z:0];
        [self addChild:title z:0];
        
        CCMenuItem *easyButton = [CCMenuItemImage itemFromNormalImage:@"difficulty-button.png" selectedImage:@"difficulty-button-hover.png" target:self selector:@selector(startButtonTapped:)];
        easyButton.userData = 1;
        easyButton.position = ccp(winSize.width *0.25f, winSize.height * 0.3f);
        
        CCMenuItem *mediumButton = [CCMenuItemImage itemFromNormalImage:@"difficulty-button.png" selectedImage:@"difficulty-button-hover.png" target:self selector:@selector(startButtonTapped:)];
        mediumButton.userData = 2;
        mediumButton.position = ccp(winSize.width *0.5f, winSize.height * 0.3f);
        
        CCMenuItem *hardButton = [CCMenuItemImage itemFromNormalImage:@"difficulty-button.png" selectedImage:@"difficulty-button-hover.png" target:self selector:@selector(startButtonTapped:)];
        hardButton.userData = 3;
        hardButton.position = ccp(winSize.width *0.75f, winSize.height * 0.3f);
        
        CCMenu *starMenu = [CCMenu menuWithItems:easyButton, mediumButton, hardButton, nil];
        starMenu.position = CGPointZero;
        [self addChild:starMenu];
        
        [title runAction:bounceTitleMove];
        
        [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:YES];
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
}

@end
