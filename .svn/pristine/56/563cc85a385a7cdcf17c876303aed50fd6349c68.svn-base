//
//  TopSegmentBar.m
//  charmgram
//
//  Created by Rui Wei on 13-5-28.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "TopSegmentBar.h"

@implementation TopSegmentBar
@synthesize selectedSegmentIndex,delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        arrSegmentImage=[[NSMutableArray alloc] initWithCapacity:0];
		self.backgroundColor=[UIColor clearColor];
		frameWidth=frame.size.width;
		UIView *vbg=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, 36)];
		vbg.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
		[self addSubview:vbg];
		
		imgSelected=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"channel_selected_bottom_bg"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:0.0]];
		imgSelected.frame=CGRectMake(0, 36, 53, 8);
		[self addSubview:imgSelected];
		
		imgRightCap=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"channel_normal_bottom_bg"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:0.0]];
		imgRightCap.frame=CGRectMake(53, 36, frameWidth-53, 8);
		[self addSubview:imgRightCap];
        
        segmentPie=[[StainView alloc] init];
		[segmentPie setFrame:CGRectMake(0, 7, 67, 26)];
        segmentPie.backgroundColor=[UIColor colorWithWhite:0.78 alpha:1.0];
        segmentPie.layer.cornerRadius=13.0;
        [self addSubview:segmentPie];
        segmentPie.hidden=YES;
    }
    return self;
}
 
-(void)resetView:(NSArray*)arr arrImage:(NSArray*)arrImage{
	segmentCount=arr.count;
	int gap=20;
    [arrSegmentImage addObjectsFromArray:arrImage];
	int width=(kDeviceWidth-gap*(segmentCount+1))/segmentCount;
	for (int k=0; k<segmentCount; k++) {
        NSString* imgName=arrImage[k];
        UIImageView* img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        img.frame=CGRectMake((gap+width)*k+gap+13, 10.5, 50, 20);
		img.tag=200+k;
        [self addSubview:img]; 
        
		NSString* caption=arr[k];
		UILabel* lbl=[[UILabel alloc] initWithFrame:CGRectMake((gap+width)*k+gap, 4, width, 32)];
		lbl.text=[NSString stringWithFormat:@"     %@",caption];
		lbl.backgroundColor=[UIColor clearColor];
		lbl.textColor=[UIColor grayColor];
		lbl.font=[UIFont boldSystemFontOfSize:14.0];
		lbl.textAlignment=UITextAlignmentCenter;
		lbl.tag=100+k;
		lbl.userInteractionEnabled=YES;
		UITapGestureRecognizer* taplbl=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
		taplbl.numberOfTapsRequired=1;
		taplbl.numberOfTouchesRequired=1;
		[lbl addGestureRecognizer:taplbl];
		
		[self addSubview:lbl];
	}
//	imgSelected=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"channel_selected_bottom_bg"]];
//	imgSelected.frame=CGRectMake(0, 32, 53, 8);
//	[self addSubview:imgSelected];
}

-(void)tapLabel:(UITapGestureRecognizer*)gesture{
	int itag=gesture.view.tag;
	int index=itag-100;
	[self setSelectedIndex:index animated:YES];
}

-(void)setSelectedIndex:(int )index animated:(BOOL)animated{
	self.selectedSegmentIndex=index;
	int itag=100+index;
	CGRect lblframe=CGRectZero;
	for (int k=0; k<segmentCount; k++) {
		UIImageView* img=(UIImageView*)[self viewWithTag:200+k];
        img.image=[UIImage imageNamed:arrSegmentImage[k]];
		UILabel* lbl=(UILabel*)[self viewWithTag:100+k];
		lbl.textColor=[UIColor grayColor];
		if (100+k==itag) {
			lbl.textColor=[UIColor blackColor];
			lblframe=lbl.frame;
            img.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_h",arrSegmentImage[k]]];
		}
	}
	
    CGRect pieframe=segmentPie.frame;
    pieframe.origin.x=lblframe.origin.x+lblframe.size.width/2-pieframe.size.width/2;
    
    
	CGRect newframe=imgSelected.frame;
	newframe.size.width=lblframe.origin.x+lblframe.size.width/2+26;
	
	int left=newframe.size.width-1;
	CGRect newframe2=imgRightCap.frame;
	newframe2.origin.x=left;
	newframe2.size.width=frameWidth-left ;
	if (animated) {
		[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
			imgSelected.frame=newframe;
			imgRightCap.frame=newframe2;
            segmentPie.frame=pieframe;
		} completion:nil];
	}
	else{
		imgSelected.frame=newframe;
		imgRightCap.frame=newframe2;
        segmentPie.frame=pieframe;
	}
	
	if (animated && self.delegate && [self.delegate conformsToProtocol:@protocol(TopSegmentBarDelegate)]) {
		[self.delegate didChangeSegment:self.selectedSegmentIndex];
	}
}
 

@end
