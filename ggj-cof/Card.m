//
//  Card.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/26/13.
//  Copyright 2013 Chopsticks On Fire. All rights reserved.
//

#import "Card.h"
#import "AIHelper.h"
#import "TileMapManager.h"

@implementation Card

@synthesize originPoint = _originPoint;
@synthesize destinationPoints = _destinationPoints;
@synthesize currentDestinationPath = _currentDestinationPath;
@synthesize previousDirection = _previousDirection;
@synthesize facing = _facing;
@synthesize frontOrder = _frontOrder;
@synthesize realPosition = _realPosition;

-(void) dealloc {
    _walkingAnim = nil;
    _destinationPoints = nil;
    
    [_walkingAnim release];
    [_destinationPoints release];
    
    [super dealloc];
}

-(void)face:(FacingDirection)direction {
    switch (direction) {
        case kFacingRight:
            if (_facing != kFacingRight) {
                _facing = kFacingRight;
                self.flipX = NO;
            }
            break;
        case kFacingLeft:
            if (_facing != kFacingLeft) {
                _facing = kFacingLeft;
                self.flipX = YES;
            }
            break;
        default:
            // keep current facing direction
            break;
    }
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
    numberString = [NSString stringWithFormat:@"%d.png", _number];
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:numberString];
    [_numberPanel setDisplayFrame:frame];
}

-(void)setRealPosition:(CGPoint)mapPosition {
    _realPosition = mapPosition;
}

-(void) loadAnimations {
    NSMutableArray *animFrames = [NSMutableArray array];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-1.png"]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-2.png"]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-3.png"]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-4.png"]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-5.png"]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-6.png"]];
    
    // set up walking animations
    _walkingAnim = [[CCAnimation animationWithFrames:animFrames delay:0.1f] retain];
}

-(void)setSuit:(CardSuit)suit {
    _cardSuit = suit;
    
    NSString *suitString;
    switch (suit) {
        case kCardSuitClover:
            suitString = @"clubs.png";
            break;
        case kCardSuitDiamond:
            suitString = @"diamonds.png";
            break;
        case kCardSuitSpades:
            suitString = @"spades.png";
            break;
        default:
            // hearts
            suitString = @"hearts.png";
            break;
    }
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:suitString];
    [_suitPanel setDisplayFrame:frame];
}

-(int)getNumber {
    return _number;
}

-(CardSuit)getSuit {
    return _cardSuit;
}

-(CGPoint)getCardDisplayPosition {
    CGPoint displayPosition;
    displayPosition.x = _realPosition.x + _frontOrder * 5;
    displayPosition.y = _realPosition.y - _frontOrder * 5;
    
    return displayPosition;
}

-(CGRect)chaseRunBoundingBox {
    CGRect cardSightBoundingBox;
    CGRect cardBoundingBox = [self adjustedBoundingBox];
	cardSightBoundingBox = CGRectMake(cardBoundingBox.origin.x - cardBoundingBox.size.width*7.0f,
										cardBoundingBox.origin.y - cardBoundingBox.size.height*7.0f,
										cardBoundingBox.size.width*14.0f,
										cardBoundingBox.size.height*14.0f);
	return cardSightBoundingBox;
}

-(void) updateStateWithTileMapManager:(ccTime)deltaTime andGameObject:(GameObject *)gameObject tileMapManager:(TileMapManager *)tileMapManager {
    CGRect heroBoundingBox = [gameObject adjustedBoundingBox];
	CGRect cardSightBoundingBox = [self chaseRunBoundingBox];
    
    BOOL isHeroWithinSight = CGRectIntersectsRect(heroBoundingBox, cardSightBoundingBox)? YES : NO;
    
    if (isHeroWithinSight) {
        [self changeState:kStateChasing];
    }
    else {
        [self changeState:kStateWalking];
    }
}

-(void) startWalking {
    [_walkingAnim setDelay:0.1f];
    id action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_walkingAnim restoreOriginalFrame:YES]] retain];
    [self runAction:action];
    [self face:_facing];
}

-(void) startRunning {
    [_walkingAnim setDelay:0.05f];
    id action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_walkingAnim restoreOriginalFrame:YES]] retain];
    [self runAction:action];
    [self face:_facing];
}

-(void) stopWalking {
    [self stopAllActions];
}

-(void) handleDead:(id)sender {
    self.characterState = kStateDead;
    self.visible = NO;
}

-(void)changeState:(CharacterStates)newState {
    if (self.characterState == newState) {
        return;
    }
    
    switch (newState) {
        case kStateDying:
            [self stopAllActions];
            [self stopWalking];
            
            id actionFade1 = [CCFadeOut actionWithDuration:0.5f];
            id actionScale1 = [CCScaleTo actionWithDuration:0.5f scale:0.0f];
            id actionRotate1 = [CCRotateTo actionWithDuration:0.5f angle:180];
            
            id actionFade2 = [CCFadeOut actionWithDuration:0.5f];
            id actionScale2 = [CCScaleTo actionWithDuration:0.5f scale:0.0f];
            id actionRotate2 = [CCRotateTo actionWithDuration:0.5f angle:180];
            
            id actionFade3 = [CCFadeOut actionWithDuration:0.5f];
            id actionScale3 = [CCScaleTo actionWithDuration:0.5f scale:0.0f];
            id actionRotate3 = [CCRotateTo actionWithDuration:0.5f angle:180];
            
            id aciontSequence = [CCSequence actions: [CCDelayTime actionWithDuration:0.5f], [CCCallFunc actionWithTarget:self selector:@selector(handleDead:)], nil];
            
            self.characterState = newState;
            
            [_suitPanel runAction:actionFade1];
            [_suitPanel runAction:actionScale1];
            [_suitPanel runAction:actionRotate1];
            [_numberPanel runAction:actionFade2];
            [_numberPanel runAction:actionScale2];
            [_numberPanel runAction:actionRotate2];
            [self runAction:actionFade3];
            [self runAction:actionScale3];
            [self runAction:actionRotate3];
            [self runAction:aciontSequence];
            break;
        case kStateRunningAway:
        case kStateChasing:
            self.characterState = newState;
            [self startRunning];
            break;
        case kStateWalking:
            self.characterState = newState;
            [self startWalking];
            break;
        default:
            self.characterState = newState;
            break;
    }
}

-(id) init
{
    if( (self=[super init]) )
    {
        _number = 1;
        self.characterState = kStateIdle;
        _cardSuit = kCardSuitHeart;
        _facing = kFacingRight;
        
        _suitPanel = [[[GameObject alloc] initWithSpriteFrameName:@"hearts.png"] retain];
        _numberPanel = [[[GameObject alloc] initWithSpriteFrameName:@"1.png"] retain];
                
        _suitPanel.position = ccp(22, 14);
        _numberPanel.position = ccp(11, 24);
        
        _previousDirection = kFacingNone;
        
        [self loadAnimations];
        
        [self addChild:_suitPanel];
        [self addChild:_numberPanel];
        
        _currentDestinationPath = 0;
        
        [self startWalking];
    }
    return self;
}
@end
