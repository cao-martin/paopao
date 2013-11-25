//
//  UserViewController.m
//  charmgram
//
//  Created by Rui Wei on 13-4-16.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "UserViewController.h"
#import "BubbleCell.h"
#import "UIImageView+WebCache.h"
#import "ChatViewController.h"
#import "UserListViewController.h"
#import "GiftViewController.h"
#import "ReportViewController.h"
#define CARTBAR_HEIGHT      65
@interface UserViewController ()
@end

@implementation UserViewController
@synthesize timerCountDown,curUserInfo,btnPao;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=COLOR_BACKGROUND;
	UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopbarHeight)];
    topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    
    lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 24)];
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.textColor=[UIColor whiteColor];
	//    lblTitle.text=@"账号登录";
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
	
    UIButton *btnDone=[UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.hidden = (self.curUserInfo.UserId == [AppHelper getIntConfig:confUserId])?YES:NO;
    [btnDone setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_off"] forState:UIControlStateNormal];
    [btnDone setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_on"] forState:UIControlStateHighlighted];
    [btnDone setTitle:@"更多" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.titleLabel.font=[UIFont boldSystemFontOfSize:12.0];
    btnDone.frame=CGRectMake(kDeviceWidth-64, 0, 52,44);
    [btnDone addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnDone];
	
	tbContent=[[UITableView alloc] initWithFrame:CGRectMake(0, (self.PlazaType == PLAZA_FAXIAN)?10:44, kDeviceWidth, kDeviceHeight-112) style:UITableViewStylePlain];
	tbContent.dataSource=self;
	tbContent.delegate=self;
	tbContent.backgroundColor=[UIColor colorWithRed:234/255.0 green:230/255.0 blue:231/255.0 alpha:1.0];
    tbContent.separatorStyle=UITableViewCellSeparatorStyleNone;
	tbContent.showsVerticalScrollIndicator=YES;
	tbContent.frame=CGRectMake(0, (self.PlazaType == PLAZA_FAXIAN)?10:44, kDeviceWidth,kDeviceHeight-72) ;
	
    UIView* footer=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 15)];
    footer.backgroundColor=[UIColor clearColor];
    [tbContent setTableFooterView:footer]; 
	arrTimer = [[NSMutableArray alloc] initWithCapacity:0];
	arrData=[[NSMutableArray alloc] initWithCapacity:0];
	arrWebMsg=[[NSMutableArray alloc] initWithCapacity:0];
	[self.view addSubview:tbContent];
	//[self initCartBar];
    if (self.PlazaType != PLAZA_FAXIAN){
        [self.view addSubview:topbar];
        [self initHeader];
    }
    if (self.PlazaType == PLAZA_FAXIAN){
        [self initBotBar];
        [self loadDefaultData];
        [self initObservers];
    }
   
	
    [self initPreview];   
}
-(void)initObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCustom:)
                                                 name:NOTIFICATION_TO_TRENDS
                                               object:nil];
}
-(void)notificationCustom:(NSNotification*)notification{

    [tbContent reloadData];
}
-(void)loadDefaultData{
    arrData=[[NSMutableArray alloc] initWithCapacity:0];
    int userid = [AppHelper getIntConfig:confUserId];
    if (userid) {
        NSString *strKey = [NSString stringWithFormat:@"paopaoData%d",userid];
        arrPaoPao = [[NSMutableArray alloc] initWithArray:[AppHelper getArrayConfig:strKey]];
        NSLog(@"%@",arrPaoPao);
        for (NSDictionary *di in arrPaoPao) {
            //				if (fanCount==0) {
            //					fanCount=[AppHelper getIntFromDictionary:di key:@"fancount"];
            //
            //				}
            //				if (followCount==0) {
            //					followCount=[AppHelper getIntFromDictionary:di key:@"carecount"];
            //				}
            //                isFollowed=([AppHelper getIntFromDictionary:di key:@"iscare"]==1);
            PrivateImage* item=[[PrivateImage alloc] initWithDict:di];
            item.State = PrivateImageStateDownloaded;
            [self addDownloadItem:item];
            [arrData addObject:item];
        }
        [self hidenLogo];
        NSLog(@"[arrData count]===%d",[arrData count]);
        [tbContent reloadData];
        
    }
    
}
-(void)initPreview{
	bgPreview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-20)];
    bgPreview.backgroundColor=[UIColor colorWithWhite:0 alpha:1.0];
    [bgPreview setHidden:YES];
	
	imgPreview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-20)];
    [imgPreview setContentMode:UIViewContentModeScaleAspectFit];
	[bgPreview addSubview:imgPreview];
	
	btnTimer=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnTimer setFrame:CGRectMake(kDeviceWidth-45, 36, 33, 30)];
    [btnTimer setBackgroundImage:[UIImage imageNamed:@"countdown_mask"] forState:UIControlStateNormal];
    [btnTimer setBackgroundImage:[UIImage imageNamed:@"countdown_mask"] forState:UIControlStateHighlighted];
    [btnTimer setTitle:@"10秒" forState:UIControlStateNormal];
    btnTimer.titleLabel.textColor=[UIColor whiteColor];
    btnTimer.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    [bgPreview addSubview:btnTimer];
	//btnTimer.hidden = YES;
	[[HomeViewController shared].view addSubview:bgPreview];
}

-(void)hidenLogo{
    if (!imageNo) {
        imageNo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nopaopao"]];
        imageNo.hidden = YES;
        imageNo.center = CGPointMake(160, kDeviceHeight/2);
        [self.view addSubview:imageNo];
    }
    if(arrData.count==0){
        imageNo.hidden = NO;
    }else{
        imageNo.hidden = YES;
    }
    [self.view bringSubviewToFront:btnPao];
}
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    lblTitle.text=self.curUserInfo.UserName;
    lblName.text=self.curUserInfo.UserName;
    
	if (self.curUserInfo.UserId==[AppHelper getIntConfig:confUserId]) {
         lblProfile.text =  [AppHelper getStringConfig:confUserInfo ];
		btnMsg.hidden=YES;
		imgVSep.hidden=YES;
		[btnFollow setImage:[UIImage imageNamed:@"profile_setting_btn"] forState:UIControlStateNormal];
		[btnFollow setImage:[UIImage imageNamed:@"profile_setting_btn"] forState:UIControlStateHighlighted];
		btnFollow.tag=101;
	}
	[imgAvatar setImageWithURL:[NSURL URLWithString:self.curUserInfo.AvatarURL]];
	if (arrData.count==0&&self.PlazaType != PLAZA_FAXIAN) {
        [self loadUserInfo];
	}else if(arrData.count==0){
       
        [self hidenLogo];
    }
}

-(void)initBotBar{
//	paoBar=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paopao_bar"]];
//	paoBar.frame=CGRectMake(0, kDeviceHeight-72-60, kDeviceWidth, 53);
//	paoBar.userInteractionEnabled=YES;
//	[self.view addSubview:paoBar];
	
	btnPao=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnPao setImage:[UIImage imageNamed:@"getbb_but"] forState:UIControlStateNormal];
	[btnPao setImage:[UIImage imageNamed:@"getbb_but_hover"] forState:UIControlStateHighlighted];
	//btnPao.frame=CGRectMake(14, kDeviceHeight-114-20-30, 61, 63);
    btnPao.frame = CGRectMake(14, kDeviceHeight-114-20, 61, 63);
	[btnPao addTarget:self action:@selector(clickBubble) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btnPao];
}
 

-(void)initCartBar{
	cartBar=[[UIView alloc] initWithFrame:CGRectMake(0, kTopbarHeight-CARTBAR_HEIGHT-44, kDeviceWidth, CARTBAR_HEIGHT)];
	cartBar.backgroundColor=[UIColor colorWithWhite:0 alpha:0.7];
	[self.view addSubview:cartBar];
	cartBar.hidden=YES;
	
	lblBalance=[[UILabel alloc] initWithFrame:CGRectMake(5, 17, 100, 40)];
	lblBalance.backgroundColor=[UIColor clearColor];
	lblBalance.font=[UIFont boldSystemFontOfSize:14.0];
	lblBalance.numberOfLines=0;
	lblBalance.textColor=[UIColor whiteColor];
	lblBalance.text=@"靓点余额\n999";
	lblBalance.textAlignment=UITextAlignmentCenter;
	lblBalance.shadowColor=SHADOW_COLOR;
	lblBalance.shadowOffset=CGSizeMake(1.0, 1.0);
	[cartBar addSubview:lblBalance];
	
	lblSelectedCount=[[UILabel alloc] initWithFrame:CGRectMake(110, 17, 100, 40)];
	lblSelectedCount.backgroundColor=[UIColor clearColor];
	lblSelectedCount.font=[UIFont boldSystemFontOfSize:14.0];
	lblSelectedCount.numberOfLines=0;
	lblSelectedCount.textColor=[UIColor whiteColor];
	lblSelectedCount.text=@"选择图片\n0";
	lblSelectedCount.textAlignment=UITextAlignmentCenter;
	lblSelectedCount.shadowColor=SHADOW_COLOR;
	lblSelectedCount.shadowOffset=CGSizeMake(1.0, 1.0);
	[cartBar addSubview:lblSelectedCount];
	
	lblSelectedAmount=[[UILabel alloc] initWithFrame:CGRectMake(215, 17, 100, 40)];
	lblSelectedAmount.backgroundColor=[UIColor clearColor];
	lblSelectedAmount.font=[UIFont boldSystemFontOfSize:14.0];
	lblSelectedAmount.numberOfLines=0;
	lblSelectedAmount.textColor=[UIColor whiteColor];
	lblSelectedAmount.text=@"需支付靓点\n0";
	lblSelectedAmount.textAlignment=UITextAlignmentCenter;
	lblSelectedAmount.shadowColor=SHADOW_COLOR;
	lblSelectedAmount.shadowOffset=CGSizeMake(1.0, 1.0);
	[cartBar addSubview:lblSelectedAmount];
	
	UIButton* btnOK=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnOK setTitle:@"确定" forState:UIControlStateNormal];
	[btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[btnOK setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
	btnOK.frame=CGRectMake(230, 60, 60, 25);
	btnOK.titleLabel.font=[UIFont systemFontOfSize:14.0];
	[btnOK addTarget:self action:@selector(clickOK) forControlEvents:UIControlEventTouchUpInside];
	[cartBar addSubview:btnOK];
    btnOK.hidden=YES;
	
	UIButton* btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
	[btnCancel setTitle:@"取消" forState:UIControlStateNormal];
	[btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[btnCancel setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
	btnCancel.frame=CGRectMake(30, 60, 60, 25);
	btnCancel.titleLabel.font=[UIFont systemFontOfSize:14.0];
	[btnCancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
	[cartBar addSubview:btnCancel];
    btnCancel.hidden=YES;
}

-(void)initHeader{
	header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth+72)];
	header.backgroundColor=[UIColor clearColor];
	
	imgDetail=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth)];
	imgDetail.image=[UIImage imageNamed:@"userBk"];
	imgDetail.contentMode=UIViewContentModeScaleAspectFill;
    imgDetail.userInteractionEnabled=YES;
	[header addSubview:imgDetail];
	
	imgAvatar=[[UIImageView alloc] initWithFrame:CGRectMake(11, kDeviceWidth-40, 55, 55)];
    //imgAvatar.contentMode=UIViewContentModeScaleAspectFill;
    imgAvatar.layer.cornerRadius = 4;
    imgAvatar.layer.masksToBounds = YES;
	//imgAvatar.clipsToBounds=YES;
    //[imgAvatar setImage:[UIImage imageNamed:self.curUserInfo.AvatarURL]];
    [imgAvatar setImageWithURL:[NSURL URLWithString:self.curUserInfo.AvatarURL]];
    [header addSubview:imgAvatar];
	
//	UIImageView* avatarMsk=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatarmask_small_gray"]];
//	avatarMsk.frame=CGRectMake(10, kDeviceWidth-39, 57, 57);
//	avatarMsk.contentMode=UIViewContentModeScaleToFill;
//	[header addSubview:avatarMsk];
	
	UIImageView* btnBg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_buttons_bg"]];
	btnBg.frame=CGRectMake(kDeviceWidth-107, kDeviceWidth-80, 107, 53);
	btnBg.contentMode=UIViewContentModeScaleToFill;
	btnBg.userInteractionEnabled=YES;
	[imgDetail addSubview:btnBg];
	
	lblFollow=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 38, 53)];
	lblFollow.backgroundColor=[UIColor clearColor];
	lblFollow.numberOfLines=0;
	[lblFollow setText:@" \n粉丝"];
	lblFollow.textColor=[UIColor whiteColor];
	lblFollow.font=[UIFont systemFontOfSize:10.0];
    lblFollow.userInteractionEnabled=YES;
    lblFollow.tag=100;
	[btnBg addSubview:lblFollow];
    
    UITapGestureRecognizer* tap0=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUser:)];
    tap0.numberOfTapsRequired=1;
    tap0.numberOfTouchesRequired=1;
    [lblFollow addGestureRecognizer:tap0];
	
	lblFan=[[UILabel alloc] initWithFrame:CGRectMake(69, 0, 38, 53)];
	lblFan.backgroundColor=[UIColor clearColor];
	lblFan.numberOfLines=0;
	[lblFan setText:@" \n关注"];
	lblFan.textColor=[UIColor whiteColor];
	lblFan.font=[UIFont systemFontOfSize:10.0];
    lblFan.userInteractionEnabled=YES;
    lblFan.tag=101;
	[btnBg addSubview:lblFan];
    
    UITapGestureRecognizer* tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUser:)];
    tap1.numberOfTapsRequired=1;
    tap1.numberOfTouchesRequired=1;
    [lblFan addGestureRecognizer:tap1];
	
	//[self initActionBar];//
	
    btnMsg=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnMsg setImage:[UIImage imageNamed:@"profile_letter_btn"] forState:UIControlStateNormal];
    btnMsg.frame=CGRectMake(192, kDeviceWidth+10, 51, 41);
    [btnMsg addTarget:self action:@selector(clickMsg) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:btnMsg];
    
    btnFollow=[UIButton buttonWithType:UIButtonTypeCustom];
   //btnFollow.hidden =  (self.curUserInfo.UserId == [AppHelper getIntConfig:confUserId])?YES:NO;
    [btnFollow setImage:[UIImage imageNamed:@"profile_fovored_btn"] forState:UIControlStateNormal];
    [btnFollow setImage:[UIImage imageNamed:@"profile_fovored_btn_h"] forState:UIControlStateHighlighted];
    btnFollow.frame=CGRectMake(260, kDeviceWidth+10, 51, 41);
    [btnFollow addTarget:self action:@selector(clickFollow:) forControlEvents:UIControlEventTouchUpInside];
	btnFollow.tag=100;
    [header addSubview:btnFollow];
    
    imgVSep=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_vertical_seperator"]];
    imgVSep.frame=CGRectMake(250, kDeviceWidth+10, 2, 40);
    [header addSubview:imgVSep];
    
	lblName=[[UILabel alloc] initWithFrame:CGRectMake(10, kDeviceWidth+25, kDeviceWidth-100, 20)];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.textColor=[UIColor colorWithWhite:0.1 alpha:1.0];
    lblName.font=[UIFont boldSystemFontOfSize:15.0];
    [header addSubview:lblName];
    
    UIButton *btnSetUser = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth-100, kDeviceWidth+5,kDeviceWidth-100, 20)];
    [header addSubview:btnSetUser];
	
	lblProfile=[[UILabel alloc] initWithFrame:CGRectMake(10, kDeviceWidth+50, kDeviceWidth-100, 20)];
    lblProfile.backgroundColor=[UIColor clearColor];
    lblProfile.textColor=[UIColor colorWithWhite:0.4 alpha:1.0];
    lblProfile.font=[UIFont boldSystemFontOfSize:15.0];
    //lblProfile.text=@"个性签名在这里...";
    [header addSubview:lblProfile];
	
	/*
    UIImageView* imgHSep=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feeddetail_favors_seperator"]];
    imgHSep.frame=CGRectMake(0, kDeviceWidth+90, kDeviceWidth, 2);
    [header addSubview:imgHSep];
    
	
    UILabel* lblwin=[[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-75)/2, kDeviceWidth+83, 75, 15)];
    lblwin.text=@"橱窗展示";
    lblwin.backgroundColor=COLOR_BACKGROUND;
    lblwin.textColor=[UIColor grayColor];
    lblwin.textAlignment=UITextAlignmentCenter;
    lblwin.font=[UIFont boldSystemFontOfSize:16.0];
    [header addSubview:lblwin];
    
    for (int k=0; k<3; k++) {
        UIImageView* imgDisplay=[[UIImageView alloc] initWithFrame:CGRectMake(104*k+8, kDeviceWidth+115, 96, 96)];
        imgDisplay.tag=100+k;
        imgDisplay.image=[UIImage imageNamed:[NSString stringWithFormat:@"example10%d.jpg",k+1]];
        imgDisplay.contentMode=UIViewContentModeScaleAspectFill;
        imgDisplay.clipsToBounds=YES;
        [header addSubview:imgDisplay];
    }
    
    UIImageView* imgHSep2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feeddetail_favors_seperator"]];
    imgHSep2.frame=CGRectMake(0, kDeviceWidth+235, kDeviceWidth, 2);
    [header addSubview:imgHSep2];

    
    UILabel* lblwin2=[[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-75)/2, kDeviceWidth+228, 75, 15)];
    lblwin2.text=@"个人展示";
    lblwin2.backgroundColor=COLOR_BACKGROUND;
    lblwin2.textColor=[UIColor redColor];
    lblwin2.textAlignment=UITextAlignmentCenter;
    lblwin2.font=[UIFont boldSystemFontOfSize:16.0];
//    lblwin2.shadowOffset=CGSizeMake(0, 1.0);
//    lblwin2.shadowColor=SHADOW_COLOR;
    [header addSubview:lblwin2];
    	 */
	[tbContent setTableHeaderView:header];
	
	tbContent.contentInset=UIEdgeInsetsMake(-110, 0, 0, 0);
}

-(void)initActionBar{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData:(UserInfo*)info{
    self.curUserInfo = info;
    lblTitle.text=self.curUserInfo.UserName;
    lblName.text=self.curUserInfo.UserName;
   
	if (self.curUserInfo.UserId==[AppHelper getIntConfig:confUserId]) {
		btnMsg.hidden=YES;
		imgVSep.hidden=YES;
		[btnFollow setImage:[UIImage imageNamed:@"profile_setting_btn"] forState:UIControlStateNormal];
		[btnFollow setImage:[UIImage imageNamed:@"profile_setting_btn"] forState:UIControlStateHighlighted];
		btnFollow.tag=101;
	}
    NSLog(@"%@",self.curUserInfo.AvatarURL);
	[imgAvatar setImageWithURL:[NSURL URLWithString:self.curUserInfo.AvatarURL]];
    int userid=[AppHelper getIntConfig:confUserId];
	if (arrData.count==0&&userid) {
		[self loadDataFromWeb];
	}
}

#pragma mark - Load Data
-(void)loadUserInfo{
	int userid=[AppHelper getIntConfig:confUserId];
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
	[asirequest setPostValue:METHOD_USERINFO forKey:@"method"];
    
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", userid] forKey:@"userid"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", self.curUserInfo.UserId] forKey:@"ownerid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];

    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
			NSLog(@"data====%@",data);
           
            for (NSDictionary *di in data) {
                 lblProfile.text =  [AppHelper getStringFromDictionary:di key:@"introduction"];;
				if (fanCount==0) {
					fanCount=[AppHelper getIntFromDictionary:di key:@"fancount"];
					
				}
				if (followCount==0) {
					followCount=[AppHelper getIntFromDictionary:di key:@"carecount"];
				}
                isFollowed=([AppHelper getIntFromDictionary:di key:@"iscare"]==1);
                NSLog(@"isFollowed===%d",isFollowed);
              
            }
 			[lblFollow setText:[NSString stringWithFormat:@"%d \n粉丝",followCount]];
			[lblFan setText:[NSString stringWithFormat:@"%d \n关注",fanCount]];
            if (self.curUserInfo.UserId==[AppHelper getIntConfig:confUserId]) {
                btnMsg.hidden=YES;
                imgVSep.hidden=YES;
                [btnFollow setImage:[UIImage imageNamed:@"profile_setting_btn"] forState:UIControlStateNormal];
                [btnFollow setImage:[UIImage imageNamed:@"profile_setting_btn"] forState:UIControlStateHighlighted];
                btnFollow.tag=101;
                
            }
            
            else if (isFollowed) {
				[btnFollow setImage:[UIImage imageNamed:@"profile_unfovored_btn"] forState:UIControlStateNormal];
				[btnFollow setImage:[UIImage imageNamed:@"profile_unfovored_btn_h"] forState:UIControlStateHighlighted];
			}
			else{
				[btnFollow setImage:[UIImage imageNamed:@"profile_fovored_btn"] forState:UIControlStateNormal];
				[btnFollow setImage:[UIImage imageNamed:@"profile_fovored_btn_h"] forState:UIControlStateHighlighted];
			}
            [self loadDataFromWeb];
        }
        else{
            [AppHelper showAlertMessage:msg];
            [self loadDataFromWeb];
        }
    }];
    [asirequest setFailedBlock:^{
        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
}
-(void)loadDataFromWeb{
	int userid=[AppHelper getIntConfig:confUserId];
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
	[asirequest setPostValue:METHOD_MYPHOTOLIST forKey:@"method"];
  
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", userid] forKey:@"userid"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", self.curUserInfo.UserId] forKey:@"ownerid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"page"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d",10] forKey:@"pageCount"];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
			NSLog(@"data===%@",data);
            [arrData removeAllObjects];
            
            for (NSDictionary *di in data) {
//				if (fanCount==0) {
//					fanCount=[AppHelper getIntFromDictionary:di key:@"fancount"];
//					
//				}
//				if (followCount==0) {
//					followCount=[AppHelper getIntFromDictionary:di key:@"carecount"];
//				}
//                isFollowed=([AppHelper getIntFromDictionary:di key:@"iscare"]==1);
                PrivateImage* item=[[PrivateImage alloc] initWithDict:di];
				[self addDownloadItem:item];
                [arrData addObject:item];
            }
            [tbContent reloadData];
// 			[lblFollow setText:[NSString stringWithFormat:@"%d \n关注",followCount]];
//			[lblFan setText:[NSString stringWithFormat:@"%d \n粉丝",fanCount]];
//            if (self.curUserInfo.UserId==[AppHelper getIntConfig:confUserId]) {
//                btnMsg.hidden=YES;
//                imgVSep.hidden=YES;
//                [btnFollow setImage:[UIImage imageNamed:@"profile_setting_btn"] forState:UIControlStateNormal];
//                [btnFollow setImage:[UIImage imageNamed:@"profile_setting_btn"] forState:UIControlStateHighlighted];
//                btnFollow.tag=101;
//                
//            }
//
//            else if (isFollowed) {
//				[btnFollow setImage:[UIImage imageNamed:@"profile_unfovored_btn"] forState:UIControlStateNormal];
//				[btnFollow setImage:[UIImage imageNamed:@"profile_unfovored_btn_h"] forState:UIControlStateHighlighted];
//			}
//			else{
//				[btnFollow setImage:[UIImage imageNamed:@"profile_fovored_btn"] forState:UIControlStateNormal];
//				[btnFollow setImage:[UIImage imageNamed:@"profile_fovored_btn_h"] forState:UIControlStateHighlighted];
//			}

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
-(void)pickPaoPao{
    
    int userid=[AppHelper getIntConfig:confUserId];
//    if (!userid&&arrData.count >= 5) {
//        [AppHelper showAlertMessage:@"登录获取更多泡泡"];
//        return;
//    }
    [AppHelper showHUD:@"正在加载..." baseview:self.view];
	
    
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
	[asirequest setPostValue:METHOD_GETSTATUS forKey:@"method"];
    if (userid) {
        [asirequest setPostValue:[NSString stringWithFormat:@"%d", userid] forKey:@"userid"];
        [asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
    }else{
        int page = arrData.count;
        if(page==10){
            [AppHelper showAlertMessage:@"新账号登录，马上免费获得100靓点，可以查看100张泡泡靓照！"];
            [AppHelper hideHUD:self.view];
            return;
        }
        page = page +1;
        [asirequest setPostValue:[NSString stringWithFormat:@"1"] forKey:@"r"];
        [asirequest setPostValue:[NSString stringWithFormat:@"%d",page] forKey:@"num"];
        [AppHelper hideHUD:self.view];
    }

	
	
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSLog(@"JSON===%@",JSON);
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
			NSLog(@"data=====%@",data);
            PrivateImage* item=[[PrivateImage alloc] initWithDict:data];
            if (userid) {
                NSString *strKey = [NSString stringWithFormat:@"paopaoData%d",userid];
                [arrPaoPao insertObject:data atIndex:0];
                [AppHelper setArrayConfig:strKey val:arrPaoPao];
            }
            [self addDownloadItem:item];
            [arrData insertObject:item atIndex:0];
            [tbContent beginUpdates];
            [tbContent insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [tbContent endUpdates];
            
//            BubbleCell* cell=(BubbleCell*)[tbContent viewWithTag:TAGOFFSET_BUBBLECELL+item.ImageId];
//            if (cell) {
//                [cell downloadImage];
//            }
            
            //	DLog(@"tbContent.contentOffset.y - %f",tbContent.contentOffset.y);
            if (tbContent.contentOffset.y<574) {
                CGFloat height=header.frame.size.height;
                //		DLog(@"%f",height);
                [tbContent scrollRectToVisible:CGRectMake(0,  height, kDeviceWidth, tbContent.frame.size.height) animated:YES];
            }
            [tbContent reloadData];

        }
        else{
            [AppHelper showAlertMessage:msg];
        }
        [self hidenLogo];
		[AppHelper hideHUD:self.view];
    }];
    [asirequest setFailedBlock:^{
		[AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
}

-(void)pushUnloginData:(PrivateImage *)info celltag:(int)celltag  withRow:(int)row{
    
  
	
    
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
	[asirequest setPostValue:METHOD_STATUSLOOKUNLOGIN forKey:@"method"];
  
    [asirequest setPostValue:[NSString stringWithFormat:@"%d",info.ImageId] forKey:@"sid"];
  
    
	
	
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSLog(@"JSON===%@",JSON);
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            int watchTimes =[[JSON objectForKey:@"data"] intValue];
            if (watchTimes) {
                TrendsCell *cell=(TrendsCell *)[tbContent viewWithTag:celltag];
                static NSString* cellId=@"mycell";
                
                if (!cell) {
                    if (self.PlazaType == PLAZA_FAXIAN) {
                        cell=[[TrendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    }else
                        cell=[[TrendsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                }
                NSLog(@"%d",cell.row);
               // info.WatchDate = [AppHelper getCurrentDate:@"yyyy-M-d HH:mm"] ;
                info.ViewCount = watchTimes;
                [arrData replaceObjectAtIndex:row withObject:info];
                [cell loadData:info];
            }
                     
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
    }];
    [asirequest setFailedBlock:^{
    }];
    [asirequest startAsynchronous];
}
-(void)pushData:(PrivateImage *)info celltag:(int)celltag withRow:(int)row{
    NSLog(@"%d",info.ViewCount);
	NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
	NSDictionary* dict;
      if ([AppHelper getIntConfig:confUserId]) {
          dict =@{
					  @"method":METHOD_STATUSLOOK,
       @"userid":userid,
       @"token":[AppHelper getStringConfig:confUserToken],
       @"sid":[NSString stringWithFormat:@"%d",info.ImageId],
	   };
      }else
      {
          dict =@{
                  @"method":METHOD_STATUSLOOKUNLOGIN,
                  @"sid":[NSString stringWithFormat:@"%d",info.ImageId],
                  };
      }
    NSLog(@"ImageId===%d",info.ImageId);
    NSString *prams = @"aa=0";
    for (id keys in dict) {
		prams = [prams stringByAppendingFormat:@"&%@=%@",keys,[dict objectForKey:keys]] ;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@?%@",UrlBase,prams];
    NSLog(@"urlString===%@",urlString);
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
                TrendsCell *cell=(TrendsCell *)[tbContent viewWithTag:celltag];
                
                info.ViewCount = watchTimes;
                info.issee = 1;
                 [arrData replaceObjectAtIndex:row withObject:info];
                [cell loadData:info];
                NSIndexPath * path = [tbContent indexPathForCell:cell];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[arrPaoPao objectAtIndex:path.row]];
                [dict setValue:[NSString stringWithFormat:@"%d",watchTimes] forKey:@"watchTimes"];
                //[dict setValue:info.WatchDate forKey:@"watchTime"];
                [dict setValue:@"1" forKey:@"issee"];
                [dict setValue:info.WatchDate forKey:@"watchtime"];
                if (userid) {
                    [arrPaoPao replaceObjectAtIndex:path.row withObject:dict];
                    NSString *strKey = [NSString stringWithFormat:@"paopaoData%@",userid];
                    [AppHelper setArrayConfig:strKey val:arrPaoPao];
                }
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

#pragma mark - CartBar Event
-(void)hideCartBar{
	[UIView animateWithDuration:0.15 animations:^{
		cartBar.frame=CGRectMake(0, kTopbarHeight, kDeviceWidth, CARTBAR_HEIGHT);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.20 animations:^{
			cartBar.frame=CGRectMake(0, kTopbarHeight-CARTBAR_HEIGHT, kDeviceWidth, CARTBAR_HEIGHT);
		} completion:^(BOOL finished) {
			cartBar.hidden=YES;
		}];
	}];
}

-(void)showCartBar{
	cartBar.hidden=NO;
	[UIView animateWithDuration:0.20 animations:^{
		cartBar.frame=CGRectMake(0, kTopbarHeight, kDeviceWidth, CARTBAR_HEIGHT);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.15 animations:^{
			cartBar.frame=CGRectMake(0, kTopbarHeight-10, kDeviceWidth, CARTBAR_HEIGHT);
		}];
	}];
}
-(void)clearSaveData{
    int userid = [AppHelper getIntConfig:confUserId];
    if (userid) {
        NSString *strKey = [NSString stringWithFormat:@"paopaoData%d",userid];
        [AppHelper setArrayConfig:strKey val:nil];
        [arrPaoPao removeAllObjects];//= [[NSMutableArray alloc] initWithArray:[AppHelper getArrayConfig:strKey]];
        [arrData removeAllObjects];
         imageNo.hidden = NO;
        [tbContent reloadData];
    }
}
-(void)clearData{
  
    [arrData removeAllObjects];
    [tbContent reloadData];
    [self hidenLogo];
}
#pragma mark - Click Event
-(void)clickBubble{
    if ([cartBar isHidden]) {
        [self showCartBar];
    }
    [[AppDelegate App] playSound:@"Button7" ext:@"wav"];
    selectedCount++;
    selectedAmount+=10;
    lblSelectedCount.text=[NSString stringWithFormat:@"选择图片\n%d",selectedCount];
	lblSelectedAmount.text=[NSString stringWithFormat:@"需支付靓点\n%d",selectedAmount];
    
    [self pickPaoPao];
    
    
//	PrivateImage* item=[[PrivateImage alloc] init];
//    item.State=PrivateImageStateDownloading;
////	item.Second=arc4random()%8+2;
//    item.UserId=arrData.count*2;
//	item.ImageUrl=[NSString stringWithFormat:@"example10%d.jpg",arrData.count%9];
}

-(void)clickOK{
	[self hideCartBar];
	for (int k=0,len=arrData.count; k<len; k++) {
		PrivateImage* item=(PrivateImage*)arrData[k];
		if (item.State==PrivateImageStateSelected) {
			item.State=PrivateImageStateDownloading;
		}
	}
	[tbContent reloadData];
	selectedAmount=0;
	selectedCount=0;
}

-(void)clickCancel{
	[self hideCartBar];
	[tbContent reloadData];
}

-(void)clickBack{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)clickMore{
	UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"加入黑名单", @"举报该用户",nil];
	[sheet showInView: self.view];
	sheet.tag=100;
}

-(void)clickMsg{
	ChatViewController* controller=[[ChatViewController alloc] init];
	controller.strUserName=self.curUserInfo.UserName;
	controller.PeerId=self.curUserInfo.UserId;
	[[HomeViewController shared] presentViewController:controller animated:YES completion:nil];
}

-(void)clickFollow:(UIView *)sender{
	if (sender.tag==101) {
		SettingViewController *controllerSet=[[SettingViewController alloc] init];
        controllerSet.isUserMader = YES;
        [self.navigationController pushViewController:controllerSet animated:YES];
		return;
	}
	int myuserid=[AppHelper getIntConfig:confUserId];
	if (self.curUserInfo.UserId==myuserid) {
		return;
	}
	if (isFollowing) {
		return;
	}
	isFollowing=YES;
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
	if (isFollowed) {
		[asirequest setPostValue:METHOD_UNFOLLOWUSER forKey:@"method"]; 
	}
	else{
		[asirequest setPostValue:METHOD_FOLLOWUSER forKey:@"method"]; 
	}
	isFollowed=!isFollowed;
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", myuserid] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"]; 
	[asirequest setPostValue:[NSString stringWithFormat:@"%d",self.curUserInfo.UserId] forKey:@"ownerid"];
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
        
			if (isFollowed) {
                followCount ++;
                [lblFollow setText:[NSString stringWithFormat:@"%d \n粉丝",followCount]];
            
				[btnFollow setImage:[UIImage imageNamed:@"profile_unfovored_btn"] forState:UIControlStateNormal];
				[btnFollow setImage:[UIImage imageNamed:@"profile_unfovored_btn_h"] forState:UIControlStateHighlighted];
			}
			else{
                followCount --;
                [lblFollow setText:[NSString stringWithFormat:@"%d \n粉丝",followCount]];
				[btnFollow setImage:[UIImage imageNamed:@"profile_fovored_btn"] forState:UIControlStateNormal];
				[btnFollow setImage:[UIImage imageNamed:@"profile_fovored_btn_h"] forState:UIControlStateHighlighted];
			}
        }
		else{
			DLog(@"%@",msg);
		}
		isFollowing=NO;
    }];
    [asirequest setFailedBlock:^{
		DLog(@"sendMessage - failure");
		isFollowing=NO;
    }];
    [asirequest startAsynchronous];
}

-(void)addBlack{
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
	int myuserid=[AppHelper getIntConfig:confUserId];
    [asirequest setPostValue:METHOD_ADDBLACK forKey:@"method"];
    // [asirequest setPostValue:METHOD_DELBLACK forKey:@"method"];
    //[asirequest setPostValue:METHOD_MYBLACKLIST forKey:@"method"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", myuserid] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", self.curUserInfo.UserId] forKey:@"blackid"];
    NSLog(@"UserId===%d,%d",self.curUserInfo.UserId,myuserid);
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
       // NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            NSLog(@"JSON===%@",JSON);
			        }
		else{
		
		}
    }];
    [asirequest setFailedBlock:^{

    }];
    [asirequest startAsynchronous];
}
-(void)tapUser:(UITapGestureRecognizer*)gesture{
    int itag=gesture.view.tag;
    UserListViewController* controller=[[UserListViewController alloc] init];
    controller.listUserid = self.curUserInfo.UserId;
    controller.isFanList=(itag==101);
    [self.navigationController pushViewController:controller animated:YES];
    [controller refreshData];
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (actionSheet.tag == 100) {
        [self addBlack];
    }else if(actionSheet.tag == 102){
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
                
                [[AppDelegate App] sendAppImg:WXSceneSession withTitle:pinfoImg.UserName  withContent:pinfoImg.ThumbUrl withThumbImg:pinfoImg.ThumbUrl];
            }
                break;
            case 2:{
                [[AppDelegate App] sendAppImg:WXSceneTimeline withTitle:pinfoImg.UserName  withContent:pinfoImg.ThumbUrl withThumbImg:pinfoImg.ThumbUrl];
                
            }
                break;
                
            default:
                break;
        }

    }
    
    
//    SinaWeibo *sinaWeibo = [[AppDelegate App] sinaweibo];
//    
//    sinaWeibo.delegate = self;
//    NSString *asstoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"sina_access_token"];
//    if (asstoken) {
//        // [sinaWeibo logOut];
//        SinaWeibo *sinaweibo = [[AppDelegate App] sinaweibo];
//        sinaweibo.accessToken = asstoken;
//        [self sinaweiboDidLogIn:sinaweibo];
//        
//    }
//    else {
//        [sinaWeibo logIn];
//    }
    
    
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
      NSString *str = [NSString stringWithFormat:@"%@ 的靓图,%@%@",[pinfoImg.UserName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"去”泡泡美女”查看大图和更多！",SHAREAPPURL];
    //NSString *str =[NSString stringWithFormat:@"%@ 的靓图",pinfoImg.UserName];
    // NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
    NSLog(@"ImageUrl===%@",pinfoImg.ThumbUrl);
    NSData *dataObj = [NSData dataWithContentsOfURL:[NSURL URLWithString:pinfoImg.ThumbUrl]];
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
#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrivateImage* info=arrData[indexPath.row];
     if (self.PlazaType == PLAZA_FAXIAN)
         return 345.0 + 40*(info.arrGift.count>=3?3+1:info.arrGift.count)-25-10;
    else
        return 305.0 + 40*(info.GiftCount>=3?3+1:info.arrGift.count)-25-10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    int count=ceil(arrData.count/4.0) ;
//	return  count;
	return arrData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString* cellId=@"mycell";
	
	TrendsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    int row=indexPath.row;
	if (!cell) {
        if (self.PlazaType == PLAZA_FAXIAN) {
            cell=[[TrendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }else
            cell=[[TrendsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
	}
    
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.toolbarDelegate=self;
	cell.bubbleDelegate=self;
	PrivateImage* info=arrData[row];
    cell.row  = row+1;
	[cell loadData:info];
    
	cell.tag=TAGOFFSET_BUBBLECELL+info.ImageId;
	return cell;
}

/*
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString* cellId=@"mycell";
	PrivatePhotoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
	if (!cell) {
		cell=[[PrivatePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
	}
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	int row=indexPath.row;
	int start=row*4;
	int end=start+4;
	if (end>arrData.count) {
		end=arrData.count;
	}
	[cell removeImages];
	int col=0;
	for (int k=start; k<end; k++) {
		PrivateImage* item=[arrData objectAtIndex:k];
		item.RowIndex=row;
		item.ColIndex=col;
		[cell addImage:item];
		col++;
	} 
	cell.contentView.tag=TAGOFFSET_PRIVATECELL+row;
	cell.delegate=self;
	[cell refreshData];
	return cell;
}
*/

#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	CGFloat newY=scrollView.contentOffset.y;
//	DLog(@"newy: %f",newY);
	if (newY<0.0) {
		[scrollView setContentOffset:CGPointMake(0, 0)];
//		[scrollView scrollRectToVisible:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) animated:NO];
	}
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
            TrendsCell *cell=(TrendsCell *)[tbContent viewWithTag:info.ImageId+TAGOFFSET_BUBBLECELL];
            GiftViewController* controller=[[GiftViewController alloc] init];
            controller.curInfo=info;
            if (self.PlazaType == PLAZA_FAXIAN) {
                NSLog(@"%d",cell.row);
                 controller.row = cell.row;
            }
           
            NSLog(@"%d",info.UserId);

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
             pinfoImg = info;
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
			actions.tag=102;
			[actions showInView:[HomeViewController shared].view];
			reportedImageId=info.ImageId;
		}
			break;
    }
}


#pragma mark - BubbleCell Delegate
-(void)CellAddDownItem:(PrivateImage *)img{
    [self addDownloadItem:img];
}
-(void)CellStateChanged:(NSDictionary*)dict{

	int index=[[dict objectForKey:@"index"] integerValue];
	NSString* state=[dict objectForKey:@"state"];
	PrivateImage* item=(PrivateImage*) arrData[index];
	switch ([state integerValue]) {
		case 0:
		{
			if (cartBar.hidden) {
				[self showCartBar];
			}
			item.State=PrivateImageStateNormal;
			selectedCount--;
			if (selectedCount<0) {
				selectedCount=0;
			}
			selectedAmount-=10;
			if (selectedAmount<0) {
				selectedAmount=0;
			}
		}
			break;
			
		case 1:
		{
			if (cartBar.hidden) {
				[self showCartBar];
			}
			item.State=PrivateImageStateSelected;
			selectedCount++;
			selectedAmount+=10;
		}
			break;
		case 3:
		{
			item.State=PrivateImageStateDownloaded;
		}
			break;
	}
 
	lblSelectedCount.text=[NSString stringWithFormat:@"选择图片\n%d",selectedCount];
	lblSelectedAmount.text=[NSString stringWithFormat:@"需支付靓点\n%d",selectedAmount];
}

-(void)CellLongPressBegan:(NSDictionary*)dict{
    arrTimer = [arrData copy];
    if ([AppHelper getIntConfig:confUserCoin ] <=1&&[AppHelper getIntConfig:confUserId]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"靓点不足"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
      
        
        return;
    }
	NSString* url=[dict objectForKey:@"url"];
	int second=[[dict objectForKey:@"second"] integerValue];
	int curCellTag=[[dict objectForKey:@"tag"] integerValue];
    curTabTag = curCellTag;
    int row = [[dict objectForKey:@"row"] intValue]-1;
	curCellCol=[[dict objectForKey:@"col"] integerValue];
	int curCellId = [[dict objectForKey:@"curId"] integerValue];
    TrendsCell *cell=(TrendsCell *)[tbContent viewWithTag:curCellTag];
    cell.curInfo.Second = second;
    
	[btnTimer setTitle:[NSString stringWithFormat:@"%d秒",second] forState:UIControlStateNormal];
    btnTimer.hidden = NO;
	bgPreview.hidden=NO;
	[imgPreview setImageWithURL:[NSURL URLWithString:url]];
	if (cell.timerCountDown) {
		[cell.timerCountDown invalidate];
	}
    int  userId =  [AppHelper getIntConfig:confUserId];
    if (curCellId != userId) {
        cell.timerCountDown=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTimer:) userInfo:dict repeats:YES];
        
    }else{
        [self changeLblSec:curCellTag withRow:row];
    }
    NSLog(@"begin+====%d",second);

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self clickBack];
    [[HomeViewController shared] ApliyView];
}
-(void)CellLongPressEnded:(NSDictionary*)dict{
//	if (self.timerCountDown) {
//		[self.timerCountDown invalidate];
//	}
//     int row = [[dict objectForKey:@"row"] intValue];
//    int curCellTag=[[dict objectForKey:@"tag"] integerValue];
	//[self changeLblSec:curCellTag withRow:row];
    btnTimer.hidden = YES;
	bgPreview.hidden=YES;
    int curCellTag=[[dict objectForKey:@"tag"] integerValue];
    int second=[[dict objectForKey:@"second"] integerValue];
    TrendsCell *cell=(TrendsCell *)[tbContent viewWithTag:curCellTag];
    [cell refreshSecond:second];
    NSLog(@"end=====second===%d",second);
}

-(void)CellLongPressCancelled:(NSDictionary*)dict{
     int row = [[dict objectForKey:@"row"] intValue]-1;
     int curCellTag=[[dict objectForKey:@"tag"] integerValue];
    TrendsCell *cell=(TrendsCell *)[tbContent viewWithTag:curCellTag];
    if (cell.timerCountDown) {
		[cell.timerCountDown invalidate];
	}
	[self changeLblSec:curCellTag withRow:row];
	bgPreview.hidden=YES;
     btnTimer.hidden = YES;
}

-(void)changeLblSec:(int)curCellTag withRow:(int)row{
	
	TrendsCell *cell=(TrendsCell *)[tbContent viewWithTag:curCellTag];
    PrivateImage *curInfo = arrData[row];
    int second=curInfo.Second;// [[btnTimer.titleLabel.text stringByReplacingOccurrencesOfString:@"秒" withString:@""] intValue];
    int  userId =  [AppHelper getIntConfig:confUserId];
    NSLog(@"second====%d",second);
    if (second>0) {
        if (curTabTag ==curCellTag) {
            [btnTimer setTitle:[NSString stringWithFormat:@"%d秒",second] forState:UIControlStateNormal];
        }
         [cell refreshSecond:second];
        cell.curInfo.Second=second;
        if (cell.curInfo.UserId == userId&&!cell.curInfo.ViewCount) {
            cell.curInfo.ViewCount =1;
        }
    }
    else{
        if (cell.timerCountDown) {
            [cell.timerCountDown invalidate];
        }
        cell.curInfo.WatchDate = [AppHelper getCurrentDate:@"yyyy-M-d HH:mm"] ;
        cell.curInfo.Second=0;
        cell.curInfo.State=PrivateImageStateViewed;
        curInfo.Second = 0;
        curInfo.State = PrivateImageStateDownloaded;
        curInfo.WatchDate = [AppHelper getCurrentDate:@"yyyy-M-d HH:mm"] ;
        if ([AppHelper getIntConfig:confUserId]) {
            [self pushData:curInfo celltag:curCellTag withRow:row];
        }else
        {
            [self pushUnloginData:curInfo celltag:curCellTag withRow:row];
        }
       
        
        [cell refreshData];
        
    }
    
    
	//		UIImageView* img=(UIImageView*)[cell.contentView viewWithTag:TAGOFFSET_BASE+curCellCol];
	
    /*
    UILabel* lblsec=(UILabel*)[cview viewWithTag:TAGOFFSET_SECOND+curCellCol];
	UIImageView* imgLock=(UIImageView*)[cview viewWithTag:TAGOFFSET_LOCK+curCellCol];
	if (second>0) {
		lblsec.text=[NSString stringWithFormat:@"%d",second];
	}
	else{
		lblsec.text=@"0";
		lblsec.hidden=YES;
		imgLock.hidden=NO;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		
	}
     */
}

#pragma mark - Timer
-(void)showTimer:(NSTimer *)timer{
   NSDictionary * dic = [timer userInfo] ;
    int curCellTag = [[dic objectForKey:@"tag"] intValue];
     int row = [[dic objectForKey:@"row"] intValue] -1;
    row = row+[arrData count] - [arrTimer count];
    TrendsCell *cell=(TrendsCell*)[tbContent viewWithTag:curCellTag];
	//if (bgPreview.hidden) {
        [self changeLblSec:curCellTag withRow:row];
		//return;
	//}
    PrivateImage *curInfo = arrData[row];
	int second= curInfo.Second;//[[btnTimer.titleLabel.text stringByReplacingOccurrencesOfString:@"秒" withString:@""] intValue];
    NSLog(@"%d",curInfo.UserId);
   // NSLog(@"second===%d---%d",second,row);
	
   //  NSLog(@"second===%d",second);
	if (second<=0) {
        if (timer) {
            [timer invalidate];
        }
		
		//[self changeLblSec:curCellTag withRow:row];
		bgPreview.hidden=YES;
         if (curTabTag ==curCellTag) {
             [btnTimer setTitle:@"0秒" forState:UIControlStateNormal];
             btnTimer.hidden = YES;
         }
		return;
	}
	else{
       
        second--;
        cell.curInfo.Second = second;
        curInfo.Second = second;
       // NSLog(@"%d=====%d",[arrTimer count],[arrData count]);
        //if ([arrTimer count] == [arrData count]) {
            [arrData replaceObjectAtIndex:row withObject:curInfo];
//        }else{
//            [arrData replaceObjectAtIndex:(row+[arrData count] - [arrTimer count]) withObject:curInfo];
//        }
		
	}
     NSLog(@"second===%d",second);
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
    NSLog(@"msg.UserName-====%@",msg.UserName);
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

-(void)refreshCell:(PrivateImage*)info{
	TrendsCell *cell=(TrendsCell*)[tbContent viewWithTag:(TAGOFFSET_BUBBLECELL+info.ImageId)];
	if (cell) {
        NSLog(@"%d",info.State);
		//		DLog(@" ");
		[cell loadData:info];
	}
}


@end
