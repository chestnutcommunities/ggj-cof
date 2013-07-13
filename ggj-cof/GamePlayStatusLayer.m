//
//  GamePlayGoldLayer.m
//  TileGame
//
//  Created by Shingo Tamura on 11/10/12.
//
//

#import "GamePlayStatusLayer.h"

@implementation GamePlayStatusLayer

@synthesize gameLayer = _gameLayer;

- (void) dealloc
{
    [_backPanel release];
    [_menuButton release];
    [_audioButton release];
    [_pauseButton release];
    [_playButton release];
  
    _backPanel = nil;
    _menuButton = nil;
    _audioButton = nil;
    _pauseButton = nil;
    _playButton = nil;
     
	[super dealloc];
}

-(void) onEnter
{
    [super onEnter];
}

-(void)showPanel
{
    _backPanel.visible = YES;
    _menuButton.visible = YES;
    _audioButton.visible = YES;
    _playButton.visible = YES;
    _pauseButton.visible = NO;
}

-(void)hidePanel
{
    _backPanel.visible = NO;
    _menuButton.visible = NO;
    _audioButton.visible = NO;
    _playButton.visible = NO;
    _pauseButton.visible = YES;
}

-(id) init
{
    if ((self = [super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGSize buttonSize = CGSizeMake(32, 32);
        CGSize gapSize = CGSizeMake(8, 8);
        CGSize backPanelSize = CGSizeMake(winSize.width * 0.25f, winSize.height);
        
        _backPanel = [[[ColoredSquareSprite alloc] initWithColor:ccc4(0, 0, 0, 200) size:backPanelSize] retain];
        _menuButton = [[[ColoredSquareSprite alloc] initWithColor:ccc4(0, 255, 0, 100) size:buttonSize] retain];
        _audioButton = [[[ColoredSquareSprite alloc] initWithColor:ccc4(0, 0, 255, 255) size:buttonSize] retain];
        _pauseButton = [[[ColoredSquareSprite alloc] initWithColor:ccc4(255, 0, 255, 255) size:buttonSize] retain];
        _playButton = [[[ColoredSquareSprite alloc] initWithColor:ccc4(255, 0, 255, 255) size:buttonSize] retain];
        
        CGPoint backPanelLocation = ccp(backPanelSize.width * 0.5f, backPanelSize.height * 0.5f);
        CGPoint menuButtonLocation = ccp(backPanelSize.width * 0.5f, (backPanelSize.height * 0.5f) + buttonSize.height);
        CGPoint auditButtonLocation = ccp(backPanelSize.width * 0.5f, (backPanelSize.height * 0.5f) - buttonSize.height);
        CGPoint pauseButtonLocation = ccp((buttonSize.width * 0.5f) + (gapSize.width * 0.5f), backPanelSize.height - (buttonSize.height * 0.5f) - (gapSize.width * 0.5f));
        CGPoint playButtonLocation = ccp(backPanelSize.width - (buttonSize.width * 0.5f) - (gapSize.width * 0.5f), backPanelSize.height - (buttonSize.height * 0.5f) - (gapSize.width * 0.5f));
        
        _backPanel.position = backPanelLocation;
        _menuButton.position = menuButtonLocation;
        _audioButton.position = auditButtonLocation;
        _pauseButton.position = pauseButtonLocation;
        _playButton.position = playButtonLocation;
        
        //[self addChild:_backPanel];
        //[self addChild:_menuButton];
        //[self addChild:_audioButton];
        //[self addChild:_pauseButton];
        //[self addChild:_playButton];
        
        [self hidePanel];
    }
    return self;
}

@end
