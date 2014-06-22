//
//  NACarouselScrollNode.m
//  CarouselScrollNode
//
//  Created by Navarjun on 17/06/14.
//  Copyright 2014 Navarjun. All rights reserved.
//

#import "cocos2d-ui.h"
#import "NACarouselScrollNode.h"
#import "NACarouselSprite.h"

@implementation NACarouselScrollNode

#pragma mark -- INIT METHOD --

-(id) initWithDict:(NSDictionary*) paramsDict withDelegate:(id<NACarouselScrollNodeDelegate>) delegate {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        noOfAnimationsRunning = 0;
        _delegate = delegate;
        
        [self setVariablesFromDict:paramsDict];
        
        NACarouselSprite *buttonSprite = [NACarouselSprite spriteWithSpriteFrame:[buttonSpriteFramesArray objectAtIndex:0]];
        noOfButtonsVisible = 5;
        frontButtonIndex = floorf([buttonSpriteFramesArray count]/2.0f);
        float posAdjustingVar = buttonSprite.contentSize.width;
        
        for (int i = 0; i < [buttonSpriteFramesArray count]; i++) {
            NACarouselSprite *button = [NACarouselSprite spriteWithSpriteFrame:[buttonSpriteFramesArray objectAtIndex:i]];
            [button setScale:1.0f - 0.2 * fabsf(i - frontButtonIndex)];
            [button setPosition:ccp(posAdjustingVar * (i - frontButtonIndex) * button.scale, 0)];
            
            if (hasProgressiveOpacity)
                [button setOpacity:1.0f/(fabsf(i - frontButtonIndex) + 1)];
            
            [self addChild:button z:(-1)*fabsf(i - frontButtonIndex) + [buttonSpriteFramesArray count]];
            
            if (fabsf(i-frontButtonIndex) > floorf(noOfButtonsVisible/2.0f)) {
                [button setOpacity:0.0f];
            }
            
            [buttonSpritesArray addObject:button];
        }
        
        buttonSpriteFramesArray = nil;
    }
    return self;
}

#pragma mark -- SLIDING FUNCTIONS --

-(void) slideLeft {
    if (!noOfAnimationsRunning) {
        [self slideToButtonIndex:frontButtonIndex+1];
    }
}

-(void) slideRight {
    if (!noOfAnimationsRunning) {
        [self slideToButtonIndex:frontButtonIndex-1];
    }
}

#pragma mark -- GETTER METHODS --

-(int) getFrontButtonIndex {
    return frontButtonIndex;
}

#pragma mark -- PRIVATE METHODS --

-(void) setVariablesFromDict:(NSDictionary*) dict {
    buttonSpriteFramesArray = [dict objectForKey:NAKeyButtonSpriteFramesArray];
    NSAssert(buttonSpriteFramesArray, @"Buttons Array Cannot be nil");
    
    buttonSpritesArray = [[NSMutableArray alloc] init];
    
    if ([dict objectForKey:NAKeyAnimationDuration]) {
        animDuration = [[dict objectForKey:NAKeyAnimationDuration] floatValue];
    } else {
        animDuration = 1.0f;
    }
    
    if ([dict objectForKey:NAKeyHasProgressiveOpacity]) {
        hasProgressiveOpacity = [[dict objectForKey:NAKeyHasProgressiveOpacity] boolValue];
    } else {
        hasProgressiveOpacity = YES;
    }
}

-(void) slideToButtonIndex:(int) index {
    NSMutableArray *actionsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [buttonSpritesArray count]; i++) {
        NACarouselSprite *refButton;
        if (i+frontButtonIndex-index >= 0 && i+frontButtonIndex-index < [buttonSpritesArray count]) {
            refButton = [buttonSpritesArray objectAtIndex:i+frontButtonIndex-index];
        } else {
            if (i+frontButtonIndex-index < 0) {
                refButton = [buttonSpritesArray lastObject];
            } else {
                refButton = [buttonSpritesArray firstObject];
            }
        }
        
        CCAction *action = [CCActionSpawn actions:
                            [CCActionScaleTo actionWithDuration:animDuration scale:refButton.scale],
                            [CCActionMoveTo actionWithDuration:animDuration position:refButton.position],
                            [CCActionFadeTo actionWithDuration:animDuration opacity:refButton.opacity],
                            nil];
        
        [actionsArray addObject:[CCActionSequence actions:(CCActionFiniteTime*)action, [CCActionCallFunc actionWithTarget:self selector:@selector(animationDidStop)], nil]];
    }
    
    if (index == [buttonSpritesArray count]) {
        index = 0;
    } else if (index < 0) {
        index = (int)[buttonSpritesArray count] - 1;
    }
    frontButtonIndex = index;
    
    for (int i = 0; i < [buttonSpritesArray count]; i++) {
        NACarouselSprite *button = [buttonSpritesArray objectAtIndex:i];
        [button runAction:[actionsArray objectAtIndex:i]];
        noOfAnimationsRunning++;
        [button setZOrder:(-1)*fabsf(i - frontButtonIndex) + [buttonSpritesArray count]];
    }
}

-(void) animationDidStop {
    noOfAnimationsRunning--;
}

#pragma mark -- TOUCH HANDLERS --

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    // Log touch location
    // CCLOG(@"Touch Location @ %@",NSStringFromCGPoint(touchLoc));
    
    NACarouselSprite *button = (NACarouselSprite*)[buttonSpritesArray objectAtIndex:frontButtonIndex];
    if (CGRectContainsPoint([button boundingBox], touchLoc)) {
        [_delegate tappedButtonAtIndex:frontButtonIndex];
    }
}

@end
