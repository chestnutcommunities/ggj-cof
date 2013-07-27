//
//  Card.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/26/13.
//  Copyright 2013 Chopsticks On Fire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AICharacter.h"
#import "CommonProtocol.h"

@class TileMapManager;

@interface Card : AICharacter {
    int _number;
	CardSuit _cardSuit;
    
    CCAnimation *_walkingAnim;
    CCAnimate *_animationHandle;
    
    GameObject* _suitPanel;
    GameObject* _numberPanel;
    
    FacingDirection _facing;
    
    CardAnimationType _requestedAnimation;
    
    BOOL _delayFlipX;
    
    CGFloat _factor;
    CGFloat _limit;
    CGFloat _momentum;
    CGFloat _tilePerSecond;
    
    //spawning & AI
    CGPoint _originPoint;
    int _currentDestinationPath;
    NSMutableArray *_destinationPoints;
    FacingDirection _previousDirection;
    int _frontOrder;
    
    CGPoint _realPosition;
}

@property (nonatomic, assign) CGPoint originPoint;
@property (nonatomic, assign) int currentDestinationPath;
@property (nonatomic, retain) NSMutableArray *destinationPoints;
@property (nonatomic, assign) FacingDirection previousDirection;
@property (nonatomic, assign) int frontOrder;
@property (nonatomic, assign) CGPoint realPosition;
@property (nonatomic, assign) CGFloat tilePerSecond;
@property (readonly, nonatomic) FacingDirection facing;
@property (readonly, nonatomic) CardAnimationType requestedAnimation;

-(void)setNumber:(int)number;
-(void)setSuit:(CardSuit)suit;
-(void)setRealPosition:(CGPoint)mapPosition;
-(int)getNumber;
-(CardSuit)getSuit;
-(CGPoint)getCardDisplayPosition;
-(void)face:(FacingDirection)direction;
-(CGRect)chaseRunBoundingBox;
-(void)updateHorizontalFacingDirection;
-(void)requestAnimation:(CardAnimationType)animation;
-(void)updateAnimation;
@end