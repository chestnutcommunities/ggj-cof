//
//  PopStepAndAnimate.m
//  ggj-cof
//
//  Created by Shingo Tamura on 20/07/13.
//
//

#import "PopStepAnimateData.h"

@implementation PopStepAnimateData

@synthesize card = _card;
@synthesize tileMapManager = _tileMapManager;

- (void) dealloc
{    
	self.tileMapManager = nil;
    self.card = nil;
    
	[_tileMapManager release];
	[_card release];

    [super dealloc];
}

@end
