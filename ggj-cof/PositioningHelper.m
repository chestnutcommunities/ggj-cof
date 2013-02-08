//
//  PositioningHelper.m
//  ggj-cof
//
//  Created by Shingo Tamura on 25/01/13.
//
//

#import "PositioningHelper.h"

@implementation PositioningHelper

+(CGPoint)getViewpointPosition:(CGPoint)position {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // We want the player to be always at the centre of the screen so
    // just use the position that's been passed here
    int x = position.x;
    int y = position.y;
    
    CGPoint actualPosition = ccp(x, y);
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    
    return ccpSub(centerOfView, actualPosition);
}

+(CGPoint)convertPixelsToPoints:(CGPoint)pixels retina:(BOOL)retina {
    if (retina) {
        return ccp(pixels.x / 2.0f, pixels.y / 2.0f);
    }
    else {
        return ccp(pixels.x, pixels.y);
    }
}

+(CGPoint)convertPointsToPixels:(CGPoint)points retina:(BOOL)retina {
    if (retina) {
        return ccp(points.x * 2.0f, points.y * 2.0f);
    }
    else {
        return ccp(points.x, points.y);
    }
}

// Gets tile coordinates for the given position in pixels. Use actual tile size
+(CGPoint)tileCoordForPositionInPixels:(CGPoint)positionInPixels tileMap:(CCTMXTiledMap*)tileMap {
    // Tile coordinates in int
    int x = positionInPixels.x / tileMap.tileSize.width;
    int y = ((tileMap.mapSize.height * tileMap.tileSize.height) - positionInPixels.y) / tileMap.tileSize.height;
    
    return ccp(x, y);
}

// Gets tile coordinates for the given position in points. The position must be
// in points.
+(CGPoint)tileCoordForPositionInPoints:(CGPoint)positionInPoints tileMap:(CCTMXTiledMap*)tileMap tileSizeInPoints:(CGSize)tileSizeInPoints {
    // Tile coordinates in int
    int x = positionInPoints.x / tileSizeInPoints.width;
    int y = ((tileMap.mapSize.height * tileSizeInPoints.height) - positionInPoints.y) / tileSizeInPoints.height;
    
    return ccp(x, y);
}

+(CGPoint)positionInPixelsForTileCoord:(CGPoint)tileCoord tileMap:(CCTMXTiledMap*)tileMap {
    CGFloat x = (tileCoord.x * tileMap.tileSize.width) + tileMap.tileSize.width / 2.0f;
    CGFloat y = (tileMap.mapSize.height * tileMap.tileSize.height) - (tileCoord.y * tileMap.tileSize.height) - tileMap.tileSize.height / 2.0f;
    
    return ccp(x, y);
}

+(CGPoint)positionInPointsForTileCoord:(CGPoint)tileCoord tileMap:(CCTMXTiledMap*)tileMap tileSizeInPoints:(CGSize)tileSizeInPoints {
    CGFloat x = (tileCoord.x * tileSizeInPoints.width) + tileSizeInPoints.width / 2.0f;
    CGFloat y = (tileMap.mapSize.height * tileSizeInPoints.height) - (tileCoord.y * tileSizeInPoints.height) - tileSizeInPoints.height / 2.0f;
    
    return ccp(x, y);
}

// Compute a position (in points) that fits to the corresponding tile
+(CGPoint) computeTileFittingPositionInPoints:(CGPoint)positionInPoints tileMap:(CCTMXTiledMap*)tileMap tileSizeInPoints:(CGSize)tileSizeInPoints {
    CGPoint tilePos = [self tileCoordForPositionInPoints:positionInPoints tileMap:tileMap tileSizeInPoints:tileSizeInPoints];
    
    CGFloat x = (tilePos.x * tileSizeInPoints.width) + (tileSizeInPoints.width / 2.0f);
    CGFloat y = (tileMap.mapSize.height * tileSizeInPoints.height) - (tilePos.y * tileSizeInPoints.height) - (tileSizeInPoints.height / 2.0f);
    
    return ccp(x, y);
}

// Compute a position (in pixels) that fits to the corresponding tile
+(CGPoint) computeTileFittingPositionInPixels:(CGPoint)positionInPixels tileMap:(CCTMXTiledMap*)tileMap tileSizeInPoints:(CGSize)tileSizeInPoints {
    CGPoint tilePos = [self tileCoordForPositionInPixels:positionInPixels tileMap:tileMap];
    
    CGFloat x = (tilePos.x * tileMap.tileSize.width) + (tileMap.tileSize.width / 2.0f);
    CGFloat y = (tileMap.mapSize.height * tileMap.tileSize.height) - (tilePos.y * tileMap.tileSize.height) - (tileMap.tileSize.height / 2.0f);
    
    return ccp(x, y);
}

+(FacingDirection)getPreviousDirectionBasedFromCurveMovement:(CGPoint)curvePosition finalDest:(CGPoint)finalPosition {
    if (curvePosition.x < finalPosition.x) {
        return kFacingRight;
    }
    if (curvePosition.x > finalPosition.x) {
        return kFacingLeft;
    }
    if (curvePosition.y > finalPosition.y) {
        return kFacingDown;
    }
    if (curvePosition.y < finalPosition.y) {
        return kFacingUp;
    }
    return kFacingNone;
}

+(CGPoint) getFinalTileCoordForCurveMovement:(CGPoint)initialDestination tileMap:(CCTMXTiledMap*)tileMap previous:(FacingDirection)previousDirection
{
    CGFloat x = initialDestination.x;
    CGFloat y = initialDestination.y;
    switch (previousDirection) {
        case kFacingDown:
            x = x;
            y = y + 1.0f;
            break;
        case kFacingRight:
            x = x + 1.0f;
            y = y;
            break;
        case kFacingLeft:
            x = x - 1.0f;
            y = y;
            break;
        case kFacingUp:
            x = x;
            y = y - 1.0f;
            break;
        default:
            break;
    }
    
    return ccp(x, y);

}

//Get adject tile coordinate for curve movement on collidable corners
+(CGPoint) getAdjacentTileCoordForCurveMovement:(CGPoint)initialDestination tileMap:(CCTMXTiledMap*)tileMap currentDirection:(FacingDirection)current previous:(FacingDirection)previousDirection
{    
    CGFloat x = initialDestination.x;
    CGFloat y = initialDestination.y;
    switch (current) {
        case kFacingUp:
            y = y + 1.0f;
            break;
        case kFacingDown:
            y = y - 1.0f;
            break;
        case kFacingRight:
            x = x - 1.0f;
            break;
        case kFacingLeft:
            x = x + 1.0f;
            break;
        default:
            break;
    }
    
    switch (previousDirection) {
        case kFacingDown:
            y = y + 1.0f;
            break;
        case kFacingRight:
            x = x + 1.0f;
            break;
        case kFacingLeft:
            x = x - 1.0f;
            break;
        case kFacingUp:
            y = y - 1.0f;
            break;
        default:
            break;
    }
    
    return ccp(x, y);
}

@end
