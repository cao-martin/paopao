//
//  MoreGiftViewController.m
//  charmgram
//
//  Created by martin on 13-8-10.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "MoreGiftViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
@interface MoreGiftViewController ()

@end

@implementation MoreGiftViewController
@synthesize timerCountDown;
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
    arrItem=[[NSMutableArray alloc] initWithCapacity:0];
    
    UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopbarHeight)];
    topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    
    UILabel* lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 24)];
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.shadowOffset=CGSizeMake(0, 1.0);
    lblTitle.shadowColor=SHADOW_COLOR;
    lblTitle.text=@"收到的礼物";
    lblTitle.font=[UIFont boldSystemFontOfSize:20.0];
    [topbar addSubview:lblTitle];
    
    UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"navi_back_btn"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"navi_back_btn_h"] forState:UIControlStateHighlighted];
    btnCancel.frame=CGRectMake(8, 6, 52,32);
    btnCancel.titleLabel.font=[UIFont boldSystemFontOfSize:12.0];
    //[btnCancel setTitle:@"  返回" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnCancel];
    [self.view addSubview:topbar];
	// Do any additional setup after loading the view.
    
    tbGift = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, kDeviceHeight-55)];
    tbGift.dataSource=self;
    tbGift.delegate=self;
    tbGift.backgroundColor=[UIColor clearColor];
    tbGift.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tbGift];
   
    [self initHeader];
    [self initPreview];
    [self showTimer];
    [self loadDataFromWeb];
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
	
	[self.view addSubview:bgPreview];
}
-(void)initHeader{
	header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth+20)];
	header.backgroundColor=[UIColor clearColor];
	
	imgDetail=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth)];
	imgDetail.image=[UIImage imageNamed:@"item_bg310"];
	imgDetail.contentMode=UIViewContentModeScaleAspectFill;
    imgDetail.userInteractionEnabled=YES;
	[header addSubview:imgDetail];
	
    
    UILongPressGestureRecognizer *longGR=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCell:)];
	longGR.numberOfTouchesRequired=1;
	longGR.minimumPressDuration=0.2;
	[imgDetail addGestureRecognizer:longGR];
    
	imgPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(129, 80+110, 72, 72)];
	imgPhoto.contentMode=UIViewContentModeScaleAspectFill;
    imgPhoto.layer.cornerRadius = 36;
    imgPhoto.layer.borderWidth=3;
    imgPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
    imgPhoto.layer.masksToBounds = YES;
	[imgDetail addSubview:imgPhoto];
    [imgPhoto setImageWithURL:[NSURL URLWithString:self.curInfo.ThumbUrl]];
    
	lblTip=[[UILabel alloc] initWithFrame:CGRectMake(10, kDeviceWidth-40, kDeviceWidth-23, 20)];
	lblTip.font=[UIFont systemFontOfSize:12.0];
	lblTip.textAlignment=UITextAlignmentRight;
	lblTip.backgroundColor=[UIColor clearColor];
	lblTip.text=@"按住查看";
	lblTip.textColor=[UIColor grayColor];
	[imgDetail addSubview:lblTip];
    
    imgBubble=[[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-40, 10+110, 30, 31)];
	imgBubble.image=[UIImage imageNamed:@"status_paopao_ico"];
	[imgDetail addSubview:imgBubble];
    
    lblTimer=[[UILabel alloc] initWithFrame:CGRectMake(0, 3, 30, 20)];
	lblTimer.font=[UIFont boldSystemFontOfSize:13.0];
	lblTimer.textAlignment=UITextAlignmentCenter;
	lblTimer.backgroundColor=[UIColor clearColor];
	lblTimer.textColor=[UIColor whiteColor];
	lblTimer.shadowColor=SHADOW_COLOR;
	lblTimer.shadowOffset=CGSizeMake(1, 1);
	[imgBubble addSubview:lblTimer];
   
    
	imgAvatar=[[UIImageView alloc] initWithFrame:CGRectMake(11, kDeviceWidth-40, 55, 55)];
    //imgAvatar.contentMode=UIViewContentModeScaleAspectFill;
    imgAvatar.layer.cornerRadius = 4;
    imgAvatar.layer.masksToBounds = YES;
	//imgAvatar.clipsToBounds=YES;
    //[imgAvatar setImage:[UIImage imageNamed:self.curUserInfo.AvatarURL]];
    [imgAvatar setImageWithURL:[NSURL URLWithString:self.curInfo.AvatarUrl]];
    [header addSubview:imgAvatar];
	
	

	
    //	[self initActionBar];//
    

    
	lblName=[[UILabel alloc] initWithFrame:CGRectMake(10, kDeviceWidth+25, kDeviceWidth-100, 20)];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.textColor=[UIColor colorWithWhite:0.1 alpha:1.0];
    lblName.font=[UIFont boldSystemFontOfSize:15.0];
    [header addSubview:lblName];
    [tbGift setTableHeaderView:header];
	
	tbGift.contentInset=UIEdgeInsetsMake(-110, 0, 0, 0);
}

-(void)clickBack{
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)moreGift:(UIButton* )btn{
    //    PrivateImage *funInfo = [PrivateImage new];
    //    NSDictionary *dic = [self.curInfo.arrGift objectAtIndex:btn.tag-50];
    //    funInfo.UserId = [[dic objectForKey:@"userid"]intValue];
    //    funInfo.AvatarUrl = [dic objectForKey:@"headimage"];
    //    funInfo.UserName = [dic objectForKey:@"username"];
    [[HomeViewController shared] gotoGiftView:self.curInfo];
}
-(void)moreFan:(UIButton *)btn{
    
    PrivateImage *funInfo = [PrivateImage new];
    NSDictionary *dic = [arrItem objectAtIndex:btn.tag-50];
    funInfo.UserId = [[dic objectForKey:@"userid"]intValue];
    funInfo.AvatarUrl = [dic objectForKey:@"headimage"];
    funInfo.UserName = [dic objectForKey:@"username"];
    [[HomeViewController shared] gotoUserViewByImageInfo:funInfo];
}
#pragma mark - TableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrItem.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID=@"mycell";
  
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            UIButton* imgGift=[[UIButton alloc] initWithFrame:CGRectMake(260, 4, 32, 32)];
            [imgGift addTarget:self action:@selector(moreGift:) forControlEvents:UIControlEventTouchUpInside];
            imgGift.tag=40+indexPath.row;
            [cell addSubview:imgGift];
            
            UIButton* imgFan=[[UIButton alloc] initWithFrame:CGRectMake(6, 4, 32, 32)];
            imgFan.tag=50+indexPath.row;
            [imgFan addTarget:self action:@selector(moreFan:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:imgFan];
            
            UILabel* lbl=[[UILabel alloc] initWithFrame:CGRectMake(45, 0, 200, 40)];
            lbl.backgroundColor=[UIColor clearColor];
            lbl.tag=60+indexPath.row;
            lbl.font=[UIFont systemFontOfSize:14.0];
            [cell addSubview:lbl];
            
            UILabel* giftLbl=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 40)];
            giftLbl.backgroundColor=[UIColor clearColor];
            giftLbl.tag=70+indexPath.row;
            giftLbl.textAlignment = UITextAlignmentRight;
            giftLbl.font=[UIFont systemFontOfSize:14.0];
            [cell addSubview:giftLbl];
            
            UIView* giftline=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-20, 1)];
            giftline.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1.0];
            [cell addSubview:giftline];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        NSDictionary* info=arrItem[indexPath.row];
    
        NSLog(@"dict===%@",info);
        UIButton* imgGift_D=(UIButton*)[cell viewWithTag:40+indexPath.row];
        [imgGift_D setImageWithURL:[NSURL URLWithString:[info objectForKey:@"gphoto"]]];
        UIButton* imgFan_D=(UIButton*)[cell viewWithTag:50+indexPath.row];
        [imgFan_D setImageWithURL:[NSURL URLWithString:[info objectForKey:@"headimage"]]];
        UILabel* lbl_D=(UILabel*)[cell viewWithTag:60+indexPath.row];
        lbl_D.text=[info objectForKey:@"username"];
        UILabel* giftlbl_D=(UILabel*)[cell viewWithTag:70+indexPath.row];
        giftlbl_D.text=[info objectForKey:@"gname"];
        return cell;
   
  
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	int row=indexPath.row;
}

#pragma mark - Load Data
-(void)loadDataFromWeb{
	[AppHelper showHUD:@"刷新礼物列表..." baseview:self.view];
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
	[asirequest setPostValue:METHOD_MOREGIFTLIST forKey:@"method"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
    [asirequest setPostValue:[NSString stringWithFormat:@"%d", _curInfo.ImageId] forKey:@"photoid"];
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
           // [arrItem removeAllObjects];
            
            for (NSDictionary *di in data) {
                [arrItem addObject:di];
            }
            NSLog(@"arrItem===%@",arrItem);
            [tbGift reloadData];
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
-(void)stateChanged{
	NSString *tip=@"";
	switch (self.curInfo.State) {
		case PrivateImageStateNormal:
		case PrivateImageStateDownloading:
			tip=@"下载图片...";
			break;
		case PrivateImageStateDownloadFailed:
			tip=@"下载图片失败";
			break;
		default:
			tip=@"按住查看";
			break;
	}
	lblTip.text=tip;
}

#pragma mark - Click Event
-(void)longPressCell:(UILongPressGestureRecognizer*)gesture{
    //	DLog(@"longPressCell");
    if (self.curInfo.State==PrivateImageStateNormal || self.curInfo.State==PrivateImageStateDownloading) {
        return;
    }
	int second=[lblTimer.text integerValue];
	if (second<=0) {
		lblTimer.text=@"0";
		lblTimer.hidden=YES;
		return;
	}
	switch (gesture.state) {
		case UIGestureRecognizerStateBegan:
			[self CellLongPressBegan];
			break;
		case UIGestureRecognizerStateEnded:
			[self CellLongPressEnded];
			break;
		case UIGestureRecognizerStateCancelled:
			[self CellLongPressCancelled];
			break;
		default:
			break;
	}
	
}
#pragma mark - Long Press Event
-(void)CellLongPressBegan {
	
	//[btnTimer setTitle:[NSString stringWithFormat:@"%d秒",self.curInfo.Second] forState:UIControlStateNormal];
	bgPreview.hidden=NO;
	//	imgPreview.image=[UIImage imageWithContentsOfFile:url];
    [imgPreview setImageWithURL:[NSURL URLWithString:self.curInfo.ImageUrl]];
	
	if (self.timerCountDown) {
		[self.timerCountDown invalidate];
	}
	self.timerCountDown=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTimer) userInfo:nil repeats:YES];
}

-(void)CellLongPressEnded {
    //	if (self.timerCountDown) {
    //		[self.timerCountDown invalidate];
    //	}
	bgPreview.hidden=YES;
}

-(void)CellLongPressCancelled {
	if (self.timerCountDown) {
		[self.timerCountDown invalidate];
	}
	bgPreview.hidden=YES;
}

-(void)showTimer{
    //	if (bgPreview.hidden) {
    //		return;
    //	}
	int second=[[btnTimer.titleLabel.text stringByReplacingOccurrencesOfString:@"秒" withString:@""] intValue];
	second--;
	if (second<=0||self.curInfo.issee ==1) {
        if (self.timerCountDown) {
            [self.timerCountDown invalidate];
        }
		[btnTimer setTitle:@"0秒" forState:UIControlStateNormal];
		bgPreview.hidden=YES;
		lblTimer.text=@"0" ;
		lblTimer.hidden=YES;
        if ([self.curInfo.WatchDate length]==0) {
            lblTip.text=[NSString stringWithFormat:@"%@ - 已阅",[AppHelper getCurrentDate:@"yyyy-M-d HH:mm" ]]  ;
        }else
            lblTip.text=[NSString stringWithFormat:@"%@ - 已阅",self.curInfo.WatchDate];//[AppHelper getCurrentDate:@"yyyy-M-d HH:mm" ]]  ;
		lblTimer.text=@"";
		imgBubble.image=[UIImage imageNamed:@"status_opened_ico_gray"];
        if (self.curInfo.issee !=1) {
            [self pushData:self.curInfo celltag:0];
        }
		return;
	}
	else{
		[btnTimer setTitle:[NSString stringWithFormat:@"%d秒",second] forState:UIControlStateNormal];
		lblTimer.text=[NSString stringWithFormat:@"%d",second] ;
	}
}
-(void)pushData:(PrivateImage *)info celltag:(int)celltag{
    NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
    NSLog(@"info.ImageId===%d",info.ImageId);
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
        NSLog(@"JSON===%@",JSON);
        if (code==REQUEST_CODE_SUCCESS) {
            
            id coinData = [[JSON objectForKey:@"data"] objectForKey:@"coinData"];
            int remainCoin=[AppHelper getIntFromDictionary:coinData key:@"remainCoin"];
            
            
            if (remainCoin) {
                [AppHelper setIntConfig:confUserCoin val:remainCoin];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TO_TRENDS object:nil userInfo:nil];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
