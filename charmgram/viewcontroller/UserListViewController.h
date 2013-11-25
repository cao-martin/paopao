//
//  UserListViewController.h
//  charmgram
//
//  Created by Rain on 13-7-7.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* arrUser;
    UILabel* lblTitle;
    UITableView* tbContent;
}
@property(nonatomic,assign)BOOL isFanList;
@property(nonatomic,assign)int listUserid;
-(void)refreshData;
@end
