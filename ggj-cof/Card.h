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

@interface Card : AICharacter {
    int _number;
	CardSuit _cardSuit;
}

@property (readwrite) int number;
@property (readwrite) CardSuit cardSuit;

@end
