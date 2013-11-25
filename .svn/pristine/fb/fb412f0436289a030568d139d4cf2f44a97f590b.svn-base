//
//  StainView.m
//  charmgram
//
//  Created by Rui Wei on 13-5-29.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "StainView.h"

@implementation StainView

- (id)init
{
    if ((self = [super init]))
    {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGPathRef roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, -1, -1) cornerRadius:self.layer.cornerRadius].CGPath;
    CGContextAddPath(context, roundedRect);
    CGContextClip(context);
	
    CGContextAddPath(context, roundedRect);
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 1), 3, UIColor.blackColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.backgroundColor.CGColor);
    CGContextStrokePath(context);
}

@end
