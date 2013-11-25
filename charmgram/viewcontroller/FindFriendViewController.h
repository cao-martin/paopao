//
//  FindFriendViewController.h
//  charmgram
//
//  Created by martin on 13-8-23.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindFriendViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UILabel* lblFollow;
    UILabel* lblFans;
    UIImageView* imgBg;
    UIButton* btnSeg;
    
    UITableView* tbFollow;
    NSMutableArray* arrFollow;
    NSMutableArray* arrScetion;
    NSMutableArray *arrTotal;
    UIButton *btnWx;
    UIButton *btnYQ;
    int selectedIndex;
    int count;
    UISearchBar *search;
    UIImageView *imgSearchBg;
    UISearchBar *tvSearch;
}
@end
