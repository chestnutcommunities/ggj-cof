//
//  GameRenderingLayer.m
//  ggj-cof
//
//  Created by Shingo Tamura on 24/01/13.
//
//

#import "ShingoTestLayer.h"

@implementation ShingoTestLayer

-(void)update:(ccTime)delta {}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
    if ((self=[super init])) {
		[self scheduleUpdate];
	}
	return self;
}

@end
