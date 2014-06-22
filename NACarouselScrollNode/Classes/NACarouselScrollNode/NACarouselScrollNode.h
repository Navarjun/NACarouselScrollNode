//
//  NACarouselScrollNode.h
//  CarouselScrollNode
//
//  Created by Navarjun on 17/06/14.
//  Copyright 2014 Navarjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// KEYS FOR paramsDict, USED FOR INITIALIZATION
//
// - SPRITEFRAMES FOR EACH BUTTON
#define NAKeyButtonSpriteFramesArray     @"buttonsArray"
//
// - HOW LONG SHOULD IT TAKE TO ANIMATE ONE STEP (BY DEFAULT 1 SECOND)
#define NAKeyAnimationDuration           @"animDuration"
//
// - HASPROGRESSIVE OPACITY FOR BUTTONS
#define NAKeyHasProgressiveOpacity       @"hasProgressiveOpacity"


// THE PARENT SHOULD CONFORM TO THIS PROTOCOL
@protocol NACarouselScrollNodeDelegate <NSObject>

// CALLED WHEN BUTTON IS TAPPED
-(void) tappedButtonAtIndex:(int) index;

@end


// NACAROUSELNODE INTERFACE
@interface NACarouselScrollNode : CCNode {
    NSArray *buttonSpriteFramesArray;
    NSMutableArray *buttonSpritesArray;
    id<NACarouselScrollNodeDelegate> _delegate;
    
    int noOfButtonsVisible, frontButtonIndex, noOfAnimationsRunning;
    float animDuration;
    BOOL hasProgressiveOpacity;
}

// USED THIS INITIALIZATION
-(id) initWithDict:(NSDictionary*) paramsDict withDelegate:(id<NACarouselScrollNodeDelegate>) delegate;

// TELL THE NODE WHICH SIDE TO SCROLL
- (void) slideLeft;
- (void) slideRight;

// RETURNS THE FRONT BUTTON INDEX WHEN CALLED
-(int) getFrontButtonIndex;

@end

// PS
// 
// PLEASE ADD THE FOLLOWING CODE TO TOUCHBEGAN METHOD OF THE PARENT
//
//  if ([crouselNode respondsToSelector:@selector(touchBegan:withEvent:)]) {
//      [crouselNode touchBegan:touch withEvent:event];
//  }
//
//  crouselNode is the object of NACarouselNode