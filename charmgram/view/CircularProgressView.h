//
//  CircularProgressView.h
//  CircularProgressView
//
//  Created by nijino saki on 13-3-2.
//  Copyright (c) 2013年 nijino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol CircularProgressDelegate;

@interface CircularProgressView : UIView

 
- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth;
//- (void)play;
//- (void)pause;
//- (void)revert;
- (void)setProgress:(float)newProgress;
- (void)setProgress:(float)progress animated:(BOOL)animated;
@end

@protocol CircularProgressDelegate <NSObject>

- (void)didUpdateProgressView;

@end