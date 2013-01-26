//
//  CardManager.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CardManager.h"
#import "Card.h"
#import "Constants.h"
#import "TileMapManager.h"

@implementation CardManager

@synthesize enemyBatchNode = _enemyBatchNode;

- (void) dealloc
{
	self.enemyBatchNode = nil;
    
	[_enemyBatchNode release];
    
    [super dealloc];
}

-(int) getRandomNumberBetweenMin:(int)min andMax:(int)max {
	return ((arc4random() % (max - min + 1)) + min);
}

-(int) generateLowerOrSameNumber:(int)baseNumber {
    return [self getRandomNumberBetweenMin:kCardMinNumber andMax:baseNumber];
}

-(int) generateHigherNumber:(int)baseNumber {
    return [self getRandomNumberBetweenMin:(baseNumber + 1) andMax:kCardMaxNumber];   
}

-(void) shuffleCards:(int)baseNumber {
    int count = 0;
    
    for (Card* card in [_enemyBatchNode children]) {
        if (card.characterState != kStateDying && card.characterState != kStateDead) {
            int cardNumber;
            if (count % 2 == 0) {
                cardNumber = [self generateLowerOrSameNumber:baseNumber];
            }
            else {
                cardNumber = [self generateHigherNumber:baseNumber];
            }
            
            [card setNumber:cardNumber];
            
            int cardSuitNumber = [self getRandomNumberBetweenMin:1 andMax:4];
            CardSuit suit;
            
            switch (cardSuitNumber) {
                case 1:
                    suit = kCardSuitClover;
                    break;
                case 2:
                    suit = kCardSuitDiamond;
                    break;
                case 3:
                    suit = kCardSuitSpades;
                    break;
                default:
                    suit = kCardSuitHeart;
                    break;
            }
            [card setSuit:suit];
        
            count++;
        }

    }
}

-(void) spawnCards:(int)baseNumber spawnPoints:(NSMutableArray*) spawnPoints {
    for (NSValue* val in spawnPoints) {        
        CGPoint spawnPoint = [val CGPointValue];
        Card* card = [[[Card alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"card.png"]] retain];
        
		[card setPosition:spawnPoint];
		[_enemyBatchNode addChild:card z:100];
        [card release];
    }
    [self shuffleCards:baseNumber];
}

-(void) addDestinationPointsToCards:(TileMapManager *)tileMapManager {
    for (Card* card in [_enemyBatchNode children]) {
        int randomIndex;
        NSValue* selectedDestination;
        NSMutableArray *destinationList = [[NSMutableArray alloc] init];
        
        for (int i=0; i< kNumberOfDestinationPointsPerCard; i++) {
            randomIndex = arc4random() % [tileMapManager.enemyDestinationPoints count];
            selectedDestination = [tileMapManager.enemyDestinationPoints objectAtIndex:randomIndex];
            
            [destinationList addObject:(NSValue *)selectedDestination];
        }
        card.destinationPoints = destinationList;
    }
}

-(void) spawnCardsWithTileMap:(int)baseNumber tileMapManager:(TileMapManager *)tileMapManager {
    NSMutableArray *spawnPoints = tileMapManager.enemySpawnPoints;

    for (NSValue* val in spawnPoints) {
        CGPoint spawnPoint = [val CGPointValue];
        
        Card* card = [[[Card alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"card.png"]] retain];
        
		[card setPosition:spawnPoint];
		[_enemyBatchNode addChild:card z:100];
        [card release];
    }
    [self shuffleCards:baseNumber];
    [self addDestinationPointsToCards:tileMapManager];
}

-(id) init {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"card-sprite.plist"];
    _enemyBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"card-sprite.png"] retain];
    
    return self;
}

@end
