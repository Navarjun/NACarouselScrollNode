//
//  NACarouselSprite.m
//  CarouselScrollNode
//
//  Created by Navarjun on 18/06/14.
//  Copyright (c) 2014 Navarjun. All rights reserved.
//

#import "NACarouselSprite.h"

@implementation NACarouselSprite

-(void) setOpacity:(CGFloat)opacity {
    [super setOpacity:opacity];
    if (opacity == 0) {
        [self setVisible:NO];
    } else {
        [self setVisible:YES];
    }
}

@end
