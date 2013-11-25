//
//  FriendViewController.h
//  charmgram
//
//  Created by Rui Wei on 13-3-26.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "UserCell.h"
@interface FriendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UILabel* lblFollow;
    UILabel* lblFans;
    UIImageView* imgBg;
    UIImageView* imgSeg;
    
    UITableView* tbFollow;
    NSMutableArray* arrFollow;
    
    UITableView* tbFan;
    NSMutableArray* arrFan;
    
    UILabel *lblTuiJian;
    NSMutableArray *arrTuiJian;
    UITableView * tbTuiJian;
    int selectedIndex;
	
	UISearchBar* tvSearch;
    UITableView * tbSearch;
    NSMutableArray *arrSearch;
    
}
-(void)refreshData;
-(void)clearData;
-(void)hideKeyWin;
@end
