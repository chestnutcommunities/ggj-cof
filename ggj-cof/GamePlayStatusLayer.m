//
//  GamePlayGoldLayer.m
//  TileGame
//
//  Created by Shingo Tamura on 11/10/12.
//
//

#import "SimpleAudioEngine.h"
#import "GamePlayStatusLayer.h"

@implementation GamePlayStatusLayer

@synthesize gameLayer = _gameLayer;

- (void) dealloc
{
    [_background release];
    [_menuPanel release];
    [_pauseButtonMenu release];
    [_audioButton release];
    
	[super dealloc];
}

-(void) onEnter
{
    [super onEnter];
}

- (void)menuPanelPutAway:(id)sender {
    _menuPanel.visible = NO;
    _background.visible = NO;
}

-(void)pauseButtonHidden:(id)sender {
    _pauseButtonMenu.visible = NO;
    _pauseButtonMenu.opacity = 0;
}

-(void)showPanel
{
    // show menu panel
    _menuPanel.visible = YES;
    CGPoint backPanelLocation = ccp(_menuPanel.size.width * 0.5f, _menuPanel.size.height * 0.5f);
    id backPanelMoveTo = [CCMoveTo actionWithDuration:0.2f position:backPanelLocation];
    [_menuPanel runAction:backPanelMoveTo];
    
    _background.visible = YES;
    
    // hide pause button
    id pauseButtonFadeOut = [CCFadeOut actionWithDuration:0.4f];
    id pauseButtonFadeOutDone = [[CCCallFuncN actionWithTarget:self selector:@selector(pauseButtonHidden:)] retain];
    [_pauseButtonMenu runAction:[CCSequence actions:pauseButtonFadeOut, pauseButtonFadeOutDone, nil]];
}

-(void)hidePanel
{
    // hide menu panel
    CGPoint menuPanelLocation = ccp(-_menuPanel.size.width * 0.5f, _menuPanel.size.height * 0.5f);
    id menuPanelMoveTo = [CCMoveTo actionWithDuration:0.2f position:menuPanelLocation];
    id menuPanelMoveDone = [[CCCallFuncN actionWithTarget:self selector:@selector(menuPanelPutAway:)] retain];
    [_menuPanel runAction:[CCSequence actions:menuPanelMoveTo, menuPanelMoveDone, nil]];
    
    _background.visible = YES;
    
    // show pause button
    _pauseButtonMenu.visible = YES;
    id pauseButtonFadeIn = [CCFadeIn actionWithDuration:0.4f];
    [_pauseButtonMenu runAction:pauseButtonFadeIn];
}

- (void)pauseButtonTapped:(id)sender {
    if (!_menuPanel.visible) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"press.caf"];
        [self showPanel];
        // Notify subscribers game is to be paused
		[[NSNotificationCenter defaultCenter] postNotificationName:@"pauseGame" object:self];
    }
}

- (void)resumeButtonTapped:(id)sender {
    if (_menuPanel.visible) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"press.caf"];
        [self hidePanel];
        // Notify subscribers game is to be resumed
		[[NSNotificationCenter defaultCenter] postNotificationName:@"resumeGame" object:self];
    }
}

- (void)audioButtonTapped:(id)sender {
    [[SimpleAudioEngine sharedEngine] playEffect:@"press.caf"];
    
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
    [[SimpleAudioEngine sharedEngine] setMute:!_audioOn];
}

- (void)menuButtonTapped:(id)sender {
    [[SimpleAudioEngine sharedEngine] playEffect:@"press.caf"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backToMenu" object:self];
}

-(void)buildComponents {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGSize buttonSize = CGSizeMake(32, 32);
    CGSize gapSize = CGSizeMake(8, 8);
    CGSize menuPanelSize = CGSizeMake(winSize.width * 0.25f, winSize.height);
    CGPoint menuPanelLocation = ccp(-menuPanelSize.width * 0.5f, menuPanelSize.height * 0.5f);
    CGPoint backgroundLocation = ccp(winSize.width * 0.5f, winSize.height * 0.5f);
    NSString* audioButtonNormalName = _audioOnButtonNormalName;
    NSString* audioButtonPressedName = _audioOnButtonPressedName;
    
    if (!_audioOn) {
        audioButtonNormalName = _audioOffButtonNormalName;
        audioButtonPressedName = _audioOffButtonPressedName;
    }
    
    _menuPanel = [[[ColoredSquareSprite alloc] initWithColor:ccc4(0, 0, 0, 200) size:menuPanelSize] retain];
    _menuPanel.position = menuPanelLocation;
    _menuPanel.visible = NO;
    
    _background = [[[ColoredSquareSprite alloc] initWithColor:ccc4(0, 0, 0, 125) size:winSize] retain];
    _background.position = backgroundLocation;
    _background.visible = NO;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button-sprite.plist"];
    CCSpriteBatchNode *sheet = [CCSpriteBatchNode batchNodeWithFile:@"button-sprite.png"];
    [self addChild:sheet];
    
    // Set up pause button
    CCMenuItemSprite *pauseButton = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-pause-normal.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"button-pause-pressed.png"] target:self selector:@selector(pauseButtonTapped:)] retain];
    
    CGPoint pauseButtonLocation = ccp((buttonSize.width * 0.5f) + (gapSize.width * 0.5f), menuPanelSize.height - (buttonSize.height * 0.5f) - (gapSize.width * 0.5f));
    
    // Add menu for pause button
    _pauseButtonMenu = [[CCMenu menuWithItems:pauseButton, nil] retain];
    _pauseButtonMenu.position = pauseButtonLocation;
    
    // Set up contents of menu panel
    CCMenuItemSprite *resumeButton = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-resume-normal.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"button-resume-pressed.png"] target:self selector:@selector(resumeButtonTapped:)] retain];
    
    CCMenuItemSprite *menuButton = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-menu-normal.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"button-menu-pressed.png"] target:self selector:@selector(menuButtonTapped:)] retain];
    
    _audioButton = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:audioButtonNormalName] selectedSprite:[CCSprite spriteWithSpriteFrameName:audioButtonPressedName] target:self selector:@selector(audioButtonTapped:)] retain];
    
    CGPoint resumeButtonLocation = ccp((menuPanelSize.width * 0.5f) - (buttonSize.width * 0.5f) - (gapSize.width * 0.5f), (menuPanelSize.height * 0.5f) - (buttonSize.height * 0.5f) - (gapSize.width * 0.5f));
    CGPoint menuButtonLocation = ccp(0.0f, buttonSize.height);
    CGPoint audioButtonLocation = ccp(0.0f, -buttonSize.height);
    
    resumeButton.position = resumeButtonLocation;
    menuButton.position = menuButtonLocation;
    _audioButton.position = audioButtonLocation;
    
    CCMenu *menu = [[CCMenu menuWithItems:resumeButton, menuButton, _audioButton, nil] retain];
    menu.position = CGPointZero;
    
    [self addChild:_pauseButtonMenu z:2];
    [_menuPanel addChild:menu];
    [self addChild:_menuPanel z:3];
    [self addChild:_background z:1];
}

-(id) init
{
    if ((self = [super init])) {
        _audioOnButtonNormalName = @"button-audio-on-normal.png";
        _audioOnButtonPressedName = @"button-audio-on-pressed.png";
        _audioOffButtonNormalName = @"button-audio-off-normal.png";
        _audioOffButtonPressedName = @"button-audio-off-pressed.png";

        _audioOn = ![[SimpleAudioEngine sharedEngine] mute];
        
        [self buildComponents];
    }
    return self;
}

@end
