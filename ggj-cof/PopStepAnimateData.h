//
//  PopStepAnimateData
//  ggj-cof
//
//  Created by Shingo Tamura on 20/07/13.
//
//

#import "cocos2d.h"
#import "Card.h"
#import "TileMapManager.h"

@interface PopStepAnimateData : NSObject
{
    Card *_card;
    TileMapManager *_tileMapManager;
}

@property (nonatomic, retain) Card *card;
@property (nonatomic, retain) TileMapManager *tileMapManager;

@end