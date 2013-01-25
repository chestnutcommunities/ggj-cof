//
//  Card.m
//  ggj-cof
//
//  Created by Sam Christian Lee on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize number = _number;
@synthesize cardSuit = _cardSuit;

-(void) dealloc {
    [super dealloc];
}

-(id) init {
	if ((self = [super init])) {
        self.number = 1;
        self.cardSuit = kCardSuitHeart;
    }
    return self;
}

@end
