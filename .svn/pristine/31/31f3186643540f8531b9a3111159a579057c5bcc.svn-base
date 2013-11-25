//
//  RefreshTableFooter.m
//  Youliao
//
//  Created by Rain on 13-1-11.
//  Copyright (c) 2013年 com.youliao. All rights reserved.
//

#import "RefreshTableFooter.h"
#define TEXT_COLOR [UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1]
#define FLIP_ANIMATION_DURATION 0.2f

@implementation RefreshTableFooter
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame  textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		self.backgroundColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1.0];
        self.backgroundColor=[UIColor clearColor];
        
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, (frame.size.height-20)/2, frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:15.0f];
		label.textColor = textColor;
        //		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        //		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label; 
		
//		CALayer *layer = [CALayer layer];
//		layer.frame = CGRectMake(95.0f, (frame.size.height-14)/2, 17.0f, 14.0f);
//		layer.contentsGravity = kCAGravityResizeAspect;
//		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
//		
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
//		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//			layer.contentsScale = [[UIScreen mainScreen] scale];
//		}
//#endif
//		
//		[[self layer] addSublayer:layer];
//		_arrowImage=layer;
		
		imgRefresh=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Refresh_Arrow_up"]];
        imgRefresh.frame=CGRectMake(95.0f, (frame.size.height-14)/2, 17.0f, 14.0f);
        [self addSubview:imgRefresh];
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(95.0f, (frame.size.height-20)/2, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view; 
		
		[self setState:PullRefreshFooterNormal];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame  textColor:TEXT_COLOR];
}

#pragma mark - Setters

- (void)refreshLastUpdatedDate {
	
	if ([self.delegate respondsToSelector:@selector(RefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [self.delegate RefreshTableFooterDataSourceLastUpdated:self];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *strdate = [formatter stringFromDate:date]; 
        
//		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
//		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
//		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", strdate];
        /*
        NSString *key=[NSString stringWithFormat:@"RefreshFooter_LastRefresh%d",self.tag];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:key];
		[[NSUserDefaults standardUserDefaults] synchronize];
         */
		
	} else {
		_lastUpdatedLabel.text = nil;
	}
    
}

- (void)setState:(PullRefreshFooterState)aState{
	
	switch (aState) {
		case  PullRefreshFooterPulling:
		{
			_statusLabel.text = NSLocalizedString(@"释放更新", @"Release to refresh status");
			[UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
				imgRefresh.transform=CGAffineTransformMakeRotation(M_PI );
			}];
		}
			break;
		case  PullRefreshFooterNormal:
		{
			if (_state ==  PullRefreshFooterPulling) {
				[UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
					imgRefresh.transform = CGAffineTransformIdentity;
				}];
			}
			
			_statusLabel.text = NSLocalizedString(@"上拉加载", @"Pull down to refresh status");
			[_activityView stopAnimating];
			imgRefresh.hidden = NO; 
			[UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
				imgRefresh.transform = CGAffineTransformIdentity;
			}];
			[self refreshLastUpdatedDate];
		}
			break;
		case  PullRefreshFooterLoading:
		{
			_statusLabel.text = NSLocalizedString(@"正在加载...", @"Loading Status");
			[_activityView startAnimating]; 
			imgRefresh.hidden = YES;
		}
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark - ScrollView Methods

- (void)RefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (_state ==  PullRefreshFooterLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y, 0);
		offset = MIN(offset, RefreshViewHight);
		scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, 0.0f, offset, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([self.delegate respondsToSelector:@selector(RefreshTableFooterDataSourceIsLoading:)]) {
			_loading = [self.delegate RefreshTableFooterDataSourceIsLoading:self];
		}
//		CGFloat sy=scrollView.contentOffset.y;
//        DLog(@" sy: %f ;_state:%d; height: %f",sy,_state, scrollView.contentSize.height);
        
        if (_state ==  PullRefreshFooterPulling
			&& scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + RefreshViewHight
            && scrollView.contentOffset.y > 0.0f
			&& !_loading) {
			[self setState: PullRefreshFooterNormal];
		} else if (_state ==  PullRefreshFooterNormal
				   && scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height+ 30.0f
				   && !_loading) {
			[self setState: PullRefreshFooterPulling];
		}
		
		if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)RefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([self.delegate respondsToSelector:@selector(RefreshTableFooterDataSourceIsLoading:)]) {
		_loading = [self.delegate  RefreshTableFooterDataSourceIsLoading:self];
	}
	
    if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + 30
        && !_loading
        && scrollView.contentOffset.y > 0 ) {
		if ([self.delegate respondsToSelector:@selector(RefreshTableFooterDidTriggerRefresh:)]) {
			[self.delegate RefreshTableFooterDidTriggerRefresh:self];
		}
		
		[self setState: PullRefreshFooterLoading];
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, 0.0f, RefreshViewHight, 0.0f);
        }]; 
	}
	
}

- (void)RefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(scrollView.contentInset.top, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState: PullRefreshFooterNormal];
    
}


@end

