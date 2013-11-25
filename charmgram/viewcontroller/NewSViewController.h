//
//  NewSViewController.h
//  charmgram
//
//  Created by martin on 13-7-31.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsInfo.h"
#import "NewsCell.h"
@interface NewSViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UILabel* lblNews;
    UILabel* lblShixin;
    UIImageView* imgBg;
    UIButton* btnSeg;
    
    UITableView* tbNews;
    NSMutableArray* arrNews;
    UITableView* tbShixin;
    NSMutableArray* arrShixin;
    
    int selectedIndex;
	
}
-(void)refreshData;
@end
