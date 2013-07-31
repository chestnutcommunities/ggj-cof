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
#import "CreditsLayer.h"

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
    [gs loadGameProperties];
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

- (void)infoButtonTapped:(id)sender {
    [[SimpleAudioEngine sharedEngine] playEffect:@"3-key-strum.caf"];
    CreditsScene *scene = [CreditsScene node];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)audioButtonTapped:(id)sender {
    [[SimpleAudioEngine sharedEngine] playEffect:@"3-key-strum.caf"];
    
    // Change the displayed image on the button
    
    if (_audioOn) {
        // If it's currently on, show 'audio off' button
        [_audioButton setNormalImage:[CCSprite spriteWithSpriteFrameName:_audioOffButtonNormalName]];
        [_audioButton setSelectedImage:[CCSprite spriteWithSpriteFrameName:_audioOffButtonPressedName]];
    }
    else {
        // If it's currently off, show 'audio on' button
        [_audioButton setNormalImage:[CCSprite spriteWithSpriteFrameName:_audioOnButtonNormalName]];
        [_audioButton setSelectedImage:[CCSprite spriteWithSpriteFrameName:_audioOnButtonPressedName]];
    }
    
    _audioOn = !_audioOn;
    
    // Mute if audio turned off, Unmute if turned on
    [[SimpleAudioEngine sharedEngine] setMute:!_audioOn];
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
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"3-key-strum.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"hurt.caf"];
        
        // Set up logger
        //[[Logger sharedInstance] enable];
        //[[Logger sharedInstance] setFeature:LogType_GameObjects doEnable:YES];
        //[[Logger sharedInstance] setFeature:LogType_AIHelper doEnable:YES];
        //[[Logger sharedInstance] setFeature:LogType_General doEnable:YES];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGSize pixelSize = [[CCDirector sharedDirector] winSizeInPixels];
        CGSize buttonSize = CGSizeMake(40, 40);
        CGSize gapSize = CGSizeMake(12, 12);
        
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
        
        // Initialize spritesheet
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button-sprite.plist"];
        CCSpriteBatchNode* sheet = [CCSpriteBatchNode batchNodeWithFile:@"button-sprite.png"];
        [self addChild:sheet];

        // Set up audio button names
        _audioOnButtonNormalName = @"button-audio-on-normal.png";
        _audioOnButtonPressedName = @"button-audio-on-pressed.png";
        _audioOffButtonNormalName = @"button-audio-off-normal.png";
        _audioOffButtonPressedName = @"button-audio-off-pressed.png";

        NSString* audioButtonNormalName = _audioOnButtonNormalName;
        NSString* audioButtonPressedName = _audioOnButtonPressedName;

        // Cache current audio engine state
        _audioOn = ![[SimpleAudioEngine sharedEngine] mute];

        if (!_audioOn) {
            audioButtonNormalName = _audioOffButtonNormalName;
            audioButtonPressedName = _audioOffButtonPressedName;
        }
        
        // Set up menu buttons
        
        CCMenuItem* easyButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-easy-normal.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"button-easy-pressed.png"] target:self selector:@selector(startButtonTapped:)];
        easyButton.userData = 1;
        easyButton.position = ccp(winSize.width * 0.3f, winSize.height * 0.3f);
        
        CCMenuItem* mediumButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-med-normal.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"button-med-pressed.png"] target:self selector:@selector(startButtonTapped:)];
        mediumButton.userData = 2;
        mediumButton.position = ccp(winSize.width * 0.5f, winSize.height * 0.3f);
        
        CCMenuItemSprite* hardButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-hard-normal.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"button-hard-pressed.png"] target:self selector:@selector(startButtonTapped:)];
        hardButton.userData = 3;
        hardButton.position = ccp(winSize.width * 0.7f, winSize.height * 0.3f);
        
        // Set up info button
        CCMenuItemSprite* infoButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-info-normal.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"button-info-pressed.png"] target:self selector:@selector(infoButtonTapped:)];
        
        infoButton.position = ccp((buttonSize.width * 0.5f) + (gapSize.width * 0.5f), (buttonSize.height * 0.5f) + (gapSize.width * 0.5f));
        
        // Set up audio button
        _audioButton = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:audioButtonNormalName] selectedSprite:[CCSprite spriteWithSpriteFrameName:audioButtonPressedName] target:self selector:@selector(audioButtonTapped:)] retain];

        _audioButton.position = ccp(winSize.width - (buttonSize.width * 0.5f) - (gapSize.width * 0.5f), (buttonSize.height * 0.5f) + (gapSize.width * 0.5f));
        
        CCMenu* starMenu = [CCMenu menuWithItems:easyButton, mediumButton, hardButton, infoButton, _audioButton, nil];
        starMenu.position = CGPointZero;
        [self addChild:starMenu];
        
        [title runAction:bounceTitleMove];
        
        [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:YES];
    }
    return self;
}

-(void)dealloc {
    [_audioButton release];
    
    [super dealloc];
}

@end
