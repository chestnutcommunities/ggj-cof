//
//  Gold.h
//  TileGame
//
//  Created by Shingo Tamura on 6/10/12.
//
//

#import "Card.h"

@interface Human : Card {
    CCAnimation *_crouchAnim;
    CCAnimation *_jumpAnim;
    CCAnimation *_landAnim;
    CCAnimate *_animationHandle;
    
    CGFloat _factor;
    CGFloat _limit;
    CGFloat _momentum;
}

-(void) initiateJump;
-(void) initiateCrouch;
-(void) initiateLanding;

@end