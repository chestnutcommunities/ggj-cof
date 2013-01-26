//
//  GameRenderingLayer.m
//  ggj-cof
//
//  Created by Shingo Tamura on 24/01/13.
//
//

#import "ShingoTestLayer.h"
#import "TileMapManager.h"
#import "Card.h"
#import "GamePlayInputLayer.h"
#import "GamePlayStatusLayer.h"
#import "GameOverLayer.h"
#import "GameCompleteLayer.h"
#import "CardManager.h"

@implementation ShingoTestLayer

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

-(void)update:(ccTime)delta {}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ShingoTestLayer *renderingLayer = [ShingoTestLayer node];
	
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
                        
                        id sequeunce = [CCSequence actions: [CCDelayTime actionWithDuration:1.0f], [CCCallFunc actionWithTarget:self selector:@selector(handleWin:)], nil];
                        [self runAction:sequeunce];

                    }
                    else {
                        // Game goes on, shuffle cards
                        [_cardManager shuffleCards:playerNumber];
                    }
                }
                else {
                    // Kill the player, change game state
                    [_player changeState:kStateDying];
                    
                    // Disable touch
                    [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:NO];
                    
                    id sequeunce = [CCSequence actions: [CCDelayTime actionWithDuration:1.0f], [CCCallFunc actionWithTarget:self selector:@selector(handleLoss:)], nil];
                    [self runAction:sequeunce];
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
        [_cardManager spawnCards:playerNumber spawnPoints:_mapManager.enemySpawnPoints];
        [self addChild:_cardManager.enemyBatchNode];
        
		[self scheduleUpdate];
	}
	return self;
}

@end
