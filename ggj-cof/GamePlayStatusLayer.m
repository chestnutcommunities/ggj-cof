//
//  GamePlayGoldLayer.m
//  TileGame
//
//  Created by Shingo Tamura on 11/10/12.
//
//

#import "GamePlayStatusLayer.h"

@implementation GamePlayStatusLayer

@synthesize gameLayer = _gameLayer;

- (void) dealloc
{
	[super dealloc];
}

-(void) onEnter
{
    [super onEnter];
}

-(id) init
{
    if ((self = [super init])) { }
    return self;
}

@end
