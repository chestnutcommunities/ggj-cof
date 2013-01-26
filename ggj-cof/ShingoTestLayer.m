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

@implementation ShingoTestLayer

@synthesize completeLayer = _completeLayer;
@synthesize gameOverLayer = _gameOverLayer;

- (void) dealloc
{
    self.completeLayer = nil;
    self.gameOverLayer = nil;
    
	[_completeLayer release];
    [_gameOverLayer release];
    
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

-(void) initFriendsAndEnemies {
    for (NSValue* val in _mapManager.enemySpawnPoints) {
        CGPoint spawnPoint = [val CGPointValue];
        
        Card* enemy = [[Card alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"card.png"]];
        [enemy setNumber:1];
        
		[enemy setPosition:spawnPoint];
		[self.sceneBatchNode addChild:enemy z:100];
        [enemy release];
    }
}

-(void) postMovePlayer:(CGPoint)destination facing:(FacingDirection)direction {
    CCArray* cards = [self.sceneBatchNode children];
    for (Card* card in cards) {
        if (self.player != card && card.characterState != kStateDead) {
            CGRect target = CGRectMake(card.position.x - (card.contentSize.width/2), card.position.y - (card.contentSize.height/2), card.contentSize.width, card.contentSize.height);
            
            if (CGRectContainsPoint(target, destination)) {
                int playerNumber = [self.player getNumber];
                int cardNumber = [card getNumber];
                
                // If card number is lower than or equal to the player's number...
                if (playerNumber >= cardNumber) {
                    // Kill the card and add the numbers together
                    [card changeState:kStateDead];
                    playerNumber++;
                    [self.player setNumber:playerNumber];
                    
                    if (playerNumber >= 13) {
                        GameCompleteScene *gameOverScene = [GameCompleteScene node];
                        [gameOverScene.layer.label setString:@"You Win!"];
                        [[CCDirector sharedDirector] replaceScene:gameOverScene];
                    }
                }
                else {
                    // Kill the player, change game state
                    GameOverScene *gameOverScene = [GameOverScene node];
                    [gameOverScene.layer.label setString:@"You Lose!"];
                    [[CCDirector sharedDirector] replaceScene:gameOverScene];
                }
            }
        }
    }
}

-(id) init {
    if ((self = [super init])) {
        [self initFriendsAndEnemies];
        
        [_player setNumber:1];
        
		[self scheduleUpdate];
	}
	return self;
}

@end
