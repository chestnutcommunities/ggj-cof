//
//  GameCharacter.h
//  TileGame
//
//  Created by Sam Christian Lee on 9/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface GameCharacter : GameObject {
	int characterHealth;
	CharacterStates characterState;
    CGFloat _speed;
}

@property (readwrite) int characterHealth;
@property (readwrite) CharacterStates characterState;
@property (nonatomic, assign) CGFloat speed;

@end
