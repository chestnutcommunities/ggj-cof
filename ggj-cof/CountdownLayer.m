//
//  CountdownLayer.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 3/10/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CountdownLayer.h"
#import "SimpleAudioEngine.h"

@implementation CountdownLayer

@synthesize gameLayer = _gameLayer;

- (void) dealloc
{
    [_blackOut release];
	[super dealloc];
}

-(id) init
{
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
        _winSize = [[CCDirector sharedDirector] winSize];
        _currentAnimation = -1;
        _instructionsDone = NO;
        
        // tap to skip
        //CCLabelTTF *tapToSkip = [CCLabelTTF labelWithString:@"TAP TO SKIP" fontName:@"SoupofJustice" fontSize:35];
        //tapToSkip.position = ccp(_winSize.width * 0.75f, _winSize.height * 0.15f);
        //tapToSkip.color = ccGREEN;
        //[self addChild:tapToSkip z:1000];
        
        CCMenuItem* backToTitleButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-resume-normal.png"]
                                                                selectedSprite:[CCSprite spriteWithSpriteFrameName:@"button-resume-pressed.png"]
                                                                        target:self
                                                                      selector:@selector(skipTapped:)];
        backToTitleButton.position = ccp(_winSize.width * 0.95f, _winSize.height * 0.05f);
        CCMenu *menuList = [CCMenu menuWithItems:backToTitleButton, nil];
        menuList.position = CGPointZero;
        [self addChild:menuList z:1000];

        [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:YES];
        
        [self startBlackout];
    }
    return self;
}

-(void)showPlayerArrow {
    // show arrow
    CCSprite *playerArrow = [CCSprite spriteWithFile:@"arrow.png"];
    playerArrow.position = ccp(_winSize.width * 0.5, _winSize.height * 0.65f);
    playerArrow.opacity = 0;
    playerArrow.rotation = 90;
    
    id actionArrowDown = [CCMoveTo actionWithDuration:0.5f position:ccp(_winSize.width * 0.5f, _winSize.height * 0.60f)];
    id actionArrowUp = [CCMoveTo actionWithDuration:0.5f position:ccp(_winSize.width * 0.5f, _winSize.height * 0.65f)];
    
    [self addChild:playerArrow z:2];
    
    [playerArrow runAction: [CCSequence actions:
        [CCFadeIn actionWithDuration:0.35f],
        actionArrowDown,
        actionArrowUp,
        actionArrowDown,
        actionArrowUp,
        [CCFadeOut actionWithDuration:0.35f],
        [CCCallFunc actionWithTarget:self selector:@selector(animate)],
        nil]
     ];
}

-(void)hidePlayer {
    // hide label
    id actionLabelHideMove = [CCMoveTo actionWithDuration:0.8f position:ccp(_winSize.width * 0.5f, _winSize.height * 0.95f)];

    [_playerLabel runAction: [CCSequence actions:
        actionLabelHideMove,
        [CCFadeOut actionWithDuration:0.35f],
        [CCCallFunc actionWithTarget:self selector:@selector(animate)],
        nil]
    ];
}

-(void)showPlayer {
    _playerLabel = [CCLabelTTF labelWithString:@"This is You!" fontName:@"SoupofJustice" fontSize:46];
    _playerLabel.position = ccp(_winSize.width * 0.5, _winSize.height * 0.95f);
    _playerLabel.color = ccYELLOW;
    _playerLabel.opacity = 0;
    
    [self addChild:_playerLabel z:1];
    
    id actionLabelShowMove = [CCMoveTo actionWithDuration:0.75f position:ccp(_winSize.width * 0.5f, _winSize.height * 0.80f)];
    
    // show label
    [_playerLabel runAction: [CCSequence actions:
        [CCFadeIn actionWithDuration:0.35f],
        [CCEaseBounceOut actionWithAction:actionLabelShowMove],
        [CCCallFunc actionWithTarget:self selector:@selector(animate)],
        nil]
    ];
}

-(void)showScoreArrow {
    // show arrow
    CCSprite *playerArrow = [CCSprite spriteWithFile:@"arrow.png"];
    playerArrow.position = ccp(_winSize.width * 0.85f, _winSize.height * 0.80f);
    playerArrow.opacity = 0;
    playerArrow.rotation = 315;
    
    id actionArrowRight = [CCMoveTo actionWithDuration:0.5f position:ccp(_winSize.width * 0.90f, _winSize.height * 0.85f)];
    id actionArrowLeft = [CCMoveTo actionWithDuration:0.5f position:ccp(_winSize.width * 0.85f, _winSize.height * 0.80f)];
    
    [self addChild:playerArrow z:2];
    
    [playerArrow runAction: [CCSequence actions:
        [CCFadeIn actionWithDuration:0.35f],
        actionArrowRight,
        actionArrowLeft,
        actionArrowRight,
        actionArrowLeft,
        [CCFadeOut actionWithDuration:0.35f],
        [CCCallFunc actionWithTarget:self selector:@selector(animate)],
        nil]
     ];
}

-(void)showScore {
    _scoreLabel = [CCLabelTTF labelWithString:@"Aim High, Eat Low!" fontName:@"SoupofJustice" fontSize:46];
    _scoreLabel.position = ccp(_winSize.width * 0, _winSize.height * 0.90f);
    _scoreLabel.color = ccYELLOW;
    _scoreLabel.opacity = 0;
    
    [self addChild:_scoreLabel z:2];
    
    id actionTitleMove = [CCMoveTo actionWithDuration:1.0f position:ccp(_winSize.width * 0.35f, _winSize.height * 0.90f)];
    
    [_scoreLabel runAction: [CCSequence actions:
        [CCFadeIn actionWithDuration:0.35f],
        actionTitleMove,
        [CCCallFunc actionWithTarget:self selector:@selector(animate)],
        nil]
    ];
}

-(void)hideScore {
    [_scoreLabel runAction: [CCSequence actions:
        [CCFadeOut actionWithDuration:0.35f],
        [CCDelayTime actionWithDuration:0.4f],
        [CCCallFunc actionWithTarget:self selector:@selector(animate)],
        nil]
     ];
}

-(void)showPrey {
    _preyLabel = [CCLabelTTF labelWithString:@"GO!" fontName:@"SoupofJustice" fontSize:46];
    _preyLabel.position = ccp(_winSize.width * 0.5, _winSize.height * 0.95f);
    _preyLabel.color = ccYELLOW;
    _preyLabel.opacity = 0;
    
    [self addChild:_preyLabel z:3];
    
    id actionTitleMove = [CCMoveTo actionWithDuration:1.0f position:ccp(_winSize.width * 0.5f, _winSize.height * 0.65f)];
    id actionOutMove = [CCMoveTo actionWithDuration:1.0f position:ccp(_winSize.width * 0.5f, _winSize.height * 0.95f)];
    
    [_preyLabel runAction: [CCSequence actions:
        [CCDelayTime actionWithDuration:0.65f],
        [CCFadeIn actionWithDuration:0.35f],
        [CCEaseBounceOut actionWithAction:actionTitleMove],
        [CCDelayTime actionWithDuration:0.5f],
        [CCEaseBounceIn actionWithAction:actionOutMove],
        [CCFadeOut actionWithDuration:0.35f],
        [CCDelayTime actionWithDuration:0.65f],
        [CCCallFunc actionWithTarget:self selector:@selector(animate)],
        nil]
     ];
}

-(void)hideBlackout {
    if (_instructionsDone == YES) {
        _blackOut.visible = NO;
        self.visible = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeGame" object:self];
    }
}

-(void)startBlackout {
    // pause everything and blackout everything first
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseGame" object:self];
    CGPoint backgroundLocation = ccp(_winSize.width * 0.5f, _winSize.height * 0.5f);
    _blackOut = [[[ColoredSquareSprite alloc] initWithColor:ccc4(0, 0, 0, 150) size:_winSize] retain];
    _blackOut.position = backgroundLocation;
    _blackOut.visible = YES;
    [self addChild:_blackOut z:0];
    
    // animate instructions starting with player
    [self animate];
}

-(void)skipTapped:(CCMenuItem *)sender {
    [[SimpleAudioEngine sharedEngine] playEffect:@"3-key-strum.caf"];
    _instructionsDone = YES;
    if (_currentAnimation < 7) {
        _currentAnimation = 7;
        [self animate];
    }
}

-(void)animate {
    _currentAnimation++;
    switch (_currentAnimation) {
        case 0:
            [self startBlackout];
            break;
        case 1:
            [self showPlayer];
            break;
        case 2:
            [self showPlayerArrow];
            break;
        case 3:
            [self hidePlayer];
            break;
        case 4:
            [self showScore];
            break;
        case 5:
            [self showScoreArrow];
            break;
        case 6:
            [self hideScore];
            break;
        case 7:
            [self showPrey];
            _instructionsDone = YES;
        case 8:
            [self hideBlackout];
        default:
            break;
    }
}

@end
