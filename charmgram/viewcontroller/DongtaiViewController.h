//
//  DongtaiViewController.h
//  charmgram
//
//  Created by Rui Wei on 13-3-25.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaxianCell.h"
@interface DongtaiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
-(void)refreshData;
@end
