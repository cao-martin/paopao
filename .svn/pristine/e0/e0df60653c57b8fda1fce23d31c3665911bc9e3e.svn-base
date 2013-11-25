//
//  RefreshTableHeader.h
//  Youliao
//
//  Created by Rain on 13-1-11.
//  Copyright (c) 2013年 com.youliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	PullRefreshPulling = 0,
	PullRefreshNormal,
	PullRefreshLoading,
} PullRefreshState;

@protocol RefreshTableHeaderDelegate;

@interface RefreshTableHeader : UIView
{
    UILabel *lblHeaderTip;
    UILabel *lblHeaderDate;
    UIActivityIndicatorView *loadingView;
    UIImageView* imgRefresh;
//    id _delegate;
    PullRefreshState _state;
}
@property(nonatomic,weak) id delegate;
- (void)refreshLastUpdatedDate;
- (void)RefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)RefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)RefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
-(void)ManualDragScrollViewToRefresh:(UIScrollView *)scrollView;
@end

@protocol RefreshTableHeaderDelegate
- (void)RefreshTableHeaderDidTriggerRefresh:(RefreshTableHeader*)view;
- (BOOL)RefreshTableHeaderDataSourceIsLoading:(RefreshTableHeader*)view;
@optional
- (NSDate*)RefreshTableHeaderDataSourceLastUpdated:(RefreshTableHeader*)view;
@end