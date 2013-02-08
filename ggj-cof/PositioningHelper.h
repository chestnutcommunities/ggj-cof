//
//  PositioningHelper.h
//  ggj-cof
//
//  Created by Shingo Tamura on 25/01/13.
//
//

#import "cocos2d.h"
#import "CommonProtocol.h"

@interface PositioningHelper : CCLayer

+(CGPoint)getViewpointPosition:(CGPoint)position ;
+(CGPoint)convertPixelsToPoints:(CGPoint)pixels retina:(BOOL)retina;
+(CGPoint)convertPointsToPixels:(CGPoint)points retina:(BOOL)retina;
+(CGPoint)tileCoordForPositionInPixels:(CGPoint)positionInPixels tileMap:(CCTMXTiledMap*)tileMap;
+(CGPoint)tileCoordForPositionInPoints:(CGPoint)positionInPoints tileMap:(CCTMXTiledMap*)tileMap tileSizeInPoints:(CGSize)tileSizeInPoints;
+(CGPoint)positionInPixelsForTileCoord:(CGPoint)tileCoord tileMap:(CCTMXTiledMap*)tileMap;
+(CGPoint)positionInPointsForTileCoord:(CGPoint)tileCoord tileMap:(CCTMXTiledMap*)tileMap tileSizeInPoints:(CGSize)tileSizeInPoints;
+(CGPoint) computeTileFittingPositionInPoints:(CGPoint)positionInPoints tileMap:(CCTMXTiledMap*)tileMap tileSizeInPoints:(CGSize)tileSizeInPoints;
+(CGPoint) computeTileFittingPositionInPixels:(CGPoint)positionInPixels tileMap:(CCTMXTiledMap*)tileMap tileSizeInPoints:(CGSize)tileSizeInPoints;
+(CGPoint) getAdjacentTileCoordForCurveMovement:(CGPoint)initialDestination tileMap:(CCTMXTiledMap*)tileMap currentDirection:(FacingDirection)current previous:(FacingDirection)previousDirection;
+(CGPoint) getFinalTileCoordForCurveMovement:(CGPoint)initialDestination tileMap:(CCTMXTiledMap*)tileMap previous:(FacingDirection)previousDirection;
+(FacingDirection)getPreviousDirectionBasedFromCurveMovement:(CGPoint)curveTile finalDest:(CGPoint)finalTile;
@end
