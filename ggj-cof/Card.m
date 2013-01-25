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
@synthesize cardSuite = _cardSuite;

-(void) dealloc {
    [super dealloc];
}

-(id) init {
	if ((self = [super init])) {
        self.number = 1;
        self.cardSuite = kCardSuitHeart;
    }
    return self;
}

@end
