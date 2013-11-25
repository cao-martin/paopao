//
//  CoinListViewController.h
//  charmgram
//
//  Created by 曹鹏鹏 on 13-11-3.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableHeader.h"
#import "RefreshTableFooter.h"

@interface CoinListViewController : UIViewController<RefreshTableFooterDelegate,RefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate>
{
    RefreshTableHeader *refreshHeader;
    RefreshTableFooter *refreshFooter;
    BOOL loadingLobbyHeader;
    BOOL loadingLobbyFooter;
    BOOL loadingData;
    BOOL needRefreshData;
    int pageIndex;
	int locatedCount;
    UITableView *tabeCoin;
    NSMutableArray *arrPointLogs;
}
@end
