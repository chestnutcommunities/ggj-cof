//
//  GameRenderingLayer.h
//  ggj-cof
//
//  Created by Shingo Tamura on 24/01/13.
//
//

#import "GamePlayRenderingLayer.h"

@interface ShingoTestLayer : GamePlayRenderingLayer

+(CCScene *) scene;
-(void) postMovePlayer:(CGPoint)destination facing:(FacingDirection)direction;

@end
