//
//  TrendsViewController.h
//  charmgram
//
//  Created by Rain on 13-6-6.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendsCell.h"
#import "RefreshTableFooter.h"
#import "RefreshTableHeader.h"
#import "UploadInfo.h"

@interface TrendsViewController : UITableViewController< ImageToolbarDelegate,RefreshTableHeaderDelegate, RefreshTableFooterDelegate,
	UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate, UploadImageDelegate,TabItemDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate>
{
    NSMutableArray* arrImage;
    NSMutableArray* arrUpload;
    NSMutableArray* arrWebMsg;
	
    RefreshTableHeader *refreshHeader;
    RefreshTableFooter *refreshFooter;
    BOOL loadingRefreshHeader;
    BOOL loadingRefreshFooter;
    BOOL loadingData;
    BOOL needRefreshData;
    BOOL isWebMsgRunning;
    UIView* headerUpload; 
    UITableView* tbUpload;
	PrivateImage *infoPimg;
    int  uploadInfoID;
    int pageIndex;
	int reportedImageId;
}
@property(nonatomic,strong) NSMutableArray* arrImage;
-(void)changeLblSec:(int)second celltag:(int)celltag;
@end
