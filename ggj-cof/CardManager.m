//
//  CardManager.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CardManager.h"
#import "Card.h"

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
        if (card.characterState != kStateDead) {
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

-(id) init {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"card-sprite.plist"];
    _enemyBatchNode = [[CCSpriteBatchNode batchNodeWithFile:@"card-sprite.png"] retain];
    
    return self;
}

@end
