//
//  CircularProgressView.m
//  CircularProgressView
//
//  Created by nijino saki on 13-3-2.
//  Copyright (c) 2013年 nijino. All rights reserved.
//

#import "CircularProgressView.h"

@interface CircularProgressView ()<AVAudioPlayerDelegate>

@property (strong, nonatomic) UIColor *backColor;
@property (strong, nonatomic) UIColor *progressColor;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) float myprogress;

@property (assign, nonatomic) id <CircularProgressDelegate> delegate;
@end

@implementation CircularProgressView
@synthesize myprogress;
- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth 
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        _backColor = backColor;
        _progressColor = progressColor;
        _lineWidth = lineWidth;

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{ 
    //draw background circle
    UIBezierPath *backCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2) radius:self.bounds.size.width / 2 - self.lineWidth / 2 startAngle:(CGFloat) -M_PI_2+ M_PI/10 endAngle:(CGFloat)(1.5 * M_PI - M_PI/10) clockwise:YES];
    [self.backColor setStroke];
    backCircle.lineWidth = self.lineWidth;
    backCircle.lineCapStyle=kCGLineCapRound;
    backCircle.lineJoinStyle=kCGLineJoinRound;
    [backCircle stroke];
    
    if (self.myprogress > 0.0) {
        //draw progress circle
        UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2) radius:self.bounds.size.width / 2 - self.lineWidth / 2 startAngle:(CGFloat) -M_PI_2+ M_PI/10 endAngle:(CGFloat)self.myprogress*(2 * M_PI - M_PI/5)-M_PI_2+ M_PI/10 clockwise:YES];
        [self.progressColor setStroke];
        progressCircle.lineWidth = self.lineWidth;
        progressCircle.lineCapStyle=kCGLineCapRound;
        progressCircle.lineJoinStyle=kCGLineJoinRound;
        [progressCircle stroke];
    }
}

-(void)setProgress:(float)newProgress{
    self.myprogress=newProgress;
    [self setNeedsDisplay];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    [self setProgress:progress];
}
@end
