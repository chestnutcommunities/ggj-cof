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
    _walkingAnim = nil;
    _destinationPoints = nil;
    
    [_walkingAnim release];
    [_destinationPoints release];
    
    [super dealloc];
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

-(void) loadAnimations {
    NSMutableArray *animFrames = [NSMutableArray array];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"card-1.png"]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"card-2.png"]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"card-3.png"]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"card-4.png"]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"card-5.png"]];
    [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"card-6.png"]];
    
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
    
        //go to regular routine
        [AIHelper moveToTarget:self
                tileMapManager:tileMapManager
                       tileMap:tileMapManager.tileMap
                        target:[tileMapManager getCurrentDestinationOfCard:self]];
    */

}

-(void) startWalking {
    [self stopAllActions];
    
    id action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_walkingAnim restoreOriginalFrame:YES]] retain];
    
    [self runAction:action];
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
        
        [self startWalking];
    }
    return self;
}
@end
