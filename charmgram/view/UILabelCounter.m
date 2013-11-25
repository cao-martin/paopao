//
//  UILabelCounter.m
//  woqifu
//
//  Created by Rain on 13-4-22.
//  Copyright (c) 2013年 woqifu. All rights reserved.
//

#import "UILabelCounter.h"

@implementation UILabelCounter
@synthesize maxCount,seperator,typeCount;
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect{ 
    
//    float start_x=0;
    CGSize charSize = [@"1" sizeWithFont:self.font
                       constrainedToSize:CGSizeMake(100, 100)
                           lineBreakMode:NSLineBreakByWordWrapping];
    float width=charSize.width;
    float height=self.font.pointSize;
    float y=(self.frame.size.height- charSize.height)/2;
    if (self.typeCount>self.maxCount) {
        [ChineseFontRedColor set];
    }
    else{
        [self.textColor set];
    }
    int leftCount=0;
    NSString* temp=[NSString stringWithFormat:@"%d",self.typeCount];
    for (int i=0; i<temp.length; i++) { 
        CGRect Aframe=CGRectMake(leftCount*width, y, width, height);
        NSRange range;
        range.length=1;
        range.location=i;
        NSString* str=[temp substringWithRange:range];
        [str drawInRect:Aframe withFont:self.font lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        leftCount++;
    }
    [self.textColor set];
    temp=[NSString stringWithFormat:@"%@%d",self.seperator,self.maxCount];
    for (int i=0; i<temp.length; i++) { 
        CGRect Aframe=CGRectMake(leftCount*width, y, width, height);
        NSRange range;
        range.length=1;
        range.location=i;
        NSString* str=[temp substringWithRange:range];
        [str drawInRect:Aframe withFont:self.font lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        leftCount++;
    }
}

@end
