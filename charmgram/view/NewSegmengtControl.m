//
//  NewSegmengtControl.m
//  NXJ
//
//  Created by apple on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewSegmengtControl.h"

@implementation NewSegmengtControl
- (id)initWithFrame:(CGRect)frame withSEL:(id)sel withLeft:(NSString *)left withRight:(NSString *)right{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		//修改搜索框背景
		
//		self.backgroundColor=[UIColor clearColor];
//        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//        imageV.image = [UIImage imageNamed:@"cell_sort_bg_img.png"];
//		[self addSubview:imageV];
//        [imageV release];
        
        // Image And title
        NSArray *array = [[NSArray alloc] initWithObjects:@"",@"" ,nil];
        
        UIImage *normal_left = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@2@2x",left] ofType:@"png"]];
        //UIImage *normal_center = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cell_sort_distance_img" ofType:@"png"]];
        UIImage *normal_right = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@2@2x",right] ofType:@"png"]];
        
   
        NSMutableArray *unselectImages = [[NSMutableArray alloc]initWithObjects:normal_left, normal_right, nil];
        
        UIImage *select_left = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@1@2x",left] ofType:@"png"]];
        UIImage *select_right = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@1@2x",right] ofType:@"png"]];
        
        NSMutableArray *selectImages = [[NSMutableArray alloc]initWithObjects: select_left,select_right, nil];
        
        CQSegmentControl *_segmentedControl= [[CQSegmentControl alloc] initWithItemsAndStype:array stype:TitleAndImageSegmented];
        for (UIView *subView in _segmentedControl.subviews) 
        {
            [subView removeFromSuperview];
        }
        _segmentedControl.seg = sel;
        _segmentedControl.normalImageItems = unselectImages;
        _segmentedControl.highlightImageItems = selectImages;
        
        
        _segmentedControl.selectedSegmentIndex = 0;
        
        _segmentedControl.frame = CGRectMake(17.0f,1.0f, 104, 27.5);
        _segmentedControl.selectedItemColor = [UIColor whiteColor];
        _segmentedControl.unselectedItemColor = [UIColor colorWithRed:1.0f/255.0f green:88.0f/255.0f blue:1.0f/255.0f alpha:1];
        
        [_segmentedControl addTarget:self action:@selector(test:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.font = [UIFont systemFontOfSize:14];
        [self addSubview:_segmentedControl];
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */
//- (void)test:(CQSegmentControl *)sender
//{
//  //  sender.selectedSegmentIndex
//    [seg changeSegmengDelegate:sender withIndex:sender.selectedSegmentIndex];
//}

@end
