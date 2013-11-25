//
//  FujinViewController.h
//  charmgram
//
//  Created by Rui Wei on 13-3-25.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FujinCell.h"
@interface FujinViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
	NSMutableArray* arrImage;
	UITableView* tbContent;
}
-(void)refreshData;
@end
