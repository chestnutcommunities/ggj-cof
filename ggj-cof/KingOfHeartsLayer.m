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
#import "SimpleAudioEngine.h"
#import "PositioningHelper.h"

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
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.6f];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"win!.mp3" loop:NO];
    
    GameCompleteScene *scene = [GameCompleteScene node];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void) handleLoss:(id)sender {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.6f];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"lose!.mp3" loop:NO];
    
    GameOverScene *scene = [GameOverScene node];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void) update:(ccTime)delta
{
    CCArray *cards = [_cardManager.enemyBatchNode children];
    int beingChased = 0;
    for (Card *card in cards) {
        if (card.characterState != kStateDying && card.characterState != kStateDead) {
            CGRect heroBoundingBox = [_player adjustedBoundingBox];
            CGRect cardBoundingBox = [card adjustedBoundingBox];
            CGRect cardSightBoundingBox = [card chaseRunBoundingBox];
            
            BOOL isHeroWithinBoundingBox = CGRectIntersectsRect(heroBoundingBox, cardBoundingBox);
            BOOL isHeroWithinChasingRange = CGRectIntersectsRect(heroBoundingBox, cardSightBoundingBox)? YES : NO;
            
            int playerNumber = [self.player getNumber];
            int cardNumber = [(Card *)card getNumber];
            
            if (isHeroWithinBoundingBox) {
                // If card number is lower than or equal to the player's number...
                if (playerNumber >= cardNumber) {
                    // Kill the card and add the numbers together
                    playerNumber += cardNumber;
                    
                    [[SimpleAudioEngine sharedEngine] playEffect:@"draw-card.caf"];
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
                
                BOOL isHeroWithinSight = NO;
                if (card.position.x == _player.position.x || card.position.y == _player.position.y) {
                    isHeroWithinSight = [AIHelper sawPlayer:card tileMapManager:_mapManager player:_player];
                }
				if (isHeroWithinSight == YES ||
                    (isHeroWithinChasingRange && (card.characterState == kStateRunningAway || card.characterState == kStateChasing))) {
					if (playerNumber >= cardNumber) {
                        CCLOG(@"Running Away from Player!");
                        [AIHelper moveAwayFromChaser:card
                                      tileMapManager:_mapManager
                                             tileMap:_mapManager.tileMap];
					}
					else {
                        CCLOG(@"Chasing player!");
						[card changeState:kStateChasing];
						[AIHelper moveToTarget:(Card *)card
								tileMapManager:_mapManager
									   tileMap:_mapManager.tileMap
										target:_player.position];
						beingChased = beingChased + 1;
					}
                    //Set back to walking only when player is out of range so that prey or predator will not give up at once
                    if (!isHeroWithinChasingRange) {
                        card.characterState = kStateWalking;
                    }
                    
				}
				else {
                    CCLOG(@"Walking");
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

