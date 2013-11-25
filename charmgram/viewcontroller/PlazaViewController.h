//
//  PlazaViewController.h
//  charmgram
//
//  Created by Rui Wei on 13-6-2.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivateImage.h"
#import "FaxianCell.h"
#import "FujinCell.h"
#import "RefreshTableHeader.h"
#import "RefreshTableFooter.h"

@interface PlazaViewController : UITableViewController<RefreshTableHeaderDelegate, RefreshTableFooterDelegate>
{
	NSMutableArray* arrImage;
	
	RefreshTableHeader *refreshHeader;
    RefreshTableFooter *refreshFooter;
    BOOL loadingLobbyHeader;
    BOOL loadingLobbyFooter;
    BOOL loadingData;
    BOOL needRefreshData;
    int pageIndex;
	int locatedCount;
}
@property (nonatomic,assign)int PlazaType;
- (id)initWithStyle:(UITableViewStyle)style plazatype:(int)plazatype;
-(void)refreshData;
-(void)clearData;
@end
