//
//  Player.m
//  ggj-cof
//
//  Created by Shingo Tamura on 29/06/13.
//
//

#import "Player.h"
#import "SimpleAudioEngine.h"

@implementation Player

-(void) loadAnimations {
    NSMutableArray *afUp = [NSMutableArray array];
    
    [afUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-back-1.png"]];
    [afUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-back-2.png"]];
    [afUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-back-3.png"]];
    [afUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-back-4.png"]];
    [afUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-back-5.png"]];
    [afUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-back-6.png"]];
    
    _upAnim = [[CCAnimation animationWithFrames:afUp delay:0.1f] retain];
    
    NSMutableArray *afDown = [NSMutableArray array];
    
    [afDown addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-front-1.png"]];
    [afDown addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-front-2.png"]];
    [afDown addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-front-3.png"]];
    [afDown addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-front-4.png"]];
    [afDown addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-front-5.png"]];
    [afDown addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-front-6.png"]];
    
    _downAnim = [[CCAnimation animationWithFrames:afDown delay:0.1f] retain];
    
    NSMutableArray *afLeft = [NSMutableArray array];
    
    [afLeft addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-left-1.png"]];
    [afLeft addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-left-2.png"]];
    [afLeft addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-left-3.png"]];
    [afLeft addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-left-4.png"]];
    [afLeft addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-left-5.png"]];
    [afLeft addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-left-6.png"]];
    
    _leftAnim = [[CCAnimation animationWithFrames:afLeft delay:0.1f] retain];
    
    NSMutableArray *afRight = [NSMutableArray array];
    
    [afRight addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-right-1.png"]];
    [afRight addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-right-2.png"]];
    [afRight addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-right-3.png"]];
    [afRight addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-right-4.png"]];
    [afRight addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-right-5.png"]];
    [afRight addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hero-right-6.png"]];
    
    _rightAnim = [[CCAnimation animationWithFrames:afRight delay:0.1f] retain];
}

-(void)setNumber:(int)number {
    if (number <= 0) {
        return;
    }
    
    _number = number;
    
    if (_number >= kCardMaxNumber) {
        _number = kCardMaxNumber;
    }
    
    NSString *numberString;
    numberString = [NSString stringWithFormat:@"hero-number-%d.png", _number];
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:numberString];
    [_numberPanel setDisplayFrame:frame];
}

-(id) init
{
    if((self=[super init])) {
        // Don't delay sprite flipping for player
        _delayFlip = NO;
    }
    return self;
}
@end
