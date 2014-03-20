//
//  Player.h
//  ggj-cof
//
//  Created by Shingo Tamura on 29/06/13.
//
//

#import "Card.h"

@interface Player : Card {
    int _score; // crown counter
}

-(void)setScore:(int)scorePoint;
-(int)getScore;

@end
