//
//  RefreshTableHeader.m
//  Youliao
//
//  Created by Rain on 13-1-11.
//  Copyright (c) 2013年 com.youliao. All rights reserved.
//

#import "RefreshTableHeader.h"
#define kTableMessageHeaderHeight 250 
#define FLIP_ANIMATION_DURATION 0.2

@implementation RefreshTableHeader
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor =[UIColor clearColor];
        
        lblHeaderTip=[[UILabel alloc] initWithFrame:CGRectMake(0, kTableMessageHeaderHeight-52, kDeviceWidth, 20)];
        lblHeaderTip.text=@"下拉可以刷新";
        lblHeaderTip.textAlignment=UITextAlignmentCenter;
        lblHeaderTip.textColor=[UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1];
        lblHeaderTip.font=[UIFont boldSystemFontOfSize:15.0];
        lblHeaderTip.backgroundColor=[UIColor clearColor];
        [self addSubview:lblHeaderTip];
        
        lblHeaderDate=[[UILabel alloc] initWithFrame:CGRectMake(0, kTableMessageHeaderHeight-32, kDeviceWidth, 20)];
        lblHeaderDate.text=@"最后更新于";
        lblHeaderDate.textAlignment=UITextAlignmentCenter;
        lblHeaderDate.textColor=[UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1];
        lblHeaderDate.font=[UIFont systemFontOfSize:12.0];
        lblHeaderDate.backgroundColor=[UIColor clearColor];
        [self addSubview:lblHeaderDate];
//        [self refreshHeaderDate];
        
        loadingView=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(82, kTableMessageHeaderHeight-52, 20, 20)];
        [loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [loadingView stopAnimating];
        [loadingView setHidden:YES];
        [self addSubview:loadingView];
        
        imgRefresh=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Refresh_Arrow.png"]];
        imgRefresh.frame=CGRectMake(84, kTableMessageHeaderHeight-48, 17, 14);
        [self addSubview:imgRefresh];
    }
    return self;
}

- (void)refreshLastUpdatedDate {
	
	if ([self.delegate respondsToSelector:@selector(RefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [self.delegate RefreshTableHeaderDataSourceLastUpdated:self];
		 
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *strdate = [formatter stringFromDate:date];
 
        
//		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
//		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
//		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
		lblHeaderDate.text = [NSString stringWithFormat:@"上次更新于 %@", strdate];
        /*
        NSString *key=[NSString stringWithFormat:@"RefreshHeader_LastRefresh%d",self.tag];
		[[NSUserDefaults standardUserDefaults] setObject:lblHeaderDate.text forKey:key];
		[[NSUserDefaults standardUserDefaults] synchronize];
         */
		
	} else {
		
		lblHeaderDate.text = nil;
		
	}
    
}

- (void)RefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (_state == PullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, scrollView.contentInset.bottom, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([self.delegate respondsToSelector:@selector(RefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [self.delegate RefreshTableHeaderDataSourceIsLoading:self];
		}
		
        if (_state == PullRefreshPulling
            && scrollView.contentOffset.y > -65.0f
            && scrollView.contentOffset.y < 0.0f
            && !_loading) {
			[self setState:PullRefreshNormal];
		} else if (_state ==  PullRefreshNormal
                   && scrollView.contentOffset.y < -65.0f
                   && !_loading) {
			[self setState: PullRefreshPulling];
		}
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
}

-(void)ManualDragScrollViewToRefresh:(UIScrollView *)scrollView{
	BOOL _loading = NO;
	if ([self.delegate respondsToSelector:@selector(RefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [self.delegate RefreshTableHeaderDataSourceIsLoading:self];
	}
	[scrollView setContentOffset:CGPointMake(0, -65.0) animated:YES];
	[self setState: PullRefreshPulling];
	if ([self.delegate respondsToSelector:@selector(RefreshTableHeaderDidTriggerRefresh:)]) {
		[self.delegate RefreshTableHeaderDidTriggerRefresh:self];
	}
	[self setState: PullRefreshLoading];
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.2];
//	scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, scrollView.contentInset.bottom, 0.0f);
//	[UIView commitAnimations];
}

- (void)RefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([self.delegate respondsToSelector:@selector(RefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [self.delegate RefreshTableHeaderDataSourceIsLoading:self];
	}
//	CGFloat newy=scrollView.contentOffset.y;
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
		if ([self.delegate respondsToSelector:@selector(RefreshTableHeaderDidTriggerRefresh:)]) {
			[self.delegate RefreshTableHeaderDidTriggerRefresh:self];
		}
		[self setState: PullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, scrollView.contentInset.bottom, 0.0f);
		[UIView commitAnimations];
	}
	
}

- (void) RefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
//	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, scrollView.contentInset.bottom, 0.0f)];
    [scrollView setContentInset:UIEdgeInsetsZero];
	[UIView commitAnimations];
	
	[self setState: PullRefreshNormal];
}

- (void)setState:(PullRefreshState)aState{
	
	switch (aState) {
		case PullRefreshPulling:
		{
			lblHeaderTip.text = NSLocalizedString(@"释放更新", @"释放更新");
//			[CATransaction begin];
//			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
//			imgRefresh.layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
//			[CATransaction commit];
			
			[UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
				imgRefresh.transform=CGAffineTransformMakeRotation(M_PI  );
			}];
		}
			break;
		case PullRefreshNormal:
		{
			if (_state ==  PullRefreshPulling) {
//				[CATransaction begin];
//				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
//				imgRefresh.layer.transform = CATransform3DIdentity;
//				[CATransaction commit];
				[UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
					imgRefresh.transform=CGAffineTransformIdentity;
				}];
			}
			lblHeaderTip.text = NSLocalizedString(@"下拉更新", @"下拉更新");
			[loadingView stopAnimating];
//			[CATransaction begin];
//			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//			imgRefresh.hidden = NO;
//			imgRefresh.layer.transform = CATransform3DIdentity;
//			[CATransaction commit];
			imgRefresh.hidden = NO;
			[UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
				imgRefresh.transform=CGAffineTransformIdentity;
			}];
			
			[self refreshLastUpdatedDate];
		}
			break;
		case PullRefreshLoading:
		{
			lblHeaderTip.text = NSLocalizedString(@"正在加载...", @"正在加载...");
			[loadingView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			imgRefresh.hidden = YES;
			[CATransaction commit];
		}
			break;
		default:
			break;
	}
	
	_state = aState;
}
@end
