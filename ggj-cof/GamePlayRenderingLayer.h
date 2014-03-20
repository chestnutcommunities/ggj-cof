//
//  GameRenderingLayer.h
//  ggj-cof
//
//  Created by Shingo Tamura on 24/01/13.
//
//

#import "cocos2d.h"
#import "CommonProtocol.h"

@class GamePlayInputLayer;
@class GamePlayStatusLayer;
@class Player;
@class TileMapManager;
@class CountdownLayer;
@class ScoreLayer;

@interface GamePlayRenderingLayer: CCLayerColor
{
    CCSpriteBatchNode *_sceneBatchNode;
    Player *_player;
    TileMapManager* _mapManager;
    
    GamePlayInputLayer *_inputLayer;
    GamePlayStatusLayer *_statusLayer;
    CountdownLayer *_countdownLayer;
    ScoreLayer *_scoreLayer;
}

@property (nonatomic, retain) GamePlayInputLayer *inputLayer;
@property (nonatomic, retain) GamePlayStatusLayer *statusLayer;
@property (nonatomic, retain) CountdownLayer *countdownLayer;
@property (nonatomic, retain) ScoreLayer *scoreLayer;

@property (nonatomic, retain) TileMapManager *mapManager;
@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) CCSpriteBatchNode *sceneBatchNode;

-(void) postMovePlayer:(CGPoint)destination facing:(FacingDirection)direction;
-(void) movePlayer:(CGPoint)destination facing:(FacingDirection)direction;

@end
