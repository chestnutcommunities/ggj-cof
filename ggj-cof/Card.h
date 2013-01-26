//
//  Card.h
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AICharacter.h"

@class TileMapManager;

@interface Card : AICharacter {
    int _number;
	CardSuit _cardSuit;
    
    CCAnimation *_crouchAnim;
    CCAnimation *_jumpAnim;
    CCAnimation *_landAnim;
    CCAnimate *_animationHandle;
    
    GameObject* _suitPanel;
    GameObject* _numberPanel;
    
    CGFloat _factor;
    CGFloat _limit;
    CGFloat _momentum;
    
    //spawning & AI
    CGPoint _originPoint;
    int _currentDestinationPath;
    NSMutableArray *_destinationPoints;
}

@property (nonatomic, assign) CGPoint originPoint;
@property (nonatomic, assign) int currentDestinationPath;
@property (nonatomic, retain) NSMutableArray *destinationPoints;

-(void)setNumber:(int)number;
-(void)setSuit:(CardSuit)suit;
-(int)getNumber;
-(CardSuit)getSuit;

-(void) initiateJump;
-(void) initiateCrouch;
-(void) initiateLanding;

-(void) updateStateWithTileMapManager:(ccTime)deltaTime andGameObject:(GameObject *)gameObject tileMapManager:(TileMapManager *)tileMapManager;
-(CGRect)eyesightBoundingBox;
@end