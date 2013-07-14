//
//  GamePlayerInputLayer.m
//  TileGame
//
//  Created by Shingo Tamura on 8/09/12.
//
//

#import "GamePlayInputLayer.h"
#import "GamePlayRenderingLayer.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedJoystickExample.h"
#import "SneakyJoystickSkinnedDPadExample.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "ColoredSquareSprite.h"
#import "GameCharacter.h"

@implementation GamePlayInputLayer

@synthesize movingThreshold = _movingThreshold;

@synthesize gameLayer = _gameLayer;

@synthesize swipeLeftRecognizer = _swipeLeftRecognizer;
@synthesize swipeRightRecognizer = _swipeRightRecognizer;
@synthesize swipeUpRecognizer = _swipeUpRecognizer;
@synthesize swipeDownRecognizer = _swipeDownRecognizer;

- (void) dealloc
{
    [_swipeLeftRecognizer release];
    _swipeLeftRecognizer = nil;
    [_swipeRightRecognizer release];
    _swipeRightRecognizer = nil;
    [_swipeUpRecognizer release];
    _swipeUpRecognizer = nil;
    [_swipeDownRecognizer release];
    _swipeDownRecognizer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[super dealloc];
}

- (void) pauseGame:(NSNotification *) notification {
    _enabled = NO;
}

- (void) resumeGame:(NSNotification *) notification {
    _enabled = YES;
}

-(void)update:(ccTime)deltaTime {
    // need to add [glView setMultipleTouchEnabled:YES]; to AppDelegate.m to enable multi-touch
    if (_inputState == kStateAwaitingInput || !_enabled) {
        return;
    }
    
    _tmpMovingDelta += deltaTime;

    if (_tmpMovingDelta >= _movingThreshold) {
        GameCharacter* subject = (GameCharacter*)_gameLayer.player;
        
        FacingDirection dir;
        CGPoint newPosition = ccp(subject.position.x, subject.position.y);
        
        switch (_inputState) {
            case kStateSwipedUp:
                dir = kFacingUp;
                newPosition.y += subject.speed;
                break;
            case kStateSwipedDown:
                dir = kFacingDown;
                newPosition.y -= subject.speed;
                break;
            case kStateSwipedLeft:
                dir = kFacingLeft;
                newPosition.x -= subject.speed;
                break;
            case kStateSwipedRight:
                dir = kFacingRight;
                newPosition.x += subject.speed;
                break;
            default:
                break;
        }
        
        _tmpMovingDelta = 0;
        [_gameLayer movePlayer:newPosition facing:dir];
    }
}

-(void)handleLeftSwipe:(UISwipeGestureRecognizer*)sender {
    if (!_enabled) { return; }
    
    _inputState = kStateSwipedLeft;
}

-(void)handleRightSwipe:(UISwipeGestureRecognizer*)sender {
    if (!_enabled) { return; }

    _inputState = kStateSwipedRight;
}

-(void)handleUpSwipe:(UISwipeGestureRecognizer*)sender {
    if (!_enabled) { return; }

    _inputState = kStateSwipedUp;
}

-(void)handleDownSwipe:(UISwipeGestureRecognizer*)sender {
    if (!_enabled) { return; }

    _inputState = kStateSwipedDown;
}

// Then add these new methods
- (void)onEnter {
    self.swipeLeftRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)] autorelease];
    _swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:_swipeLeftRecognizer];
    
    self.swipeRightRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)] autorelease];
    _swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:_swipeRightRecognizer];
    
    self.swipeUpRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleUpSwipe:)] autorelease];
    _swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:_swipeUpRecognizer];
    
    self.swipeDownRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDownSwipe:)] autorelease];
    _swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:_swipeDownRecognizer];
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:2 swallowsTouches:YES];
    
    [super onEnter];
}

- (void)onExit {
    [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:_swipeLeftRecognizer];
    [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:_swipeRightRecognizer];
    [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:_swipeUpRecognizer];
    [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:_swipeDownRecognizer];
    
    [[CCTouchDispatcher sharedDispatcher] removeDelegate: self];
    
    [super onExit];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return YES;
}

-(id) init
{
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
        _enabled = YES;
        _inputState = kStateAwaitingInput;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseGame:) name:@"pauseGame" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeGame:) name:@"resumeGame" object:nil];

        [self scheduleUpdate];
    }
    return self;
}

@end
