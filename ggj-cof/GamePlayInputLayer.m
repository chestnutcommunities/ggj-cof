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

@synthesize up = _up;
@synthesize down = _down;
@synthesize left = _left;
@synthesize right = _right;

@synthesize heldUp = _heldUp;
@synthesize heldDown = _heldDown;
@synthesize heldLeft = _heldLeft;
@synthesize heldRight = _heldRight;

@synthesize gameLayer = _gameLayer;

- (void) dealloc {
	self.up = nil;
	self.down = nil;
    self.left = nil;
    self.right = nil;
    
	[_up release];
	[_down release];
	[_left release];
	[_right release];
    
	[super dealloc];
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
            
			//Facing direction of hero
            if (joystick.degrees >= 45.0f && joystick.degrees < 135.0f) {
                // N
                dir = kFacingUp;
                newPosition.y += node.speed;
            }
			else if (joystick.degrees >= 135.0f && joystick.degrees < 225.0f) {
                // W
                dir = kFacingLeft;
                newPosition.x -= node.speed;
            }
            else if (joystick.degrees >= 255.0f && joystick.degrees < 315.0f) {
                // S
                dir = kFacingDown;
                newPosition.y -= node.speed;
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
    BOOL doMove = NO;
    
    if (_heldUp || _heldDown || _heldLeft || _heldRight) {
        doMove = YES;
    }
    
    if (!doMove) {
        _tmpMovingDelta += 0;
        return;
    }
    
    _tmpMovingDelta += deltaTime;
    
    if (_tmpMovingDelta >= _movingThreshold) {
        GameCharacter* subject = (GameCharacter*)_gameLayer.player;
        
        FacingDirection dir;
        CGPoint newPosition = ccp(subject.position.x, subject.position.y);
        
        if (_heldUp) {
            dir = kFacingUp;
            newPosition.y += subject.speed;
        }
        else if (_heldDown) {
            dir = kFacingDown;
            newPosition.y -= subject.speed;

        }
        else if (_heldLeft) {
            dir = kFacingLeft;
            newPosition.x -= subject.speed;
        }
        else {
            dir = kFacingRight;
            newPosition.x += subject.speed;
        }
        
        [_gameLayer movePlayer:newPosition facing:dir];
    }
}

-(void) onEnter
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:2 swallowsTouches:YES];
    [super onEnter];
}
-(void) onExit
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate: self];
    [super onExit];
}


-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView: [touch view]];
    
    CGRect upBox = CGRectMake(_up.position.x - (_up.size.width / 2), _up.position.y - (_up.size.height / 2), _up.size.width, _up.size.height);
    CGRect downBox = CGRectMake(_down.position.x - (_down.size.width / 2), _down.position.y - (_down.size.height / 2), _down.size.width, _down.size.height);
    CGRect leftBox = CGRectMake(_left.position.x - (_left.size.width / 2), _left.position.y - (_left.size.height / 2), _left.size.width, _left.size.height);
    CGRect rightBox = CGRectMake(_right.position.x - (_right.size.width / 2), _right.position.y - (_right.size.height / 2), _right.size.width, _right.size.height);
    
    if (CGRectContainsPoint(upBox, location)) {
        _heldUp = YES;
    }
    else if (CGRectContainsPoint(downBox, location)) {
        _heldDown = YES;
    }
    else if (CGRectContainsPoint(leftBox, location)) {
        _heldLeft = YES;
    }
    else if (CGRectContainsPoint(rightBox, location)) {
        _heldRight = YES;
    }
    
	return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    _heldUp = _heldDown = _heldLeft = _heldRight = NO;
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    _heldUp = _heldDown = _heldLeft = _heldRight = NO;
}

-(id) init
{
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CGSize buttonSize = CGSizeMake(44, 44);
        
        CGSize upAndDownSize = CGSizeMake(winSize.width - (buttonSize.width * 2), buttonSize.height);
        CGSize leftAndRightSize = CGSizeMake(buttonSize.width, winSize.height - (buttonSize.height * 2));
        
        _up = [[[ColoredSquareSprite alloc] initWithColor:ccc4(255, 0, 0, 100) size:upAndDownSize] retain];
        _down = [[[ColoredSquareSprite alloc] initWithColor:ccc4(0, 255, 0, 100) size:upAndDownSize] retain];
        _left = [[[ColoredSquareSprite alloc] initWithColor:ccc4(0, 0, 255, 100) size:leftAndRightSize] retain];
        _right = [[[ColoredSquareSprite alloc] initWithColor:ccc4(255, 0, 255, 100) size:leftAndRightSize] retain];
        
        CGPoint upLocation = ccp(winSize.width * 0.5, buttonSize.height * 0.5);
        CGPoint downLocation = ccp(winSize.width * 0.5, winSize.height - (buttonSize.height * 0.5));
        CGPoint leftLocation = ccp(leftAndRightSize.width * 0.5, (leftAndRightSize.height * 0.5) + buttonSize.height);
        CGPoint rightLocation = ccp(winSize.width - (leftAndRightSize.width * 0.5), (leftAndRightSize.height * 0.5) + buttonSize.height);
        
        _up.position = upLocation;
        _down.position = downLocation;
        _left.position = leftLocation;
        _right.position = rightLocation;
        
        [self addChild:_up];
        [self addChild:_down];
        [self addChild:_left];
        [self addChild:_right];
        
        [self scheduleUpdate];
    }
    return self;
}

@end
