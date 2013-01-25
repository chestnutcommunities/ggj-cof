//
//  Gold.m
//  TileGame
//
//  Created by Shingo Tamura on 6/10/12.
//
//

#import "Human.h"
#import "CommonProtocol.h"

@implementation Human

-(void) dealloc {
    [_crouchAnim release];
    _crouchAnim = nil;
    [_jumpAnim release];
    _jumpAnim = nil;
    [_landAnim release];
    _landAnim = nil;
    
    [super dealloc];
}

-(void) loadAnimations {
    NSMutableArray *crouchAnimFrames = [NSMutableArray array];
    [crouchAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninja-normal.png"]];
    [crouchAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninja-sitting-half.png"]];
    [crouchAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninja-sitting-full.png"]];
    _crouchAnim = [[CCAnimation animationWithFrames:crouchAnimFrames delay:0.1f] retain];
    
    NSMutableArray *jumpAnimFrames = [NSMutableArray array];
    [jumpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninja-sitting-full.png"]];
    [jumpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninja-sitting-half.png"]];
    [jumpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninja-normal.png"]];
    [jumpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninja-jumping.png"]];
    _jumpAnim = [[CCAnimation animationWithFrames:jumpAnimFrames delay:0.1f] retain];
    
    NSMutableArray *landAnimFrames = [NSMutableArray array];
    [landAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninja-landing.png"]];
    [landAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninja-normal.png"]];
    _landAnim = [[CCAnimation animationWithFrames:landAnimFrames delay:0.5f] retain];
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime andGameObject:(GameObject *)gameObject {
}

-(void) initiateLanding {
    if (self.characterState != kStateJumping) {
        return;
    }
    
    if (_landAnim != nil) {
        if (_animationHandle != nil) {
            [self stopAction:_animationHandle];
            _animationHandle = nil;
        }
        _animationHandle = [[CCAnimate actionWithAnimation:_landAnim restoreOriginalFrame:NO] retain];
        
        [self runAction:_animationHandle];
    }
    
    self.characterState = kStateLanding;
}

-(void) initiateJump {
    if (self.characterState != kStateCrouching) {
        return;
    }
    
    if (_jumpAnim != nil) {
        if (_animationHandle != nil) {
            [self stopAction:_animationHandle];
            _animationHandle = nil;
        }
        _animationHandle = [[CCAnimate actionWithAnimation:_jumpAnim restoreOriginalFrame:NO] retain];
        
        [self runAction:_animationHandle];
    }
    
    self.characterState = kStateJumping;
}

-(void) initiateCrouch {
    if (self.characterState == kStateCrouching) {
        return;
    }
    
    if (_crouchAnim != nil) {
        if (_animationHandle != nil) {
            [self stopAction:_animationHandle];
            _animationHandle = nil;
        }
        _animationHandle = [[CCAnimate actionWithAnimation:_crouchAnim restoreOriginalFrame:NO] retain];
        
        [self runAction:_animationHandle];
    }
    
    self.characterState = kStateCrouching;
}

-(id) init
{
    if( (self=[super init]) )
    {
        self.characterState = kStateIdle;
        [self loadAnimations];
    }
    return self;
}

@end