//
//  TopSegmentBar.h
//  charmgram
//
//  Created by Rui Wei on 13-5-28.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StainView.h"

@protocol TopSegmentBarDelegate <NSObject>

@optional
-(void)didChangeSegment:(int)index;

@end
 

@interface TopSegmentBar : UIView
{
	NSMutableArray* arrSegmentImage;
	UIImageView* imgSelected;
	UIImageView* imgRightCap;
    StainView* segmentPie;
	int frameWidth;
	int segmentCount; 
}
@property (nonatomic,assign)int selectedSegmentIndex;
@property (nonatomic,assign)id delegate;
-(void)resetView:(NSArray*)arr arrImage:(NSArray*)arrImage;
-(void)setSelectedIndex:(int )index animated:(BOOL)animated;
@end
