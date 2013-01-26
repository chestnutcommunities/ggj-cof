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
#import "GameCharacter.h"

@implementation GamePlayInputLayer

@synthesize movingThreshold = _movingThreshold;

- (void) dealloc
{
    _leftJoystick = nil;
    [_leftJoystick release];
    
	[super dealloc];
}

-(CGPoint) applyVelocity: (CGPoint)velocity position:(CGPoint)position delta:(ccTime)delta {
	return CGPointMake(position.x + velocity.x * delta, position.y + velocity.y * delta);
}

-(void)applyDirectionalJoystick:(SneakyJoystick*)joystick toNode:(GameCharacter*)node forTimeDelta:(ccTime)delta
{
	// you can create a velocity specific to the node if you wanted, just supply a different multiplier
	// which will allow you to do a parallax scrolling of sorts
	//CGPoint scaledVelocity = ccpMult(joystick.velocity, 240.0f);
    
    if (joystick.isActive) {
        // apply the scaled velocity to the position over delta
        //[_gameLayer moveHero:node.position];
        //node.position = [self applyVelocity:scaledVelocity position:node.position delta:delta];
        
        _tmpMovingDelta += delta;
        
        if (_tmpMovingDelta >= _movingThreshold) {
            CGPoint newPosition = ccp(node.position.x, node.position.y);
            
            _tmpMovingDelta = 0.0f;
            
            FacingDirection dir;
			
			float degreeOffset = 1.41; // 45 degree angle is squareroot of 2 which is approx 1.41
			
			//Facing direction of hero
            if (joystick.degrees > 22.5f && joystick.degrees < 67.5f) {
                // NE
                dir = kFacingRight;
                newPosition.y += node.speed/degreeOffset;
				newPosition.x += node.speed/degreeOffset;
            }
			else if (joystick.degrees >= 67.5f && joystick.degrees <= 112.5) {
                // N
                dir = kFacingUp;
                newPosition.y += node.speed;
            }
			else if (joystick.degrees > 112.5f && joystick.degrees < 157.5f) {
                // NW
                dir = kFacingLeft;
                newPosition.y += node.speed/degreeOffset;
				newPosition.x -= node.speed/degreeOffset;
            }
			else if (joystick.degrees >= 157.5f && joystick.degrees <= 202.5f) {
                // W
                dir = kFacingLeft;
                newPosition.x -= node.speed;
            }
            else if (joystick.degrees > 202.5f && joystick.degrees < 247.5f) {
                // SW
                dir = kFacingLeft;
                newPosition.x -= node.speed/degreeOffset;
				newPosition.y -= node.speed/degreeOffset;
            }
            else if (joystick.degrees >= 247.5f && joystick.degrees <= 292.5f) {
                // S
                dir = kFacingDown;
                newPosition.y -= node.speed;
            }
			else if (joystick.degrees >= 292.5f && joystick.degrees <= 337.5f) {
                // SE
                dir = kFacingRight;
                newPosition.x += node.speed/degreeOffset;
				newPosition.y -= node.speed/degreeOffset;
            }
            else {
                // E
                dir = kFacingRight;
                newPosition.x += node.speed;
            }
			
            [_gameLayer movePlayer:newPosition facing:dir];
        }
    }
}

-(void)update:(ccTime)deltaTime {
    // need to add [glView setMultipleTouchEnabled:YES]; to AppDelegate.m to enable multi-touch
    [self applyDirectionalJoystick:_leftJoystick toNode:(GameCharacter*)_gameLayer.player forTimeDelta:deltaTime];
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
    leftJoy.position = ccp(80, 80); // 64 + 16 = 80
    leftJoy.backgroundSprite = [[CCSprite spriteWithFile:@"wheel.png"] retain];
    leftJoy.thumbSprite = [CCSprite spriteWithFile:@"lever.png"];    
    leftJoy.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0, 0, 128, 128)];
    _leftJoystick = [leftJoy.joystick retain];
    
    [self addChild:leftJoy z:2];
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
