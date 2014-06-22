//
//  IntroScene.m
//  NACarouselScrollNode
//
//  Created by Navarjun on 20/06/14.
//  Copyright Navarjun 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------
#pragma mark -- NACrouselScrollNodeDelegate --
// -----------------------------------------------------------------------

-(void) tappedButtonAtIndex:(int)index {
    NSLog(@"tappedButtonAtIndex: %d", index);
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    screenSize = [[CCDirector sharedDirector] viewSize];
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // Creating CCButtons to add into crousel node
    CCSpriteFrame *button1SpriteFrame = [CCSpriteFrame frameWithImageNamed:@"Icon-72@2x.png"];
    CCSpriteFrame *button2SpriteFrame = [CCSpriteFrame frameWithImageNamed:@"Icon-72@2x.png"];
    CCSpriteFrame *button3SpriteFrame = [CCSpriteFrame frameWithImageNamed:@"Icon-72@2x.png"];
    CCSpriteFrame *button4SpriteFrame = [CCSpriteFrame frameWithImageNamed:@"Icon-72@2x.png"];
    CCSpriteFrame *button5SpriteFrame = [CCSpriteFrame frameWithImageNamed:@"Icon-72@2x.png"];
    CCSpriteFrame *button6SpriteFrame = [CCSpriteFrame frameWithImageNamed:@"Icon-72@2x.png"];
    CCSpriteFrame *button7SpriteFrame = [CCSpriteFrame frameWithImageNamed:@"Icon-72@2x.png"];
    
    NSArray *buttonsArray = [NSArray arrayWithObjects:button1SpriteFrame, button2SpriteFrame, button3SpriteFrame, button4SpriteFrame, button5SpriteFrame, button6SpriteFrame, button7SpriteFrame, nil];
    
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
    [paramsDict setObject:buttonsArray forKey:NAKeyButtonSpriteFramesArray];
    
    // Adding Crousel Layer
    crouselNode = [[NACarouselScrollNode alloc] initWithDict:paramsDict withDelegate:self];
    
    [self addChild:crouselNode];
    [crouselNode setPosition:ccp(screenSize.width/2, screenSize.height/2)];

    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    // Log touch location
    // CCLOG(@"Touch Location @ %@",NSStringFromCGPoint(touchLoc));
    
    if (touchLoc.x > screenSize.width*(3.0f/4.0f)) {
        [crouselNode slideLeft];
    } else if (touchLoc.x < screenSize.width/4.0f) {
        [crouselNode slideRight];
    } else if ([crouselNode respondsToSelector:@selector(touchBegan:withEvent:)]) {
        [crouselNode touchBegan:touch withEvent:event];
    }
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
