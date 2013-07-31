//
//  CreditsLayer.h
//  ggj-cof
//
//  Created by Shingo Tamura on 30/07/13.
//
//

#import "cocos2d.h"

@interface CreditsLayer : CCLayerColor
@end

@interface CreditsScene : CCScene {
    CreditsLayer* _layer;
}
@property (nonatomic, retain) CreditsLayer* layer;
@end