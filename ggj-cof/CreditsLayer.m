//
//  CreditsLayer.m
//  ggj-cof
//
//  Created by Shingo Tamura on 30/07/13.
//
//

#import "CreditsLayer.h"
#import "TitleScreenScene.h"
#import "SimpleAudioEngine.h"

@implementation CreditsScene
@synthesize layer = _layer;

- (id)init {
    if ((self = [super init])) {
        self.layer = [CreditsLayer node];
        [self addChild:_layer];
    }
    return self;
}

- (void)dealloc {
    [_layer release];
    
    [super dealloc];
}
@end

@implementation CreditsLayer

-(void) backButtonTapped:(id)sender {
    [[SimpleAudioEngine sharedEngine] playEffect:@"3-key-strum.caf"];
    
    TitleScreenScene *titleScene = [TitleScreenScene node];
    [[CCDirector sharedDirector] replaceScene:titleScene];
}

-(id)init {
    if ((self=[super initWithColor:ccc4(255, 255, 255, 255)])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGSize pixelSize = [[CCDirector sharedDirector] winSizeInPixels];
        CGSize buttonSize = CGSizeMake(40, 40);
        CGSize gapSize = CGSizeMake(12, 12);
        
        // Add background image
        CCSprite* bg;
        if (pixelSize.width == 1136) {
            // iPhone 5
            bg = [CCSprite spriteWithFile:@"bg-nologo-1136x640.png"];
        }
        else {
            // iPhone 4
            bg = [CCSprite spriteWithFile:@"bg-nologo-960x640.png"];
        }
        
        bg.tag = 1;
        bg.anchorPoint = CGPointMake(0, 0);
        [self addChild:bg z:0];
        
        CCSprite* credits = [CCSprite spriteWithFile:@"credits.png"];
        credits.position = ccp(winSize.width * 0.5f, winSize.height * 0.5f);
        [self addChild:credits z:1];
        
        // Set up spritesheet
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button-sprite.plist"];
        CCSpriteBatchNode *sheet = [CCSpriteBatchNode batchNodeWithFile:@"button-sprite.png"];
        [self addChild:sheet];
    
        // Set up pause button
        CCMenuItemSprite *backButton = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-back-normal.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"button-back-pressed.png"] target:self selector:@selector(backButtonTapped:)] retain];
    
        backButton.position = ccp((buttonSize.width * 0.5f) + (gapSize.width * 0.5f), (buttonSize.height * 0.5f) + (gapSize.width * 0.5f));
        
        CCMenu *menu = [[CCMenu menuWithItems:backButton, nil] retain];
        menu.position = CGPointZero;
        [self addChild:menu];
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
}

@end
