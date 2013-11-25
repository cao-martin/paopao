//
//  TrendsViewController.m
//  charmgram
//
//  Created by Rain on 13-6-6.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "TrendsViewController.h"
#import "GiftViewController.h"
#import "ChatViewController.h"
#import "UIImageView+WebCache.h"
#import "ReportViewController.h"
#define UPLOAD_ITEM_HEIGHT      54

@interface TrendsViewController ()

@end

@implementation TrendsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        refreshHeader = [[RefreshTableHeader alloc] initWithFrame:CGRectMake(0.0f, -242.0f, self.tableView.bounds.size.width, 120.0f)];
		refreshHeader.delegate = self;
        refreshHeader.tag=101;
		[self.tableView addSubview:refreshHeader];
		
		refreshFooter = [[RefreshTableFooter alloc] initWithFrame:CGRectMake(0.0f, -10.0f, self.tableView.bounds.size.width, 40.0f)];
		refreshFooter.delegate = self;
        refreshFooter.tag=102;
		[refreshFooter setHidden:YES]; 
		[self.tableView setTableFooterView:refreshFooter];
        
        [self initHeader];
		self.tableView.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1.0];
		[self.tableView setContentInset:UIEdgeInsetsMake(8, 0, 0, 0)];
		[self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
		
        arrUpload=[[NSMutableArray alloc] initWithCapacity:0];
       self.arrImage=[[NSMutableArray alloc] initWithCapacity:0];
		arrWebMsg=[[NSMutableArray alloc] initWithCapacity:0];
        needRefreshData=YES;
 		pageIndex=1;
    }
    return self;
}

-(void)initHeader{
    headerUpload=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, HEADER_MINHEIGHT)];
    headerUpload.backgroundColor=[UIColor clearColor]; 
    
	tbUpload=[[UITableView alloc] initWithFrame:CGRectMake(0, HEADER_MINHEIGHT, kDeviceWidth, 0) style:UITableViewStylePlain];
	tbUpload.backgroundColor=[UIColor colorWithWhite:0.55 alpha:1.0];
	tbUpload.dataSource=self;
	tbUpload.delegate=self;
	tbUpload.scrollEnabled=NO;
	tbUpload.separatorStyle=UITableViewCellSeparatorStyleNone;
	[headerUpload addSubview:tbUpload];
	
    [self.tableView setTableHeaderView:headerUpload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initObservers];
} 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)initObservers{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCustom:)
                                                 name:NOTIFICATION_TO_TRENDS
                                               object:nil];
}

#pragma mark - TabItem delegate
-(void)refreshData{
    if (needRefreshData) {
        [refreshHeader ManualDragScrollViewToRefresh:self.tableView];
        needRefreshData=NO;
    }
	 
}

-(void)clearData{
	[self.arrImage removeAllObjects];
	[self.tableView reloadData];
	[arrUpload removeAllObjects];
	[tbUpload reloadData];
	[arrWebMsg removeAllObjects];
	needRefreshData=YES;
}

#pragma mark - Upload Delegate
- (void)didUploadPhoto:(NSString*)imgFile {
//    [AppHelper showHUD:@"上传照片" baseview:self.view];
    uploadInfoID++;
	UploadInfo* uinfo=[[UploadInfo alloc] init];
	uinfo.UID=uploadInfoID;
	uinfo.UploadPath=imgFile;
	uinfo.UploadState=UploadImageStateUploading;
	[arrUpload addObject:uinfo];
	
	CGRect newframe=tbUpload.frame;
	newframe.size.height=54*arrUpload.count;
	tbUpload.frame=newframe;
	
	CGRect headerFrame=headerUpload.frame;
    headerFrame.size.height=newframe.size.height+12;
    headerUpload.frame=headerFrame;
    [self.tableView setTableHeaderView:headerUpload];
	
	[tbUpload beginUpdates];
	[tbUpload insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:arrUpload.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
	[tbUpload endUpdates];
	
    int curindex= uploadInfoID;
    NSString *second = [[NSUserDefaults standardUserDefaults] objectForKey:@"second_post"];
    second = [second stringByReplacingOccurrencesOfString:@"s" withString:@""];
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
    [asirequest setPostValue:METHOD_SHAREPHOTO forKey:@"method"];
	NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
    [asirequest setPostValue:userid forKey:@"userid"];
    [asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
    [asirequest setPostValue:  [AppHelper generateGuid] forKey:@"upid"];
    [asirequest setPostValue:@"" forKey:@"degrees"];
    [asirequest setPostValue:@"" forKey:@"content"];
    [asirequest setPostValue:@"1" forKey:@"lockFlag"];
    [asirequest setFile:imgFile forKey:@"upfile"];
    NSLog(@"second====%@",second);
    [asirequest setPostValue:second forKey:@"seconds"];
//	NSData* imageData = UIImageJPEGRepresentation(img, 0.9);
//	[asirequest setData:imageData forKey:@"upfile"];
    UIView* cellContent =  [tbUpload viewWithTag:100+curindex];
    if (cellContent) {
        UIProgressView* pview=(UIProgressView*)[cellContent viewWithTag:11];
        [asirequest setShowAccurateProgress:YES];
        [asirequest setUploadProgressDelegate:pview];
    }
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        NSLog(@"respString====%@",respString);
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"]; 
        if (code==REQUEST_CODE_SUCCESS) {
//            NSArray *subViews = [itemBg subviews];
//            if(subViews.count> 0) {
//                [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//            }
//            [itemBg removeFromSuperview];
			int findIndex=-1;
			NSString *spath=@"";
			for (int k=0; k<arrUpload.count; k++) {
				UploadInfo* item=arrUpload[k];
				if (item.UID==curindex) {
					spath=item.UploadPath;
					findIndex=k;
					break;
				}
			}
			if (spath.length>0) {
				[arrUpload removeObjectAtIndex:findIndex];
				[tbUpload beginUpdates];
				[tbUpload deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:findIndex inSection:0]]
									  withRowAnimation:UITableViewRowAnimationNone];
				[tbUpload endUpdates];
				
				CGRect areaFrame=tbUpload.frame;
				areaFrame.size.height=54*arrUpload.count;
				tbUpload.frame=areaFrame;
				
				CGRect headerFrame=headerUpload.frame;
				headerFrame.size.height= areaFrame.size.height+HEADER_MINHEIGHT;
				headerUpload.frame=headerFrame;
				[self.tableView setTableHeaderView:headerUpload];
				
				if (![[NSFileManager defaultManager] fileExistsAtPath:spath]){
					[[NSFileManager defaultManager] removeItemAtPath:spath error:nil];
				}
			}
			[self loadDataFromWeb];
//			[refreshHeader RefreshScrollViewDidScroll:self.tableView];
//			[refreshHeader ManualDragScrollViewToRefresh:self.tableView];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
//        [AppHelper hideHUD:self.view];
    }];
    [asirequest setFailedBlock:^{
//        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
}

-(void)clickRetryUpload{

}

-(void)clickCancelUpload{

}


#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    DLog(@"");
	if (tbUpload==tableView) {
		return 54.0;
	}
    PrivateImage* info=self.arrImage[indexPath.row];
	return 345.0 + 40*(info.GiftCount>=3?3+1:info.arrGift.count)-20-10;
}
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tbUpload==tableView) {
		return arrUpload.count;
	}
    return self.arrImage.count;
} 
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row=indexPath.row;
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
	if (tbUpload==tableView) {
		UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
		UIImageView* imgThumb=nil;
		UIProgressView* progressView=nil;
		UIButton* btnRetry=nil;
		UIButton* btnCancel=nil;
		if (!cell) {
			cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
			imgThumb=[[UIImageView alloc] initWithFrame:CGRectMake(8,5,44,44)];
			imgThumb.tag=10;
			[cell.contentView addSubview:imgThumb];
			
			progressView=[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
			progressView.frame=CGRectMake(64, 22, kDeviceWidth-80, 24); 
			progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
			progressView.tag=11;
			[progressView setProgressImage:[[UIImage imageNamed:@"upload-track"] stretchableImageWithLeftCapWidth:8 topCapHeight:0]];
			[progressView setTrackImage:[[UIImage imageNamed:@"upload-track-background"] stretchableImageWithLeftCapWidth:8 topCapHeight:0]];
			[cell.contentView addSubview:progressView];
			
			btnRetry=[UIButton buttonWithType:UIButtonTypeCustom];
			btnRetry.frame=CGRectMake(220, 5, 44, 44);
			btnRetry.tag=12;
			[btnRetry setImage:[UIImage imageNamed:@"upload-retry-default"] forState:UIControlStateNormal];
			[btnRetry setImage:[UIImage imageNamed:@"upload-retry-active"] forState:UIControlStateHighlighted];
			btnRetry.hidden=YES;
			[btnCancel addTarget:self action:@selector(clickRetryUpload) forControlEvents:UIControlEventTouchUpInside];
			[cell.contentView addSubview:btnRetry];
			
			btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
			btnCancel.frame=CGRectMake(270, 5, 44, 44);
			btnCancel.tag=13;
			[btnCancel setImage:[UIImage imageNamed:@"upload-cancel-default"] forState:UIControlStateNormal];
			[btnCancel setImage:[UIImage imageNamed:@"upload-cancel-active"] forState:UIControlStateHighlighted];
			btnCancel.hidden=YES;
			[btnCancel addTarget:self action:@selector(clickCancelUpload) forControlEvents:UIControlEventTouchUpInside];
			[cell.contentView addSubview:btnCancel];
		}
		imgThumb=(UIImageView*)[cell.contentView viewWithTag:10];
		progressView=(UIProgressView*)[cell.contentView viewWithTag:11];
		btnRetry=(UIButton*)[cell.contentView viewWithTag:12];
		btnCancel=(UIButton*)[cell.contentView viewWithTag:13];
		UploadInfo* info=(UploadInfo*)arrUpload[row];
		switch (info.UploadState) {
			case UploadImageStateUploadFailed:
				btnCancel.hidden=NO;
				btnRetry.hidden=NO;
				progressView.hidden=YES;
				break;
				
			default:
				btnCancel.hidden=YES;
				btnRetry.hidden=YES;
				progressView.hidden=NO;
				break;
		}
		imgThumb.image=[UIImage imageWithContentsOfFile:info.UploadPath];
		cell.contentView.tag=100+info.UID;
		return cell;
	}
	else{
		TrendsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
		if (!cell) {
			cell=[[TrendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
		}
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		cell.toolbarDelegate=self;
		cell.bubbleDelegate=[HomeViewController shared];
		PrivateImage* info= self.arrImage[row];
		[cell loadData:info];
		cell.tag=TAGOFFSET_BUBBLECELL+info.ImageId;
		cell.row = row;
		return cell;
	}
}
 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Click Image Toolbar delegate
-(void)clickImageToolbar:(PrivateImage*)info itag:(int)itag{
    switch (itag) {
		case IMAGE_TOOLBAR_LIKE:
		{
			info.isLiked=!info.isLiked;
			if (info.isLiked) {
				info.LikeCount++;
			}
			else{
				info.LikeCount--;
			}
			if (info.LikeCount<0) {
				info.LikeCount=0;
			}
			[self refreshCell:info];
			[info likeMe];
		}
			break;
        case IMAGE_TOOLBAR_GIFT:
        {
            GiftViewController* controller=[[GiftViewController alloc] init];
            controller.curInfo=info;
            [[HomeViewController shared] presentViewController:controller animated:YES completion:nil];
        }
            break;
            
        case IMAGE_TOOLBAR_CHAT:
        {
            ChatViewController* controller=[[ChatViewController alloc] init];
            controller.strUserName=info.UserName;
			controller.PeerId=info.UserId;
            [[HomeViewController shared] presentViewController:controller animated:YES completion:nil];
        }
            break;
		case IMAGE_TOOLBAR_SHARE:
		{
            infoPimg = info;
			UIActionSheet *actions=[[UIActionSheet alloc] initWithTitle:nil
															   delegate:self
													  cancelButtonTitle:@"取消"
												 destructiveButtonTitle:nil
													  otherButtonTitles:@"分享到新浪微博",@"分享到微信",@"分享到微信朋友圈",  nil];
			actions.tag=101;
			[actions showInView:[HomeViewController shared].view];
		}
			break;
		case IMAGE_TOOLBAR_MORE:
		{
			UIActionSheet *actions=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"审核举报" otherButtonTitles: nil];
			actions.tag=100;
			[actions showInView:[HomeViewController shared].view];
			reportedImageId=info.ImageId;
		}
			break;
    }
}

#pragma mark - MISC
-(void)tapSection:(UITapGestureRecognizer*)gesture{
	int section=gesture.view.tag-100;
	PrivateImage* info=self.arrImage[section];
	[[HomeViewController shared] gotoUserViewByImageInfo:info];
}

-(void)refreshCell:(PrivateImage*)info{
	TrendsCell *cell=(TrendsCell*)[self.tableView viewWithTag:(TAGOFFSET_BUBBLECELL+info.ImageId)];
	if (cell) {
//		DLog(@" ");
		[cell loadData:info];
	}
}

-(void)changeLblSec:(int)second celltag:(int)celltag{
	TrendsCell *cell=(TrendsCell *)[self.tableView viewWithTag:celltag];
    if (second>0) {
        int  userId =  [AppHelper getIntConfig:confUserId];
        if (cell.curInfo.UserId == userId&&!cell.curInfo.ViewCount) {
            cell.curInfo.ViewCount =1;
        }
        cell.curInfo.Second=second;
    }else if(second < 0){
        if (cell.curInfo.ViewCount ==0) {
            cell.curInfo.ViewCount = 1;
        }
    }
    else{
        cell.curInfo.Second=0;
        cell.curInfo.State=PrivateImageStateViewed;
        [self pushData:cell.curInfo celltag:celltag];
    }
    [cell refreshData];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (actionSheet.tag==100 ) {
        if (buttonIndex == 0) {
            ReportViewController* controller=[[ReportViewController alloc] init];
            controller.curImageId=reportedImageId;
            [[HomeViewController shared] presentViewController:controller animated:YES completion:nil];
        }
		
	}else{
        switch (buttonIndex) {
            case 0:{
                SinaWeibo *sinaWeibo = [[AppDelegate App] sinaweibo];
                
                sinaWeibo.delegate = self;
                NSString *asstoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"sina_access_token"];
                if (asstoken) {
                    // [sinaWeibo logOut];
                    SinaWeibo *sinaweibo = [[AppDelegate App] sinaweibo];
                    sinaweibo.accessToken = asstoken;
                    [self sinaweiboDidLogIn:sinaweibo];
                    
                }
                else {
                    [sinaWeibo logIn];
                }

            }
                break;
            case 1:{
               
                [[AppDelegate App] sendAppImg:WXSceneSession withTitle:infoPimg.UserName  withContent:infoPimg.ThumbUrl withThumbImg:infoPimg.ThumbUrl];
            }
                break;
            case 2:{
                [[AppDelegate App] sendAppImg:WXSceneTimeline withTitle:infoPimg.UserName  withContent:infoPimg.ThumbUrl withThumbImg:infoPimg.ThumbUrl];
                
            }
                break;
                
            default:
                break;
        }
           }
}
- (void)storeSinaAuthData
{
    SinaWeibo *sinaweibo = [[AppDelegate App] sinaweibo];
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"sina_access_token",
                              sinaweibo.expirationDate, @"expires_in",
                              sinaweibo.userID, @"uid",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] setObject:sinaweibo.accessToken forKey:@"sina_access_token"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"third_access_weibo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeSinaAuthData];
     NSString *str = [NSString stringWithFormat:@"%@ 的靓图,%@%@",[infoPimg.UserName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"去”泡泡美女”查看大图和更多！",SHAREAPPURL];
 // NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
    NSLog(@"ImageUrl===%@",infoPimg.ThumbUrl);
    NSData *dataObj = [NSData dataWithContentsOfURL:[NSURL URLWithString:infoPimg.ThumbUrl]];
    NSLog(@"===%@",sinaweibo.userID);
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            sinaweibo.accessToken, @"access_token",str,@"status",dataObj,@"pic",nil];
    
    SinaWeiboRequest* sinaWeiboRequest = [SinaWeiboRequest requestWithURL:@"https://api.weibo.com/2/statuses/upload.json"
                                                               httpMethod:@"POST"
                                                                   params:params
                                                                 delegate:self];
    
    [sinaWeiboRequest  connect];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushSinaWeiboViewController" object:self userInfo:nil];
}
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error{
    NSLog(@"error====%@",error);
}
#pragma mark - SinaWeiboRequestDelegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    NSLog(@"result===%@",result);
    [AppHelper showHUD:@"分享成功" baseview:self.view];
    [self performSelector:@selector(hidenHUD) withObject:self afterDelay:1.5];
    
   // NSLog(@"request====%@",request.params);
}
-(void)hidenHUD{
    [AppHelper hideHUD:self.view];
}
#pragma mark - Load Data
-(void)loadDataFromWeb{
    
    if (loadingData) {
        if (loadingRefreshHeader) {
            loadingRefreshHeader = NO;
            [refreshHeader RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        if (loadingRefreshFooter) {
            loadingRefreshFooter=NO;
            [refreshFooter RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        return;
    } 
    loadingData=YES;

    int pageCount=10;
	NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
	NSDictionary* dict=@{
					  @"method":METHOD_STATUSPHOTO,
					  @"userid":userid,
					  @"token":[AppHelper getStringConfig:confUserToken],
					  @"page":[NSString stringWithFormat:@"%d",pageIndex],
					  @"pageCount":[NSString stringWithFormat:@"%d",pageCount]
	   };
    NSString *prams = @"aa=0";
    for (id keys in dict) {
		prams = [prams stringByAppendingFormat:@"&%@=%@",keys,[dict objectForKey:keys]] ;
    } 
    NSString *urlString = [NSString stringWithFormat:@"%@?%@",UrlBase,prams];
    ASIHTTPRequest* asirequest=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];

    //    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=30;
    //    DLog(@"%@",dictInput);
 
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
            NSLog(@"data====%@",data);
			if (pageIndex<2) {
				[self.arrImage removeAllObjects];
			}
            for (NSDictionary *di in data) {
                PrivateImage* item=[[PrivateImage alloc] initWithDict:di]; 
     			[self.arrImage addObject:item];
				[self addDownloadItem:item];
				 
            }
            [self.tableView reloadData];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
        [refreshFooter setHidden:!(self.arrImage.count>3)];
        if (loadingRefreshHeader) {
            loadingRefreshHeader = NO;
            [refreshHeader RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        if (loadingRefreshFooter) {
            loadingRefreshFooter=NO;
            [refreshFooter RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        loadingData=NO;
        //        [AppHelper hideHUD:self.view];
    }];
    [asirequest setFailedBlock:^{
        //        [AppHelper hideHUD:self.view];
		if (loadingRefreshHeader) {
            loadingRefreshHeader = NO;
            [refreshHeader RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        if (loadingRefreshFooter) {
            loadingRefreshFooter=NO;
            [refreshFooter RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        loadingData=NO;
    }];
    [asirequest startAsynchronous];
 
}

-(void)pushData:(PrivateImage *)info celltag:(int)celltag{
	NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
	NSDictionary* dict=@{
					  @"method":METHOD_STATUSLOOK,
       @"userid":userid,
       @"token":[AppHelper getStringConfig:confUserToken],
       @"sid":[NSString stringWithFormat:@"%d",info.ImageId],
	   };
    NSString *prams = @"aa=0";
    for (id keys in dict) {
		prams = [prams stringByAppendingFormat:@"&%@=%@",keys,[dict objectForKey:keys]] ;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@?%@",UrlBase,prams];
    ASIHTTPRequest* asirequest=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    //    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=30;
    //    DLog(@"%@",dictInput);
    
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            NSLog(@"JSON===%@",JSON);
            id coinData = [[JSON objectForKey:@"data"] objectForKey:@"coinData"];
            int remainCoin=[AppHelper getIntFromDictionary:coinData key:@"remainCoin"];
            int watchTimes = [AppHelper getIntFromDictionary:[JSON objectForKey:@"data"] key:@"watchTimes"];
        
            if (remainCoin) {
                [AppHelper setIntConfig:confUserCoin val:remainCoin];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TO_TRENDS object:nil userInfo:nil];
            }
            if (watchTimes) {
                TrendsCell *cell=(TrendsCell *)[self.tableView viewWithTag:celltag];
                 info.WatchDate = [AppHelper getCurrentDate:@"yyyy-M-d HH:mm"] ;
                info.ViewCount = watchTimes;
                [cell loadData:info];
            }
         
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
               //        [AppHelper hideHUD:self.view];
    }];
    [asirequest setFailedBlock:^{
        //        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
}
- (void)reloadTableViewDataSource{
    if (loadingRefreshHeader) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
        return;
    }
	loadingRefreshHeader = YES;
	pageIndex=1;
    [self loadDataFromWeb];
}

- (void)reloadFooterDataSource{
	loadingRefreshFooter = YES;
	pageIndex++;
    [self loadDataFromWeb];
}

#pragma mark - RefreshTableHeader Delegate
- (void)RefreshTableHeaderDidTriggerRefresh:(RefreshTableHeader*)view{
	
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:30.0];
	
}

- (BOOL)RefreshTableHeaderDataSourceIsLoading:(RefreshTableHeader*)view{
	
	return loadingRefreshHeader; // should return if data source model is reloading
	
}

- (NSDate*)RefreshTableHeaderDataSourceLastUpdated:(RefreshTableHeader*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - RefreshTableFooterDelegate Methods
- (void)RefreshTableFooterDidTriggerRefresh:(RefreshTableFooter*)view{
	if (view == refreshFooter) {
        [self reloadFooterDataSource];
    }
}

- (BOOL)RefreshTableFooterDataSourceIsLoading:(RefreshTableFooter*)view{
    return loadingRefreshFooter;
}

- (NSDate*)RefreshTableFooterDataSourceLastUpdated:(RefreshTableFooter*)view{
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (scrollView==self.tableView) {
        [refreshHeader RefreshScrollViewDidScroll:self.tableView];
        [refreshFooter RefreshScrollViewDidScroll:self.tableView];
    }
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
 	if (scrollView==self.tableView) {
        [refreshHeader RefreshScrollViewDidEndDragging:self.tableView];
        [refreshFooter RefreshScrollViewDidEndDragging:self.tableView];
	}
}

#pragma mark - Download Images Queue
-(void)addDownloadItem:(PrivateImage*)msg{
    NSString* strUrl=msg.ImageUrl;
    NSLog(@"strUrl===%@",strUrl);
    BOOL isExit=NO;
    for (int k=0; k<arrWebMsg.count; k++) {
        PrivateImage* item=(PrivateImage*)arrWebMsg[k];
        if ([strUrl isEqualToString:item.ImageUrl]) {
            isExit=YES;
            break;
        }
    }
    if (!isExit) {
        [arrWebMsg insertObject:msg atIndex:0];
    }
    if (!isWebMsgRunning && arrWebMsg.count>0) {
        isWebMsgRunning=YES;
        [self startWebMsgQueue];
    }
}

-(void)startWebMsgQueue{
    if (arrWebMsg.count==0) {
        isWebMsgRunning=NO;
        return;
    }
    PrivateImage* msg=[arrWebMsg lastObject];
    SDWebImageManager *sdmanager = [SDWebImageManager sharedManager];
	  
    [sdmanager downloadWithURL:[NSURL URLWithString:msg.ImageUrl]
                      delegate:self
                       options:SDWebImageRetryFailed
                       success:^(UIImage *image) {
                           msg.State=PrivateImageStateDownloaded;
                           [self refreshCell:msg];
                           [arrWebMsg removeObject:msg];
                           if (arrWebMsg.count>0) {
                               [self startWebMsgQueue];
                           }
                           else{
                               isWebMsgRunning=NO;
                           }
                       }
                       failure:^(NSError *error) {
                           msg.State=PrivateImageStateDownloadFailed;
                           [self refreshCell:msg];
                           [arrWebMsg removeObject:msg];
                           if (arrWebMsg.count>0) {
                               [self startWebMsgQueue];
                           }
                           else{
                               isWebMsgRunning=NO;
                           }
                       }];
}
#pragma mark -WEB Share

#pragma mark - Notification Event
-(void)notificationCustom:(NSNotification*)notification{
    int noticeID=[[notification.userInfo objectForKey:NOTIFICATION_KEYNAME] intValue];
    switch (noticeID) {
        case NOTIFICATION_ID_SENTGIFT:
        {
            [self.tableView reloadData];
        }
            break;
		default:
			break;
	}
}
@end
