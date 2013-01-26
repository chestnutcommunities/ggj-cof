//
//  Card.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Card.h"
#import "AIHelper.h"
#import "TileMapManager.h"

@implementation Card

@synthesize originPoint = _originPoint;
@synthesize destinationPoints = _destinationPoints;
@synthesize currentDestinationPath = _currentDestinationPath;

-(void) dealloc {
    _crouchAnim = nil;
    _jumpAnim = nil;
    _landAnim = nil;
    _destinationPoints = nil;
    
    [_crouchAnim release];
    [_jumpAnim release];
    [_landAnim release];
    
    [super dealloc];
}

-(void)setNumber:(int)number {
    if (number <= 0) {
        return;
    }
    
    _number = number;
    
    if (_number >= 13) {
        _number = 13;
    }
    
    NSString *numberString;
    numberString = [NSString stringWithFormat:@"%d.png", _number];
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:numberString];
    [_numberPanel setDisplayFrame:frame];
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

-(void) loadAnimations {}

-(CGRect)eyesightBoundingBox {
    CGRect cardSightBoundingBox;
    CGRect cardBoundingBox = [self adjustedBoundingBox];
	cardSightBoundingBox = CGRectMake(cardBoundingBox.origin.x - cardBoundingBox.size.width*5.0f,
										cardBoundingBox.origin.y - cardBoundingBox.size.height*5.0f,
										cardBoundingBox.size.width*10.0f,
										cardBoundingBox.size.height*10.0f);
	return cardSightBoundingBox;
}

-(void) updateStateWithTileMapManager:(ccTime)deltaTime andGameObject:(GameObject *)gameObject tileMapManager:(TileMapManager *)tileMapManager {
    CGPoint test = [tileMapManager getPlayerSpawnPoint];
    
    CGRect heroBoundingBox = [gameObject adjustedBoundingBox];
	CGRect cardBoundingBox = [self adjustedBoundingBox];
	CGRect cardSightBoundingBox = [self eyesightBoundingBox];
    
    BOOL isHeroWithinSight = CGRectIntersectsRect(heroBoundingBox, cardSightBoundingBox)? YES : NO;
    
    if (isHeroWithinSight) {
        [self changeState:kStateChasing];
    }
    else {
        [self changeState:kStateWalking];
    }
    /*
    //if ([AIHelper checkIfPointIsInSight:test card:self tileMapManager:tileMapManager]) {
        //chase player if in sight
        [AIHelper moveToTarget:self
                tileMapManager:tileMapManager
                       tileMap:tileMapManager.tileMap
                        target:gameObject.position];
    //}
    
    else {
    */
        //go to regular routine
        [AIHelper moveToTarget:self
                tileMapManager:tileMapManager
                       tileMap:tileMapManager.tileMap
                        target:[tileMapManager getCurrentDestinationOfCard:self]];
    

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
            
            id actionFade1 = [CCFadeOut actionWithDuration:0.5f];
            id actionScale1 = [CCScaleTo actionWithDuration:0.5f scale:0.0f];
            
            id actionFade2 = [CCFadeOut actionWithDuration:0.5f];
            id actionScale2 = [CCScaleTo actionWithDuration:0.5f scale:0.0f];
            
            id actionFade3 = [CCFadeOut actionWithDuration:0.5f];
            id actionScale3 = [CCScaleTo actionWithDuration:0.5f scale:0.0f];
            
            id aciontSequence = [CCSequence actions: [CCDelayTime actionWithDuration:0.5f], [CCCallFunc actionWithTarget:self selector:@selector(handleDead:)], nil];
            
            self.characterState = newState;
            
            [_suitPanel runAction:actionFade1];
            [_suitPanel runAction:actionScale1];
            [_numberPanel runAction:actionFade2];
            [_numberPanel runAction:actionScale2];
            [self runAction:actionFade3];
            [self runAction:actionScale3];
            
            [self runAction:aciontSequence];
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
        
        _suitPanel = [[[GameObject alloc] initWithSpriteFrameName:@"hearts.png"] retain];
        _numberPanel = [[[GameObject alloc] initWithSpriteFrameName:@"1.png"] retain];
                
        _suitPanel.position = ccp(22, 14);
        _numberPanel.position = ccp(11, 24);
        
        [self loadAnimations];
        
        [self addChild:_suitPanel];
        [self addChild:_numberPanel];
        
        _currentDestinationPath = 0;
    }
    return self;
}
@end
