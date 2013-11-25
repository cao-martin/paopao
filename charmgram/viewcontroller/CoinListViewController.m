//
//  CoinListViewController.m
//  charmgram
//
//  Created by 曹鹏鹏 on 13-11-3.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "CoinListViewController.h"
#import "UIButton+WebCache.h"
@interface CoinListViewController ()

@end

@implementation CoinListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    pageIndex = 1;
    self.view.backgroundColor=COLOR_BACKGROUND;
	UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopbarHeight)];
    topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    
    UILabel * lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 24)];
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.text=@"交易记录";
    lblTitle.font=[UIFont boldSystemFontOfSize:20.0];
    [topbar addSubview:lblTitle];
    
    UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"navi_back_btn"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"navi_back_btn_h"] forState:UIControlStateHighlighted];
    btnCancel.frame=CGRectMake(8, 6, 52,32);
    btnCancel.titleLabel.font=[UIFont boldSystemFontOfSize:12.0];
    // [btnCancel setTitle:@"  返回" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnCancel];
    [self.view addSubview:topbar];
    arrPointLogs = [[NSMutableArray alloc] init];
	
	tabeCoin = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, kDeviceHeight-49)];
	tabeCoin.dataSource = self;
	tabeCoin.delegate = self;
	tabeCoin.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:tabeCoin];
	
	
    refreshHeader = [[RefreshTableHeader alloc] initWithFrame:CGRectMake(0.0f, -242.0f, tabeCoin.bounds.size.width, 120.0f)];
    refreshHeader.delegate = self;
    refreshHeader.tag=102;
    [tabeCoin addSubview:refreshHeader];
    
    refreshFooter = [[RefreshTableFooter alloc] initWithFrame:CGRectMake(0.0f, -10.0f, tabeCoin.bounds.size.width, 40.0f)];
    refreshFooter.delegate = self;
    [refreshFooter setHidden:YES];
    refreshFooter.tag=102;
    [tabeCoin setTableFooterView:refreshFooter];
    needRefreshData=YES;

    [super viewDidLoad];
    [self getData];
	// Do any additional setup after loading the view.
}
-(void)getData{
    [AppHelper showHUD:@"获取交易记录列表..." baseview:self.view];
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
	[asirequest setPostValue:@"getcoinDaily" forKey:@"method"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
    [asirequest setPostValue:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"page"];
    [asirequest setPostValue:[NSString stringWithFormat:@"%d",10] forKey:@"pagecount"];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            //
            NSLog(@"JSON===%@",JSON);
            if ([[JSON objectForKey:@"data"] count] > 0) {
                [arrPointLogs removeAllObjects];
                [arrPointLogs addObjectsFromArray:[JSON objectForKey:@"data"]];
                
                //NSLog(@"arrPointLogs=====%@",arrPointLogs);
                [tabeCoin reloadData];
            }
            else {
                //空
                UILabel *lblNO = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 44)];
                lblNO.numberOfLines = 0;
                lblNO.lineBreakMode = UILineBreakModeWordWrap;
                lblNO.font = [UIFont systemFontOfSize:13.0];
                lblNO.text = @"    暂时还没有靓点交易记录";
                lblNO.textColor = [UIColor blackColor];
                lblNO.backgroundColor = [UIColor clearColor];
                lblNO.textAlignment = UITextAlignmentLeft;
                
                tabeCoin.tableHeaderView = lblNO;
                
            }
            if (loadingLobbyHeader) {
                loadingLobbyHeader = NO;
                [refreshHeader RefreshScrollViewDataSourceDidFinishedLoading:tabeCoin];
            }
            if (loadingLobbyFooter) {
                loadingLobbyFooter=NO;
                [refreshFooter RefreshScrollViewDataSourceDidFinishedLoading:tabeCoin];
            }


        }
        else{
            [AppHelper showAlertMessage:msg];
        }
		[AppHelper hideHUD:self.view];
    }];
    [asirequest setFailedBlock:^{
		[AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];

}
#pragma mark UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	return [arrPointLogs count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	//区分
	NSString *charge_in_coin = [NSString stringWithFormat:@"%@",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"charge_in_coin"]];
    NSString *gift_in = [NSString stringWithFormat:@"%@",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"gift_in"]];
    NSString *gift_out = [NSString stringWithFormat:@"%@",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"gift_out"]];
    NSString *picwatch_in = [NSString stringWithFormat:@"%@",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"picwatch_in"]];
    NSString *picwatch_out = [NSString stringWithFormat:@"%@",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"picwatch_out"]];
    int count =40;
	if ([charge_in_coin intValue]) {
		//
        count =count +30;
	}
	if ([gift_in intValue]) {
		//
        count =count +30;
	}
    if ([gift_out intValue]) {
		//
        count =count +30;
	}
    if ([picwatch_in intValue]) {
		//
        count =count +30;
	}
    if ([picwatch_out intValue]) {
		//
        count =count +30;
	}
    return count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
	if (cell == nil) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		//区分

		NSString *charge_in_coin = [NSString stringWithFormat:@"%@",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"charge_in_coin"]];
        NSString *gift_in = [NSString stringWithFormat:@"%@",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"gift_in"]];
        NSString *gift_out = [NSString stringWithFormat:@"%@",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"gift_out"]];
        NSString *picwatch_in = [NSString stringWithFormat:@"%@",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"picwatch_in"]];
        NSString *picwatch_out = [NSString stringWithFormat:@"%@",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"picwatch_out"]];
		//状态
		
		
		
        int fy = 5;
		 
		if ([charge_in_coin intValue]) {
			//充值的
            UILabel *lblState = [[UILabel alloc] initWithFrame:CGRectMake(10, fy, 300, 30)];
            lblState.backgroundColor = [UIColor clearColor];
            lblState.textColor = [UIColor blackColor];
             lblState.font = [UIFont boldSystemFontOfSize:16];
            //lblState.text = [NSString stringWithFormat:@"充值获得了%@靓点",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"coin"]];
            [cell addSubview:lblState];
			
			lblState.text = [NSString stringWithFormat:@"充值获得了%@靓点",charge_in_coin];
            fy = fy+30;
		}
        if ([gift_in intValue]) {
            
            UILabel *lblState = [[UILabel alloc] initWithFrame:CGRectMake(10, fy, 300, 30)];
            lblState.backgroundColor = [UIColor clearColor];
            lblState.textColor = [UIColor blackColor];
             lblState.font = [UIFont boldSystemFontOfSize:16];
            //lblState.text = [NSString stringWithFormat:@"充值获得了%@靓点",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"coin"]];
            [cell addSubview:lblState];
            
//             NSArray *arr = [[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"giftin"] ;
//            if ([arr count] >0) {
                //通过获得礼物获得靓点
                lblState.text = [NSString stringWithFormat:@"收到%@个礼物获得了%@靓点",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"gift_in"],[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"gift_in_coin"]];

            //}
			fy  = fy+30;
			
		}
		 if ([picwatch_in intValue]) {
             UILabel *lblState = [[UILabel alloc] initWithFrame:CGRectMake(10, fy, 300, 30)];
             lblState.backgroundColor = [UIColor clearColor];
              lblState.font = [UIFont boldSystemFontOfSize:16];
             lblState.textColor = [UIColor blackColor];
             //lblState.text = [NSString stringWithFormat:@"充值获得了%@靓点",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"coin"]];
             [cell addSubview:lblState];
			//通过被解锁照片获得靓点
			lblState.text = [NSString stringWithFormat:@"%@人次观看了您的照片,获得有效靓点:%@",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"picwatch_in"],[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"picwatch_in_coin"]];
             fy = fy +30;
			//照片
//			UIButton *imgPhoto = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, 75, 75)];
//			imgPhoto.tag = indexPath.row + 100000;
//			NSString *strPhotoPath = [[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"imagepath"];
//			if (strPhotoPath && ![strPhotoPath isEqualToString:@""]) {
//				[imgPhoto setImageWithURL:[NSURL URLWithString:strPhotoPath]];
//			}
//			[imgPhoto addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
//			[cell addSubview:imgPhoto];
			
		}
		 if ([gift_out intValue]) {
             UILabel *lblState = [[UILabel alloc] initWithFrame:CGRectMake(10, fy, 300, 30)];
             lblState.backgroundColor = [UIColor clearColor];
             lblState.textColor = [UIColor blackColor];
               lblState.font = [UIFont boldSystemFontOfSize:16];
             //lblState.text = [NSString stringWithFormat:@"充值获得了%@靓点",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"coin"]];
             [cell addSubview:lblState];
              lblState.text = [NSString stringWithFormat:@"赠送%@个礼物消耗了%@靓点",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"gift_out"],[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"gift_out_coin"]];
             fy = fy+30;
			//通过赠送礼物消耗靓点
//            NSArray *arr = [[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"giftout"] ;
//            if ([arr count] >0) {
//                lblState.text = [NSString stringWithFormat:@"赠送%@礼物消耗了%@靓点",[[arr objectAtIndex:0] objectForKey:@"username"],[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"gift_out_coin"]];
//                //礼物图片
//                UIButton *imgGift = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, 75, 75)];
//                imgGift.userInteractionEnabled = NO;
//                NSString *strGiftPath = [[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"photo"];
//                if (strGiftPath && ![strGiftPath isEqualToString:@""]) {
//                    [imgGift setImageWithURL:[NSURL URLWithString:strGiftPath]];
//                }
//                [cell addSubview:imgGift];
//            }
			
			
		}
		 if ([picwatch_out intValue]) {
             UILabel *lblState = [[UILabel alloc] initWithFrame:CGRectMake(10, fy, 300, 30)];
             lblState.backgroundColor = [UIColor clearColor];
             lblState.textColor = [UIColor blackColor];
               lblState.font = [UIFont boldSystemFontOfSize:16];
             //lblState.text = [NSString stringWithFormat:@"充值获得了%@靓点",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"coin"]];
             [cell addSubview:lblState];
			//通过解锁照片消耗靓点
			lblState.text = [NSString stringWithFormat:@"观看%@张照片了消耗%@靓点",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"picwatch_out"],[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"picwatch_out_coin"]];
             fy = fy +30;
//			//照片
//			UIButton *imgPhoto = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, 75, 75)];
//			imgPhoto.tag = indexPath.row + 100000;
//			NSString *strPhotoPath = [[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"imagepath"];
//			if (strPhotoPath && ![strPhotoPath isEqualToString:@""]) {
//				[imgPhoto setImageWithURL:[NSURL URLWithString:strPhotoPath]];
//			}
//			[imgPhoto addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
//			[cell addSubview:imgPhoto];
			
		}
        //时间
		UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(10, fy , 300, 20)];
        lblTime.textAlignment  = NSTextAlignmentRight;
		lblTime.backgroundColor = [UIColor clearColor];
		lblTime.textColor = [UIColor grayColor];
		lblTime.font = [UIFont systemFontOfSize:14.0];
		lblTime.text = [NSString stringWithFormat:@"%@",[[arrPointLogs objectAtIndex:indexPath.row] objectForKey:@"addtime"]];
		[cell addSubview:lblTime];
		
		//分隔线
		UILabel *lblSap = [[UILabel alloc] initWithFrame:CGRectMake(0, fy +20, 320, 5)];
		lblSap.backgroundColor = [UIColor clearColor];
		lblSap.text = @".................................................................................................................................................";
		lblSap.font = [UIFont systemFontOfSize:9.0];
		lblSap.textColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0];
		lblSap.textAlignment = UITextAlignmentCenter;
		[cell addSubview:lblSap];


}
	
	return cell;
}	


- (void)reloadHeaderDataSource{
    if (loadingLobbyHeader) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
        return;
    }
	loadingLobbyHeader = YES;
	pageIndex=1;
    [self getData];
//    if (self.PlazaType==PLAZA_FAXIAN) {
//        [self loadFaxianWebData ];
//    }
//    else{
//        [self loadFujinWebData];
//    }
//}
}
- (void)reloadFooterDataSource{
	loadingLobbyFooter = YES;
	pageIndex++;
    [self getData];
//    if (self.PlazaType==PLAZA_FAXIAN) {
//        [self loadFaxianWebData ];
//    }
//    else{
//        [self loadFujinWebData];
//    }
}

#pragma mark - RefreshTableHeader Delegate
- (void)RefreshTableHeaderDidTriggerRefresh:(RefreshTableHeader*)view{
	
	[self reloadHeaderDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:30.0];
	
}

- (BOOL)RefreshTableHeaderDataSourceIsLoading:(RefreshTableHeader*)view{
	
	return loadingLobbyHeader; // should return if data source model is reloading
	
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
    return loadingLobbyFooter;
}

- (NSDate*)RefreshTableFooterDataSourceLastUpdated:(RefreshTableFooter*)view{
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (scrollView==tabeCoin) {
        [refreshHeader RefreshScrollViewDidScroll:tabeCoin];
        [refreshFooter RefreshScrollViewDidScroll:tabeCoin];
    }
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
 	if (scrollView==tabeCoin) {
        [refreshHeader RefreshScrollViewDidEndDragging:tabeCoin];
        [refreshFooter RefreshScrollViewDidEndDragging:tabeCoin];
	}
}
-(void)clickBack{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
