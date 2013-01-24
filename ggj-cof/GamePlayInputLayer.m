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
#import "ColoredCircleSprite.h"

@implementation GamePlayInputLayer

- (void) dealloc
{
    [_rightButton release];
    _rightButton = nil;
    
	[super dealloc];
}

-(CGPoint) applyVelocity: (CGPoint)velocity position:(CGPoint)position delta:(ccTime)delta {
	return CGPointMake(position.x + velocity.x * delta, position.y + velocity.y * delta);
}

-(void)update:(ccTime)deltaTime {
    // need to add [glView setMultipleTouchEnabled:YES]; to AppDelegate.m to enable multi-touch
}

-(void) onEnter
{
    CCLOG(@"GamePlayInputLayer onEnter.");
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:2 swallowsTouches:YES];
    [super onEnter];
}
-(void) onExit
{
    CCLOG(@"GamePlayInputLayer onExit.");
    [[CCTouchDispatcher sharedDispatcher] removeDelegate: self];
    [super onExit];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"GamePlayInputLayer touched.");
	return NO;
}

-(void)initJoystickAndButtons {
    // initialize a joystick
    SneakyJoystickSkinnedBase *leftJoy = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    leftJoy.position = ccp(64, 64);
    leftJoy.backgroundSprite = [CCSprite spriteWithFile:@"wheel.png"];
    leftJoy.thumbSprite = [CCSprite spriteWithFile:@"lever.png"];    
    leftJoy.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,128,128)];
    _leftJoystick = [leftJoy.joystick retain];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    SneakyButtonSkinnedBase *rightButton = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    rightButton.position = ccp(winSize.width-64.0f, 64.0f);
    rightButton.defaultSprite = [CCSprite spriteWithFile:@"released.png"];
    rightButton.activatedSprite = [CCSprite spriteWithFile:@"grabbed.png"];
    rightButton.pressSprite = [CCSprite spriteWithFile:@"grabbed.png"];
    rightButton.button = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, 128, 128)];
    [rightButton.button setRadius:128.0f];
    _rightButton = [rightButton.button retain];
    _rightButton.isHoldable = YES;
    
    [self addChild:leftJoy z:2];
    [self addChild:rightButton z:2];
}

-(id) init
{
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
        
        [self initJoystickAndButtons];
        [self scheduleUpdate];
    }
    return self;
}

@synthesize gameLayer = _gameLayer;

@end
