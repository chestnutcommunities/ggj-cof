//
//  Card.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/26/13.
//  Copyright 2013 Groovy Vision. All rights reserved.
//

#import "Card.h"
#import "AIHelper.h"
#import "TileMapManager.h"
#import "GameSetting.h"
#import "Constants.h"

@implementation Card

@synthesize originPoint = _originPoint;
@synthesize destinationPoints = _destinationPoints;
@synthesize currentDestinationPath = _currentDestinationPath;
@synthesize previousDirection = _previousDirection;
@synthesize frontOrder = _frontOrder;
@synthesize realPosition = _realPosition;
@synthesize tilePerSecond = _tilePerSecond;
@synthesize facing = _facing;
@synthesize requestedAnimation = _requestedAnimation;

-(void) dealloc {
    [_upAnim release];
    [_downAnim release];
    [_leftAnim release];
    [_rightAnim release];
    [_destinationPoints release];
    
    [super dealloc];
}

// Gets the opposite facing direction
-(FacingDirection)facingOppositeTo {
    FacingDirection opposite;
    
    switch (_facing) {
        case kFacingUp:
            opposite = kFacingDown;
            break;
        case kFacingDown:
            opposite = kFacingUp;
            break;
        case kFacingLeft:
            opposite = kFacingRight;
            break;
        case kFacingRight:
            opposite = kFacingLeft;
            break;
        default:
            opposite = kFacingNone;
            break;
    }
    
    return opposite;
}

-(void)face:(FacingDirection)direction {
    switch (direction) {
        case kFacingUp:
            if (_facing != kFacingUp) {
                _facing = kFacingUp;
                if (!_delayFlip) {
                    [self syncAnimationAndDirection];
                }
            }
            break;
        case kFacingDown:
            if (_facing != kFacingDown) {
                _facing = kFacingDown;
                if (!_delayFlip) {
                    [self syncAnimationAndDirection];
                }
            }
            break;
        case kFacingRight:
            if (_facing != kFacingRight) {
                _facing = kFacingRight;
                if (!_delayFlip) {
                    [self syncAnimationAndDirection];
                }
            }
            break;
        case kFacingLeft:
            if (_facing != kFacingLeft) {
                _facing = kFacingLeft;
                if (!_delayFlip) {
                    [self syncAnimationAndDirection];
                }
            }
            break;
        default:
            _facing = direction;
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
    numberString = [NSString stringWithFormat:@"enemy-number-%d.png", _number];
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:numberString];
    [_numberPanel setDisplayFrame:frame];
}

-(void)setRealPosition:(CGPoint)mapPosition {
    _realPosition = mapPosition;
}

-(void) loadAnimations {
    NSMutableArray *afUp = [NSMutableArray array];
    
    [afUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-back-1.png"]];
    [afUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-back-2.png"]];
    [afUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-back-3.png"]];
    [afUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-back-4.png"]];
    [afUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-back-5.png"]];
    [afUp addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-back-6.png"]];
    
    _upAnim = [[CCAnimation animationWithFrames:afUp delay:0.1f] retain];
    
    NSMutableArray *afDown = [NSMutableArray array];
    
    [afDown addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-front-1.png"]];
    [afDown addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-front-2.png"]];
    [afDown addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-front-3.png"]];
    [afDown addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-front-4.png"]];
    [afDown addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-front-5.png"]];
    [afDown addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-front-6.png"]];
    
    _downAnim = [[CCAnimation animationWithFrames:afDown delay:0.1f] retain];
    
    NSMutableArray *afLeft = [NSMutableArray array];
    
    [afLeft addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-left-1.png"]];
    [afLeft addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-left-2.png"]];
    [afLeft addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-left-3.png"]];
    [afLeft addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-left-4.png"]];
    [afLeft addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-left-5.png"]];
    [afLeft addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-left-6.png"]];
    
    _leftAnim = [[CCAnimation animationWithFrames:afLeft delay:0.1f] retain];
    
    NSMutableArray *afRight = [NSMutableArray array];
    
    [afRight addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-right-1.png"]];
    [afRight addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-right-2.png"]];
    [afRight addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-right-3.png"]];
    [afRight addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-right-4.png"]];
    [afRight addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-right-5.png"]];
    [afRight addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy-right-6.png"]];
    
    _rightAnim = [[CCAnimation animationWithFrames:afRight delay:0.1f] retain];
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
    int cardRange = [[GameSetting instance] cardRange];
    int cardRangeSize = cardRange * 2;
    
	cardSightBoundingBox = CGRectMake(cardBoundingBox.origin.x - cardBoundingBox.size.width * cardRange, cardBoundingBox.origin.y - cardBoundingBox.size.height * cardRange, cardBoundingBox.size.width * cardRangeSize, cardBoundingBox.size.height * cardRangeSize);
    
	return cardSightBoundingBox;
}

-(void) startWalking {
    CCAnimation* animation;
    
    switch (_facing) {
        case kFacingUp:
            animation = _upAnim;
            break;
        case kFacingDown:
            animation = _downAnim;
            break;
        case kFacingRight:
            animation = _rightAnim;
            break;
        case kFacingLeft:
            animation = _leftAnim;
            break;
        default:
            break;
    }

    [animation setDelay:0.1f];
    id action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES]] retain];
    [self runAction:action];
    [self face:_facing];
}

-(void) startRunning {
    CCAnimation* animation;
    
    switch (_facing) {
        case kFacingUp:
            animation = _upAnim;
            break;
        case kFacingDown:
            animation = _downAnim;
            break;
        case kFacingRight:
            animation = _rightAnim;
            break;
        case kFacingLeft:
            animation = _leftAnim;
            break;
        default:
            break;
    }

    [animation setDelay:0.05f];
    id action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES]] retain];
    [self runAction:action];
    [self face:_facing];
}

-(void) stopWalkingOrRunning {
    [self stopAllActions];
}

-(void) handleDead:(id)sender {
    self.characterState = kStateDead;
    self.visible = NO;
}

-(void)requestAnimation:(CardAnimationType)animation {
    _requestedAnimation = animation;
}

-(void) syncAnimationAndDirection {
    CCAnimation* animation;
    
    switch (_facing) {
        case kFacingUp:
            animation = _upAnim;
            _suitPanel.position = _suitPosUp;
            _numberPanel.position = _numberPosUp;
            break;
        case kFacingDown:
            animation = _downAnim;
            _suitPanel.position = _suitPosDown;
            _numberPanel.position = _numberPosDown;
            break;
        case kFacingRight:
            animation = _rightAnim;
            _suitPanel.position =  _suitPosRight;
            _numberPanel.position = _numberPosRight;
            break;
        case kFacingLeft:
            animation = _leftAnim;
            _suitPanel.position = _suitPosLeft;
            _numberPanel.position = _numberPosLeft;
            break;
        default:
            break;
    }

    id action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES]] retain];
    [self runAction:action];
}

-(void)updateAnimation {
    if (_requestedAnimation == CardAnimationNone) { return; }
    
    if (_requestedAnimation == CardAnimationWalking) {
        [self startWalking];
    }
    else if (_requestedAnimation == CardAnimationRunning) {
        [self startRunning];
    }
    
    // Reset animation
    _requestedAnimation = CardAnimationNone;
}

-(void)updateFacingDirection {
    if (_delayFlip) {
        if (_facing == kFacingRight) {
            [self syncAnimationAndDirection];
        }
        else if (_facing == kFacingLeft) {
            [self syncAnimationAndDirection];
        }
        else if (_facing == kFacingUp) {
            [self syncAnimationAndDirection];
        }
        else if (_facing == kFacingDown) {
            [self syncAnimationAndDirection];
        }
    }
}

-(void)changeState:(CharacterStates)newState {
    if (self.characterState == newState) {
        return;
    }
    
    switch (newState) {
        case kStateDying:
            [self stopWalkingOrRunning];
            
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
            // Increase speed tile/second
            _tilePerSecond = ENEMY_FAST_SPEED;
            [self requestAnimation:CardAnimationRunning];
            break;
        case kStateWalking:
            self.characterState = newState;
            // Reset speed tile/second
            _tilePerSecond = ENEMY_NORMAL_SPEED;
            [self requestAnimation:CardAnimationWalking];
            break;
        default:
            self.characterState = newState;
            break;
    }
}

-(void) initSuitAndNumberPositions
{
    _suitPosUp = ccp(16, 15);
    _suitPosDown = ccp(25, 15);
    _suitPosLeft = ccp(25, 15);
    _suitPosRight = ccp(21, 15);
    
    _numberPosUp = ccp(25, 24);
    _numberPosDown = ccp(25, 24);
    _numberPosLeft = ccp(25, 24);
    _numberPosRight = ccp(22, 24);
}

-(id) init
{
    if ((self = [super init])) {
        _number = 1;
        self.characterState = kStateIdle;
        _cardSuit = kCardSuitHeart;
        _facing = kFacingRight;
        
        _suitPanel = [[[GameObject alloc] initWithSpriteFrameName:@"hearts.png"] retain];
        _numberPanel = [[[GameObject alloc] initWithSpriteFrameName:@"enemy-number-1.png"] retain];
                
        _suitPanel.position = ccp(25, 16);
        _numberPanel.position = ccp(25, 23);
        
        _tilePerSecond = ENEMY_NORMAL_SPEED;
        _previousDirection = kFacingNone;
        
        [self initSuitAndNumberPositions];
        [self loadAnimations];
        
        [self addChild:_suitPanel];
        [self addChild:_numberPanel];
        
        _currentDestinationPath = 0;
        
        _requestedAnimation = CardAnimationNone;
        
        _delayFlip = YES;
        
        [self startWalking];
    }
    return self;
}
@end
