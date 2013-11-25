//
//  ConcernMessageView.h
//  PhotoSharing
//
//  Created by user on 11-12-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"

//#import "iToast.h"


@interface ConcernMessageView : UIView<UITableViewDataSource> {
	UITableView *TVConfig;
	
	NSMutableArray *arrCpzQuery;
	
	BOOL iffresh;
	
}
-(void)initViews;

//关于自己的
-(void)getFromMe;
@end
