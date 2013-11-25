//
//  WhoConcernMeView.h
//  PhotoSharing
//
//  Created by user on 11-12-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"

//#import "iToast.h"


@interface WhoConcernMeView : UIView<UITableViewDataSource,UITableViewDelegate> {
	UIButton *nameButton;
	UITableView *concernMeTV;
	
	NSMutableArray *arrCpzQuery;
	
	BOOL iffresh;
	
	
	NSMutableArray *arr;
	
	UIAlertView *alertPage;
	UIActivityIndicatorView *acView;

}
-(void)initViews;
//自己关注的
-(void)getToMe;
@property (nonatomic, retain) UIButton *nameButton; 
@property (nonatomic, retain) UITableView *concernMeTV; 
- (void)addActiveAlert;
@end
