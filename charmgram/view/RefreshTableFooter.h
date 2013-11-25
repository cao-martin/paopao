//
//  RefreshTableFooter.h
//  Youliao
//
//  Created by Rain on 13-1-11.
//  Copyright (c) 2013年 com.youliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#define  RefreshViewHight 5.0f

typedef enum{
	 PullRefreshFooterPulling = 0,
	 PullRefreshFooterNormal,
	 PullRefreshFooterLoading,
}  PullRefreshFooterState;

@protocol RefreshTableFooterDelegate;
@interface RefreshTableFooter : UIView
{ 
	PullRefreshFooterState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel; 
	UIActivityIndicatorView *_activityView;
	UIImageView* imgRefresh;
}
@property(nonatomic,weak) id delegate;

- (id)initWithFrame:(CGRect)frame  textColor:(UIColor *)textColor;

- (void)refreshLastUpdatedDate;
- (void)RefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)RefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)RefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
@protocol RefreshTableFooterDelegate
- (void)RefreshTableFooterDidTriggerRefresh:(RefreshTableFooter*)view;
- (BOOL)RefreshTableFooterDataSourceIsLoading:(RefreshTableFooter*)view;
@optional
- (NSDate*)RefreshTableFooterDataSourceLastUpdated:(RefreshTableFooter*)view;
@end
