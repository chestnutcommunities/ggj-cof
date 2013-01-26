//
//  KingOfHeartsLayer.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/27/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "KingOfHeartsLayer.h"
#import "TileMapManager.h"
#import "Card.h"
#import "GamePlayInputLayer.h"
#import "GamePlayStatusLayer.h"
#import "GameOverLayer.h"
#import "GameCompleteLayer.h"
#import "CardManager.h"
#import "AIHelper.h"

@implementation KingOfHeartsLayer

@synthesize completeLayer = _completeLayer;
@synthesize gameOverLayer = _gameOverLayer;

- (void) dealloc
{
    self.completeLayer = nil;
    self.gameOverLayer = nil;
    _cardManager = nil;
    
	[_completeLayer release];
    [_gameOverLayer release];
    [_cardManager release];
    
	[super dealloc];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	KingOfHeartsLayer *renderingLayer = [KingOfHeartsLayer node];
	
	// add layer as a child to scene
	[scene addChild: renderingLayer];
	
    GamePlayInputLayer *inputLayer = [GamePlayInputLayer node];
    [scene addChild: inputLayer];
    renderingLayer.inputLayer = inputLayer;
    inputLayer.gameLayer = (GamePlayRenderingLayer*)renderingLayer;
	
    GamePlayStatusLayer *statusDisplayLayer = [GamePlayStatusLayer node];
    [scene addChild: statusDisplayLayer];
    renderingLayer.statusLayer = statusDisplayLayer;
    statusDisplayLayer.gameLayer = (GamePlayRenderingLayer*)renderingLayer;
    
	// return the scene
	return scene;
}

-(void) handleWin:(id)sender {
    [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:YES];
    
    GameCompleteScene *gameOverScene = [GameCompleteScene node];
    [gameOverScene.layer.label setString:@"You Win!"];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}

-(void) handleLoss:(id)sender {
    [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:YES];
    
    GameOverScene *gameOverScene = [GameOverScene node];
    [gameOverScene.layer.label setString:@"You Lose!"];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}

-(void) postMovePlayer:(CGPoint)destination facing:(FacingDirection)direction {
    /*
    CCArray* cards = [_cardManager.enemyBatchNode children];
    for (Card* card in cards) {
        if (card.characterState != kStateDying && card.characterState != kStateDead) {
            CGRect target = CGRectMake(card.position.x - (card.contentSize.width/2), card.position.y - (card.contentSize.height/2), card.contentSize.width, card.contentSize.height);
            
            if (CGRectContainsPoint(target, destination)) {
                int playerNumber = [self.player getNumber];
                int cardNumber = [card getNumber];
                
                // If card number is lower than or equal to the player's number...
                if (playerNumber >= cardNumber) {
                    // Kill the card and add the numbers together
                    playerNumber += cardNumber;
                    
                    [self.player setNumber:playerNumber];
                    [card changeState:kStateDying];
                    
                    if (playerNumber >= 13) {
                        // Disable touch
                        [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:NO];
                        
                        id sequeunce = [CCSequence actions: [CCDelayTime actionWithDuration:0.8f], [CCCallFunc actionWithTarget:self selector:@selector(handleWin:)], nil];
                        [self runAction:sequeunce];
                    }
                    else {
                        // Game goes on, shuffle cards
                        [_cardManager shuffleCards:playerNumber];
                    }
                }
                else {
                    // Disable touch
                    [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:NO];
                    
                    // Kill the player, change game state
                    [_player changeState:kStateDying];
                    
                    id sequeunce = [CCSequence actions: [CCDelayTime actionWithDuration:0.8f], [CCCallFunc actionWithTarget:self selector:@selector(handleLoss:)], nil];
                    [self runAction:sequeunce];
                }
            }
        }
    }
     */
}

-(void) update:(ccTime)delta
{
    CCArray *cards = [_cardManager.enemyBatchNode children];
    
    for (Card *card in cards) {
        if (card.characterState != kStateDying && card.characterState != kStateDead) {
            CGRect heroBoundingBox = [_player adjustedBoundingBox];
            CGRect cardBoundingBox = [card adjustedBoundingBox];
            CGRect cardSightBoundingBox = [card eyesightBoundingBox];
            
            BOOL isHeroWithinBoundingBox = CGRectIntersectsRect(heroBoundingBox, cardBoundingBox);
            BOOL isHeroWithinSight = CGRectIntersectsRect(heroBoundingBox, cardSightBoundingBox)? YES : NO;
            
            int playerNumber = [self.player getNumber];
            int cardNumber = [(Card *)card getNumber];
            
            if (isHeroWithinBoundingBox) {
                // If card number is lower than or equal to the player's number...
                if (playerNumber >= cardNumber) {
                    // Kill the card and add the numbers together
                    playerNumber += cardNumber;
                    
                    [self.player setNumber:playerNumber];
                    [card changeState:kStateDying];
                    
                    if (playerNumber >= 13) {
                        // Disable touch
                        [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:NO];
                        
                        id sequeunce = [CCSequence actions: [CCDelayTime actionWithDuration:0.8f], [CCCallFunc actionWithTarget:self selector:@selector(handleWin:)], nil];
                        [self runAction:sequeunce];
                    }
                    else {
                        // Game goes on, shuffle cards
                        [_cardManager shuffleCards:playerNumber];
                    }
                }
                else {
                    // Disable touch
                    [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:NO];
                    
                    // Kill the player, change game state
                    [_player changeState:kStateDying];
                    
                    id sequeunce = [CCSequence actions: [CCDelayTime actionWithDuration:0.8f], [CCCallFunc actionWithTarget:self selector:@selector(handleLoss:)], nil];
                    [self runAction:sequeunce];
                }
            }
            else {
                if (isHeroWithinSight && (playerNumber < cardNumber)) {
                    [card changeState:kStateChasing];
                    [AIHelper moveToTarget:(Card *)card
                            tileMapManager:_mapManager
                                   tileMap:_mapManager.tileMap
                                    target:_player.position];
                }
                else {
                    [card changeState:kStateWalking];
                    [AIHelper moveToTarget:(Card *)card
                            tileMapManager:_mapManager
                                   tileMap:_mapManager.tileMap
                                    target:[_mapManager getCurrentDestinationOfCard:card]];
                }
            }
        }
    }
}

-(id) init {
    if ((self = [super init])) {
        _cardManager = [[[CardManager alloc] init] retain];
        [_player setNumber:1];
        int playerNumber = [_player getNumber];
        [_cardManager spawnCardsWithTileMap:playerNumber tileMapManager:_mapManager];
        [self addChild:_cardManager.enemyBatchNode];
		[self scheduleUpdate];
	}
	return self;
}

@end

