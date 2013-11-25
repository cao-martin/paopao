//
//  PurchaseViewController.h
//  charmgram
//
//  Created by Rui Wei on 13-5-12.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentViewController.h"
@interface PurchaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
	UITableView* tbMain;
	NSMutableArray* arrItem;
}
@end
