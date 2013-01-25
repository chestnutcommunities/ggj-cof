//
//  GameRenderingLayer.m
//  ggj-cof
//
//  Created by Shingo Tamura on 24/01/13.
//
//

#import "ShingoTestLayer.h"
#import "TileMapManager.h"
#import "Human.h"
#import "GamePlayInputLayer.h"
#import "GamePlayStatusLayer.h"

@implementation ShingoTestLayer

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
        
        Human* enemy = [[Human alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ninja-normal.png"]];
        enemy.number = 2;
        
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
                // If card number is lower than or equal to the player's number...
                if (self.player.number >= card.number) {
                    // Kill the card and add the numbers together
                    [card changeState:kStateDead];
                    self.player.number += card.number;
                }
                else {
                    // Kill the player, change game state
                }
            }
        }
    }
}

-(id) init {
    if ((self = [super init])) {
        [self initFriendsAndEnemies];
        
        _player.number = 1;
        
		[self scheduleUpdate];
	}
	return self;
}

@end
