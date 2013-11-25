//
//  NewSViewController.m
//  charmgram
//
//  Created by martin on 13-7-31.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "NewSViewController.h"
#import "NewSegmengtControl.h"
#import "ConcernMessageView.h"
#import "WhoConcernMeView.h"
#import "ChatViewController.h"
#import "MLPAccessoryBadge.h"
#import "Constants.h"
#import "ShiXinCell.h"
@interface NewSViewController ()
{
    ConcernMessageView *concerMessageView;
	WhoConcernMeView *whoConcernMeView;
	MLPAccessoryBadge *accessoryBadge;
    MLPAccessoryBadge *accessoryMsgBadge;
    UILabel *noNews;
}
@end

@implementation NewSViewController

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
    [super viewDidLoad];
	self.view.backgroundColor=[UIColor colorWithRed:(43/255.0f) green:(45/255.0f) blue:(52/255.0f) alpha:1.0f];
    //    imgBg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rearview_bg"]];
    //    imgBg.frame=CGRectMake(kDeviceWidth-kFriendPanelWidth, 0, kFriendPanelWidth+1, kDeviceHeight);
    //    imgBg.contentMode=UIViewContentModeScaleAspectFill;
    //    imgBg.userInteractionEnabled=YES;
    //    [self.view addSubview:imgBg];
    [self initSearchBar];
    [self initSegment];
    
    //    int left=kDeviceWidth-kFriendPanelWidth;


    tbNews=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, kDeviceHeight-110) style:UITableViewStylePlain];
    tbNews.dataSource=self;
    tbNews.delegate=self;
    tbNews.backgroundColor=[UIColor clearColor];
    tbNews.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tbNews];
    
    tbShixin=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, kDeviceHeight-110) style:UITableViewStylePlain];
    tbShixin.dataSource=self;
    tbShixin.delegate=self;
    tbShixin.backgroundColor=[UIColor clearColor];
    tbShixin.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tbShixin];
    tbShixin.hidden=YES;
    
    UIImageView *topSplit=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, 3)];
    topSplit.image=[UIImage imageNamed:@"view_shadow_poi_top"];
    [self.view addSubview:topSplit];
    [self initObservers];
    
    noNews = [[UILabel alloc] initWithFrame:CGRectMake(0, kDeviceHeight/2, 320, 30)];
    noNews.hidden = YES;
    noNews.backgroundColor = [UIColor clearColor];
    noNews.textColor = [UIColor lightGrayColor];
    noNews.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noNews];

}
-(void)initObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCustom:)
                                                 name:NOTIFICATION_TO_TRENDS
                                               object:nil];
}

-(void)notificationCustom:(NSNotification*)notification{
    if ([AppHelper getIntConfig:confMsgCount]) {
        accessoryMsgBadge.hidden = NO;
    }else
        accessoryMsgBadge.hidden = YES;
    NSNumber *numbMsg = [NSNumber numberWithInt:[AppHelper getIntConfig:confMsgCount] ];
    [accessoryMsgBadge setTextWithNumber:numbMsg];
    accessoryMsgBadge.center = CGPointMake(100, 15);
    if ([AppHelper getIntConfig:confNotCount]) {
        accessoryBadge.hidden = NO;
    }else
        accessoryBadge.hidden = YES;
    NSNumber *numb = [NSNumber numberWithInt:[AppHelper getIntConfig:confNotCount] ];
    [accessoryBadge setTextWithNumber:numb];
   accessoryBadge.center = CGPointMake(100, 15);
}
-(void)initSearchBar{
//	UIView* searchBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
//	searchBar.backgroundColor=[UIColor clearColor];
//	
//	UIImageView* imgSearchBg=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"search_bg_rear"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0 ]];
//	imgSearchBg.frame=CGRectMake(10, 1, kDeviceWidth-20, 42);
//	imgSearchBg.userInteractionEnabled = YES;
//	UIImageView* imgSearchIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon_rear"]];
//	imgSearchIcon.frame=CGRectMake(8, 13, 17, 17);
//	
//    UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_off"] forState:UIControlStateNormal];
//    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_on"] forState:UIControlStateHighlighted];
//    btnCancel.frame=CGRectMake(8, 0, 54,44);
//    [btnCancel addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
//    [imgSearchBg addSubview:btnCancel];
//	
//	[imgSearchBg addSubview:imgSearchIcon];
//	[searchBar addSubview:imgSearchBg];
//	[self.view addSubview:searchBar];
    arrNews=[[NSMutableArray alloc] initWithCapacity:0];
    arrShixin=[[NSMutableArray alloc] initWithCapacity:0];
}

-(void)initSegment{
    UIImageView* imgSegBg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segmental_rear_bg"]];
    imgSegBg.frame=CGRectMake((kDeviceWidth-235)/2, 9, 235, 33);
    imgSegBg.userInteractionEnabled=YES;
    UITapGestureRecognizer* tapSeg=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSegment)];
    tapSeg.numberOfTouchesRequired=1;
    tapSeg.numberOfTapsRequired=1;
    [imgSegBg addGestureRecognizer:tapSeg];
    
    UIView* imgSegSp=[[UIView alloc] initWithFrame:CGRectMake(117, 1, 1, 31)];
    imgSegSp.backgroundColor=[UIColor colorWithRed:18/255.0 green:20/255.0 blue:27/255.0 alpha:1.0];
    
    lblNews=[[UILabel alloc] initWithFrame:CGRectMake(1, 1, 116, 31)];
    lblNews.textColor=[UIColor whiteColor];
    lblNews.backgroundColor=[UIColor clearColor];
    lblNews.font=[UIFont boldSystemFontOfSize:16.0];
    lblNews.textAlignment=UITextAlignmentCenter;
    lblNews.text=@"消息";
    
    lblShixin=[[UILabel alloc] initWithFrame:CGRectMake(118, 1, 116, 31)];
    lblShixin.textColor=[UIColor whiteColor];
    lblShixin.backgroundColor=[UIColor clearColor];
    lblShixin.font=[UIFont boldSystemFontOfSize:16.0];
    lblShixin.textAlignment=UITextAlignmentCenter;
    lblShixin.text=@"私信";
    
    //    UIView* imgHL=[[UIView alloc] initWithFrame:CGRectMake(1, 1, 116, 31)];
    //    imgHL.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"segmental_rear_btn_h"]];
    
    btnSeg=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSeg setBackgroundImage:[UIImage imageNamed:@"segmental_rear_btn_h"] forState:UIControlStateNormal];
    btnSeg.frame=CGRectMake(1, 1, 116, 31);
    [btnSeg addTarget:self action:@selector(clickSegment) forControlEvents:UIControlEventTouchUpInside];
    
    
    accessoryBadge = [MLPAccessoryBadge new];
    if ([AppHelper getIntConfig:confNotCount]) {
        accessoryBadge.hidden = NO;
    }else
        accessoryBadge.hidden = YES;
    NSNumber *numb = [NSNumber numberWithInt:[AppHelper getIntConfig:confNotCount] ];
    [accessoryBadge setCornerRadius:100];
    [accessoryBadge setTextWithNumber:numb];
    [accessoryBadge setBackgroundColor:[UIColor redColor]];
    [lblNews addSubview:accessoryBadge];
    accessoryBadge.center = CGPointMake(100, 15);
    
    accessoryMsgBadge = [MLPAccessoryBadge new];
    if ([AppHelper getIntConfig:confMsgCount]) {
        accessoryMsgBadge.hidden = NO;
    }else
        accessoryMsgBadge.hidden = YES;
    NSNumber *numbMsg = [NSNumber numberWithInt:[AppHelper getIntConfig:confMsgCount] ];
    [accessoryMsgBadge setCornerRadius:100];
    [accessoryMsgBadge setTextWithNumber:numbMsg];
    [accessoryMsgBadge setBackgroundColor:[UIColor redColor]];
    [lblShixin addSubview:accessoryMsgBadge];
    accessoryMsgBadge.center = CGPointMake(100, 15);
    
    [self.view addSubview:imgSegBg];
    [imgSegBg addSubview:lblNews];
    [imgSegBg addSubview:lblShixin];
    [imgSegBg addSubview:btnSeg];
    [imgSegBg addSubview:imgSegSp];
    
    /**
     for (int k=0; k<40; k++) {
     UserInfo *item=[[UserInfo alloc] init];
     item.UserId=1000+k;
     item.UserName=[NSString stringWithFormat:@"用户名%d",item.UserId];
     item.AvatarURL=[NSString stringWithFormat:@"avatar%d.jpg",item.UserId%12];
     [arrUser addObject:item];
     }
	 */
}

-(void)viewDidAppear:(BOOL)animated{
    
	DLog(@"");
	[super viewDidAppear:animated];
   // [self refreshData];
}

-(void)refreshData{
	if ([AppHelper isValidatedUser]) {
        if (selectedIndex==0) {
            [self loadFollowFromWeb];
        }
		else{
            [self loadFanFromWeb];
        }
	}
}

-(void)clearData{
    [arrShixin removeAllObjects];
    [tbShixin reloadData];
    [arrNews removeAllObjects];
    [tbNews reloadData];
    lblShixin.text=@"私信";
    lblNews.text=@"消息";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Click Events
-(void)hideKeyWin
{
	[AppHelper hideKeyWindow];
}


-(void)clickBack{
    [AppHelper hideKeyWindow];
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)clickSegment{
    [self hideKeyWin];
    CGFloat duration=0.10;
    if (selectedIndex==0) {
        [UIView animateWithDuration:duration animations:^{
            btnSeg.frame=CGRectMake(118, 1, 116, 31);
        }];
        selectedIndex=1;
        tbNews.hidden=YES;
        tbShixin.hidden=NO;
       // if (arrShixin.count==0) {
            [self loadFanFromWeb];
       // }
    }
    else{
        [UIView animateWithDuration:duration animations:^{
            btnSeg.frame=CGRectMake(1, 1, 116, 31);
        }];
        selectedIndex=0;
        tbNews.hidden=NO;
        tbShixin.hidden=YES;
       // if (arrNews.count==0) {
            [self loadFollowFromWeb];
       // }
    }
}

#pragma mark - TableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tbShixin==tableView) {
        return arrShixin.count;
    }
    return arrNews.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID=@"mycell";
    static NSString* cellID2=@"mycell2";
    if (tbShixin==tableView) {
        ShiXinCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID2];
        if (!cell) {
            cell=[[ShiXinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
        }
        int row=indexPath.row;
        UserInfo* item=[arrShixin objectAtIndex:row];
        item.UserName = [NSString stringWithFormat:@"%@ 给你发了私信",item.UserName];
        [cell loadData:item];
        return cell;
    }
    else{
        NewsCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell=[[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        int row=indexPath.row;
        NewsInfo* item=[arrNews objectAtIndex:row];
        [cell loadData:item];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	int row=indexPath.row;
    if (tableView==tbShixin) {
        UserInfo* item=[arrShixin objectAtIndex:row];
        ChatViewController* controller=[[ChatViewController alloc] init];
        controller.strUserName=item.UserName;
        controller.PeerId=item.UserId;
        [[HomeViewController shared] presentViewController:controller animated:YES completion:nil];
       
      //  [[HomeViewController shared] gotoUserView:item];
    }
    else{
        
         }
}

#pragma mark - Load Data
-(void)loadFollowFromWeb{
    [AppHelper showHUD:@"获取数据..." baseview:self.view];
	NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	[asirequest setPostValue:METHOD_MYPUSH forKey:@"method"];
	[asirequest setPostValue:userid forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:@"1" forKey:@"page"];
	[asirequest setPostValue:@"10" forKey:@"pageCount"];
    [asirequest setCompletionBlock:^{
        [AppHelper hideHUD:self.view];
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
			NSLog(@"data====%@",data);
            [arrNews removeAllObjects];
            
            for (NSDictionary *di in data) {
				NewsInfo* item=[[NewsInfo alloc] initWithDict:di];
                [arrNews addObject:item];
            }
            if ([arrNews count] == 0) {
                noNews.text = @"没有消息";
                noNews.hidden = NO;
            }else{
                noNews.hidden = YES;
            }

            [tbNews reloadData];
			lblNews.text=[NSString stringWithFormat:@"消息"];
            [self clearPush];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
    }];
    [asirequest setFailedBlock:^{
            [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
	
}
-(void)clearPush{
	NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	[asirequest setPostValue:METHOD_CLEARPUSH forKey:@"method"];
	[asirequest setPostValue:userid forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];

    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
			NSLog(@"data====%@",data);
            [AppHelper setIntConfig:confNotCount val:0];
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TO_TRENDS object:nil userInfo:nil];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
    }];
    [asirequest setFailedBlock:^{
    }];
    [asirequest startAsynchronous];
}
-(void)loadFanFromWeb{
     [AppHelper showHUD:@"获取数据..." baseview:self.view];
    NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	[asirequest setPostValue:METHOD_GETUNREADUSER forKey:@"method"];
	[asirequest setPostValue:userid forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	NSLog(@"userid===%@",userid);
    [asirequest setCompletionBlock:^{
         [AppHelper hideHUD:self.view];
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        NSLog(@"%@",JSON);
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
			
            NSLog(@"data===%@",data);
            [arrShixin removeAllObjects];
            
            for (NSDictionary *di in data) {
				UserInfo* item=[[UserInfo alloc] initWithDict:di];
                [arrShixin addObject:item];
            }
            if ([arrShixin count] == 0) {
                noNews.text = @"没有私信";
                noNews.hidden = NO;
            }else{
                noNews.hidden = YES;
            }
            [tbShixin reloadData];
            lblShixin.text=[NSString stringWithFormat:@"私信"];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
    }];
    [asirequest setFailedBlock:^{
            [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];

	
}

@end
