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

-(void)applyDirectionalJoystick:(SneakyJoystick*)joystick toNode:(GameCharacter*)node forTimeDelta:(ccTime)delta {
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

-(void) onEnter {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:2 swallowsTouches:YES];
    [super onEnter];
}
-(void) onExit {
    [[CCTouchDispatcher sharedDispatcher] removeDelegate: self];
    [super onExit];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView: [touch view]];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CGFloat buttonHalfWidth = _up.boundingBox.size.width / 2.0f;
    
    CGRect upBox = CGRectMake(_up.position.x - buttonHalfWidth, winSize.height - _up.position.y - buttonHalfWidth, _up.boundingBox.size.width, _up.boundingBox.size.height);
    CGRect downBox = CGRectMake(_down.position.x - buttonHalfWidth, winSize.height - _down.position.y - buttonHalfWidth, _down.boundingBox.size.width, _down.boundingBox.size.height);
    CGRect leftBox = CGRectMake(_left.position.x - buttonHalfWidth, winSize.height - _left.position.y - buttonHalfWidth, _left.boundingBox.size.width, _left.boundingBox.size.height);
    CGRect rightBox = CGRectMake(_right.position.x - buttonHalfWidth, winSize.height - _right.position.y - buttonHalfWidth, _right.boundingBox.size.width, _right.boundingBox.size.height);
    
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
        
        CGSize buttonSize = CGSizeMake(60, 60);
        
        _up = [[[ColoredSquareSprite alloc] initWithColor:ccc4(255, 0, 0, 100) size:buttonSize] retain];
        _down = [[[ColoredSquareSprite alloc] initWithColor:ccc4(0, 255, 0, 100) size:buttonSize] retain];
        _left = [[[ColoredSquareSprite alloc] initWithColor:ccc4(0, 0, 255, 100) size:buttonSize] retain];
        _right = [[[ColoredSquareSprite alloc] initWithColor:ccc4(255, 0, 255, 100) size:buttonSize] retain];
        
        CGPoint upLocation = ccp(buttonSize.width + (buttonSize.width * 0.8f), (buttonSize.height * 2.0f) + (buttonSize.height * 0.8f));
        CGPoint downLocation = ccp(buttonSize.width + (buttonSize.width * 0.8f), buttonSize.height * 0.8f);
        CGPoint leftLocation = ccp(buttonSize.width * 0.8f, buttonSize.height + (buttonSize.height * 0.8f));
        CGPoint rightLocation = ccp((buttonSize.height * 2.0f) + (buttonSize.height * 0.8f), buttonSize.height + (buttonSize.height * 0.8f));
        
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
