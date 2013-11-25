//
//  DetailViewController.m
//  charmgram
//
//  Created by Rui Wei on 13-4-10.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "ReportViewController.h"
#import "GiftViewController.h"
#import "ChatViewController.h"
#import "UIButton+WebCache.h"
#import "MoreGiftViewController.h"
@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize curInfo,bubbleDelegate,timerCountDown;
- (void)viewDidLoad
{
    [super viewDidLoad];
	UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopbarHeight)];
    topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    
    lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(65, 10, kDeviceWidth-130, 24)];
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.shadowOffset=CGSizeMake(0, 1.0);
    lblTitle.shadowColor=SHADOW_COLOR;
    lblTitle.font=[UIFont boldSystemFontOfSize:18];
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
    [btnDone setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_off"] forState:UIControlStateNormal];
    [btnDone setBackgroundImage:[UIImage imageNamed:@"header_btn_cancel_on"] forState:UIControlStateHighlighted];
    [btnDone setTitle:@"更多" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.titleLabel.font=[UIFont boldSystemFontOfSize:12.0];
    btnDone.frame=CGRectMake(kDeviceWidth-64, 0, 52,44);
    [btnDone addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
    //[topbar addSubview:btnDone];
	
	tbContent=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, kDeviceHeight-108) style:UITableViewStylePlain];
	tbContent.dataSource=self;
	tbContent.delegate=self;
	tbContent.backgroundColor=[UIColor colorWithRed:234/255.0 green:230/255.0 blue:231/255.0 alpha:1.0];
    tbContent.separatorStyle=UITableViewCellSeparatorStyleNone;
	tbContent.frame=CGRectMake(0, 44, kDeviceWidth, kDeviceHeight-63);
    
	[self.view addSubview:tbContent];
    [self.view addSubview:topbar];
//    [self initToolbar];
	[self initHeader];
    [self initObservers];
	[self initPreview];
   
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

-(void)viewWillAppear:(BOOL)animated{ 
//    if (self.curInfo.UserId) {
//        [self loadData];
//    }else{
        [self getDataWithId:self.curInfo.ImageId];
 //   }
	[super viewWillAppear:animated];
}
-(void)loadData{
    lblViewCount.text=[NSString stringWithFormat:@"%d观看",self.curInfo.ViewCount];
     lblName.text=self.curInfo.UserName;
    if (self.curInfo.arrGift.count==3) {
        header.frame = CGRectMake(0, 0, kDeviceWidth, 240+44+50+3*40+40);
    }else{
        header.frame = CGRectMake(0, 0, kDeviceWidth, 240+44+50+self.curInfo.arrGift.count*40);
    }
     [btnLike setTitle:[NSString stringWithFormat:@"%d",self.curInfo.LikeCount] forState:UIControlStateNormal];
    [imgPhoto setImageWithURL:[NSURL URLWithString:self.curInfo.ThumbUrl]];
    lblCreateDate.text=[self.curInfo.CreatedDate compareDateAndDisplay:StandardDateTimeFormat];
	[imgAvatar setImageWithURL:[NSURL URLWithString:self.curInfo.AvatarUrl]];
	//lblTimer.text=[NSString stringWithFormat:@"%d",self.curInfo.Second];
	NSLog(@"issee===%d",self.curInfo.issee);
	[self showTimer];
    if (self.curInfo.issee!=1) {
        [self stateChanged];
        [self cacheWebImage];
    }
    for (int k=0; k<3; k++) {
        UIView* vwGift=[tbContent.tableHeaderView viewWithTag:30+k];
        if (k>=self.curInfo.arrGift.count) {
            vwGift.hidden=YES;
            continue;
        }
        vwGift.hidden=NO;
        NSDictionary* dict=self.curInfo.arrGift[k];
        UIButton* imgGift=(UIButton*)[vwGift viewWithTag:40+k];
        [imgGift setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"photo"]]];
        UIButton* imgFan=(UIButton*)[vwGift viewWithTag:50+k];
        [imgFan setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"headimage"]]];
        UILabel* lbl=(UILabel*)[vwGift viewWithTag:60+k];
        lbl.text=[dict objectForKey:@"username"];
        UILabel* giftlbl=(UILabel*)[vwGift viewWithTag:70+k];
        giftlbl.text=[dict objectForKey:@"name"];
    }
    UIButton *vwMore =(UIButton *) [tbContent.tableHeaderView viewWithTag:84];
    if (self.curInfo.arrGift.count< 3) {
        
        vwMore.hidden = YES;
    }else{
        
        vwMore.hidden = NO;
        
    }

//	for (int k=0; k<self.curInfo.LikeCount; k++) {
//        UserInfo *item=[[UserInfo alloc] init];
//        item.UserId=1000+k;
//        item.UserName=[NSString stringWithFormat:@"用户名%d",item.UserId];
//        item.AvatarURL=[NSString stringWithFormat:@"avatar%d.jpg",(item.UserId+3)%12];
//        [self.curInfo.arrLike addObject:item];
//    }
	
	
//	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"gift" ofType:@"plist"];
//    NSMutableArray* arrGift=[[NSMutableArray alloc] initWithContentsOfFile:plistPath];
//	
//    for (int k=0; k<self.curInfo.CommentCount; k++) {
//		NSDictionary* dict=(NSDictionary*)arrGift[(k+100)%15];
//        CommentInfo *item=[[CommentInfo alloc] init];
//        item.CommentID=1000+k;
//        item.UserName=[NSString stringWithFormat:@"用户名%d",item.CommentID];
//        item.AvatarURL=[NSString stringWithFormat:@"avatar%d.jpg",(item.CommentID+7)%12];
//        item.Text=[NSString stringWithFormat:@"评论评论...%d",item.CommentID];
//		item.GiftUrl=[dict objectForKey:@"imageUrl"];
//		item.GiftName=[dict objectForKey:@"name"];
//        [self.curInfo.arrGift addObject:item];
//    }
	[tbContent reloadData];
	
}
-(void)initToolbar{
    toolbar=[[UIImageView alloc] initWithFrame:CGRectMake(0, kDeviceHeight-69, kDeviceWidth, 49)];
    toolbar.image=[[UIImage imageNamed:@"feeddetail_toolbar_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:25];
    toolbar.userInteractionEnabled=YES;

//    UIView *toolbar=[[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight-69, kDeviceWidth, 49)];
//    toolbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"feeddetail_toolbar_bg"]];
    
    tvCommentBg=[[UIImageView alloc] initWithFrame:CGRectMake(48, 10, 252, 35)];
    tvCommentBg.image=[[UIImage imageNamed:@"feeddetail_toolbar_text_bg"] stretchableImageWithLeftCapWidth:17 topCapHeight:15];
    
    tvComment=[[UITextView alloc] initWithFrame:CGRectMake(58, 12, 232, 31)];
    tvComment.backgroundColor=[UIColor clearColor];
	
    tvComment.font=[UIFont systemFontOfSize:14.0];
    tvComment.returnKeyType=UIReturnKeySend;
	tvComment.delegate=self;
	tvComment.editable=YES; 
    tvComment.scrollEnabled=YES;
    tvComment.delegate=self;
    
    UILabel* lblcomment=[[UILabel alloc] initWithFrame:CGRectMake(5, 16, 40, 20)];
    lblcomment.textColor=[UIColor whiteColor];
    lblcomment.text=@"评论";
    lblcomment.font=[UIFont boldSystemFontOfSize:16.0];
    lblcomment.textAlignment=UITextAlignmentCenter;
    lblcomment.backgroundColor=[UIColor clearColor];
//    lblcomment.shadowColor=[UIColor blackColor];
//    lblcomment.shadowOffset=CGSizeMake(2.0, 2.0);
	
	commentMask=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    commentMask.backgroundColor=[UIColor clearColor];
    commentMask.hidden=YES;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentMask:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [commentMask addGestureRecognizer:tap];
	
	 [self.view addSubview:commentMask];
	[toolbar addSubview:tvCommentBg];
	[toolbar addSubview:tvComment];
	[toolbar addSubview:lblcomment];
	[self.view addSubview:toolbar];
	 
}

-(void)initObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)initHeader{
   
	header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 240+44+50)];
    NSLog(@"%d",self.curInfo.arrGift.count);
   // if (self.curInfo.arrGift.count==3) {
        header.frame = CGRectMake(0, 0, kDeviceWidth, 240+44+50+3*40+40);
//    }else{
//        header.frame = CGRectMake(0, 0, kDeviceWidth, 240+44+50+self.curInfo.arrGift.count*40);
//        NSLog(@"%f",header.frame.size.height);
//    }
	//header.backgroundColor=[UIColor redColor];
	
	imgSky=[[UIImageView alloc] initWithFrame:CGRectMake(0, 50, kDeviceWidth, 240)];
	imgSky.image=[UIImage imageNamed:@"item_bg310"];
	imgSky.contentMode=UIViewContentModeScaleAspectFill;
	imgSky.clipsToBounds=YES;
	imgSky.userInteractionEnabled=YES;
	[header addSubview:imgSky];
	
	UILongPressGestureRecognizer *longGR=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCell:)];
	longGR.numberOfTouchesRequired=1;
	longGR.minimumPressDuration=0.2;
	[imgSky addGestureRecognizer:longGR];

	imgPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(129, 80, 72, 72)];
	imgPhoto.contentMode=UIViewContentModeScaleAspectFill;
    imgPhoto.layer.cornerRadius = 36;
    imgPhoto.layer.borderWidth=3;
    imgPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
    imgPhoto.layer.masksToBounds = YES;
	[imgSky addSubview:imgPhoto];
	
    btnLike=[UIButton buttonWithType:UIButtonTypeCustom];
    if (self.curInfo.isLiked) {
        [btnLike setBackgroundImage:[UIImage imageNamed:@"feeddetail_like_btn"] forState:UIControlStateNormal];
        [btnLike setBackgroundImage:[UIImage imageNamed:@"feeddetail_unlike_btn"] forState:UIControlStateHighlighted];
    }
    else{
        [btnLike setBackgroundImage:[UIImage imageNamed:@"feeddetail_unlike_btn"] forState:UIControlStateNormal];
        [btnLike setBackgroundImage:[UIImage imageNamed:@"feeddetail_like_btn"] forState:UIControlStateHighlighted];
    }
    [btnLike setTitle:[NSString stringWithFormat:@"%d",self.curInfo.LikeCount] forState:UIControlStateNormal];
    [btnLike setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btnLike.titleLabel.font=[UIFont boldSystemFontOfSize:12.0];
    btnLike.frame=CGRectMake(6, kDeviceWidth-130, 45,43);
    [btnLike addTarget:self action:@selector(clickLike) forControlEvents:UIControlEventTouchUpInside];
    [imgSky addSubview:btnLike];
	
	lblTip=[[UILabel alloc] initWithFrame:CGRectMake(10, kDeviceWidth-110, kDeviceWidth-23, 20)];
	lblTip.font=[UIFont systemFontOfSize:12.0];
	lblTip.textAlignment=UITextAlignmentRight;
	lblTip.backgroundColor=[UIColor clearColor];
	lblTip.text=@"按住查看";
	lblTip.textColor=[UIColor grayColor];
	[imgSky addSubview:lblTip];
	
	imgBubble=[[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-40, 10, 30, 31)];
	imgBubble.image=[UIImage imageNamed:@"status_paopao_ico"];
	[imgSky addSubview:imgBubble];
	
	lblTimer=[[UILabel alloc] initWithFrame:CGRectMake(0, 3, 30, 20)];
	lblTimer.font=[UIFont boldSystemFontOfSize:13.0];
	lblTimer.textAlignment=UITextAlignmentCenter;
	lblTimer.backgroundColor=[UIColor clearColor];
	lblTimer.textColor=[UIColor whiteColor];
	lblTimer.shadowColor=SHADOW_COLOR;
	lblTimer.shadowOffset=CGSizeMake(1, 1);
	[imgBubble addSubview:lblTimer];
    

    
    UIView* topLine=[[UIView alloc] initWithFrame:CGRectMake(0, 52, kDeviceWidth, 5)];
    topLine.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"table_section_shadow"]];
    [header addSubview:topLine];
    
    UIView* userbar=[[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth, 50)];
    userbar.backgroundColor=[UIColor whiteColor];
    [header addSubview:userbar];
    
	UITapGestureRecognizer* tapUserbar=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserBar)];
	tapUserbar.numberOfTapsRequired=1;
	tapUserbar.numberOfTouchesRequired=1;
	[userbar addGestureRecognizer:tapUserbar];
   
    imgAvatar=[[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 30, 30)];
    imgAvatar.contentMode=UIViewContentModeScaleAspectFill;
	imgAvatar.clipsToBounds=YES;
    [imgAvatar setImage:[UIImage imageNamed:self.curInfo.AvatarUrl]];
    [userbar addSubview:imgAvatar];
    
    UIImageView* imgmsk=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatarmask_small_gray"]];
    imgmsk.frame=CGRectMake(13, 9, 32, 32);
    imgmsk.contentMode=UIViewContentModeScaleToFill;
    [userbar addSubview:imgmsk];
    
    lblCreateDate=[[UILabel alloc] initWithFrame:CGRectMake(55, 5, kDeviceWidth-120, 20)];
    lblCreateDate.backgroundColor=[UIColor clearColor];
    lblCreateDate.textColor=[UIColor grayColor];
    lblCreateDate.font=[UIFont systemFontOfSize:10.0];
    [userbar addSubview:lblCreateDate];
    
    
    lblViewCount=[[UILabel alloc] initWithFrame:CGRectMake(150, 27, kDeviceWidth-170, 20)];
    lblViewCount.backgroundColor=[UIColor clearColor];
    lblViewCount.font=[UIFont systemFontOfSize:10.0];
    lblViewCount.textColor=[UIColor lightGrayColor];
    lblViewCount.textAlignment=UITextAlignmentRight;
    [userbar addSubview:lblViewCount];
    
    lblName=[[UILabel alloc] initWithFrame:CGRectMake(55, 18, kDeviceWidth-120, 30)];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.textColor=[UIColor colorWithWhite:0.1 alpha:1.0];
    lblName.font=[UIFont systemFontOfSize:12.0];
    lblName.text=self.curInfo.UserName;
//    lblName.shadowColor=[UIColor colorWithWhite:0.2 alpha:1.0];
//    lblName.shadowOffset=CGSizeMake(2.0, 2.0);
    [userbar addSubview:lblName];
    
    viewBg=[[UIView alloc] initWithFrame:CGRectMake(0,290, kDeviceWidth, 44)];
    viewBg.backgroundColor=[UIColor whiteColor];
    viewBg.layer.cornerRadius=3.0;
    viewBg.userInteractionEnabled = YES;
    viewBg.layer.masksToBounds=YES;
    [header addSubview:viewBg];
    
    
    NSArray* arrImg=@[@"toolbar_like",@"toolbar_msg",@"toolbar_gift",@"toolbar_comment",@"toolbar_more"];
    for (int k=0; k<arrImg.count; k++) {
        NSString* imgname=arrImg[k];
        UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imgname]  forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_h",imgname]] forState:UIControlStateHighlighted];
        btn.tag=300+k;
        btn.frame=CGRectMake(k*60, 3,60, 37);
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [viewBg addSubview:btn];
    }
    CGRect newframe=imgSky.frame;
    newframe=viewBg.frame;
    
    for (int k=0; k<3; k++) {
        UIView* vwGift=[[UIView alloc] initWithFrame:CGRectMake(0, newframe.origin.y+newframe.size.height+40*k, kDeviceWidth, 40)];
        vwGift.backgroundColor=[UIColor whiteColor];
        vwGift.tag=30+k;
        [header addSubview:vwGift];
        
        UIButton* imgGift=[[UIButton alloc] initWithFrame:CGRectMake(260, 4, 32, 32)];
        [imgGift addTarget:self action:@selector(showMoreGift:) forControlEvents:UIControlEventTouchUpInside];
        imgGift.tag=40+k;
        
        UIButton* imgFan=[[UIButton alloc] initWithFrame:CGRectMake(6, 4, 32, 32)];
        imgFan.tag=50+k;
        [imgFan addTarget:self action:@selector(moreFan:) forControlEvents:UIControlEventTouchUpInside];
        UILabel* lbl=[[UILabel alloc] initWithFrame:CGRectMake(45, 0, 200, 40)];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.tag=60+k;
        lbl.font=[UIFont systemFontOfSize:14.0];
        
        UILabel* giftLbl=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 40)];
        giftLbl.backgroundColor=[UIColor clearColor];
        giftLbl.tag=70+k;
        giftLbl.textAlignment = UITextAlignmentRight;
        giftLbl.font=[UIFont systemFontOfSize:14.0];
        
        UIView* giftline=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-20, 1)];
        giftline.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1.0];
        
        [vwGift addSubview:imgFan];
        [vwGift addSubview:imgGift];
        [vwGift addSubview:lbl];
        [vwGift addSubview:giftLbl];
        [vwGift addSubview:giftline];
    }
    UIButton* vwMore=[[UIButton alloc] initWithFrame:CGRectMake(10, newframe.origin.y+newframe.size.height+40*3, kDeviceWidth-20, 40)];
    [vwMore setTitle:@"显示更多" forState:UIControlStateNormal];
    [vwMore.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [vwMore setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    vwMore.backgroundColor=[UIColor clearColor];
    vwMore.tag=80+4;
    [vwMore addTarget:self action:@selector(showMoreGift:) forControlEvents:UIControlEventTouchUpInside];
    vwMore.hidden = NO;
    [header addSubview:vwMore];
//    UIView *botLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, kDeviceWidth+52, kDeviceWidth, 1.0f)];
//    botLine.backgroundColor = [UIColor colorWithRed:(227/255.0f) green:(224/255.0f) blue:(221/255.0f) alpha:1.0f];
//    [header addSubview:botLine];
//    
//    UIView *botLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, kDeviceWidth+53, kDeviceWidth, 1.0f)];
//    botLine2.backgroundColor = [UIColor colorWithRed:(239/255.0f) green:(235/255.0f) blue:(234/255.0f) alpha:1.0f];
//    [header addSubview:botLine2];
//	
    
    
    [tbContent setTableHeaderView:header];
    
//    viewBg=[[UIView alloc] initWithFrame:CGRectMake(10, kDeviceWidth-30, kDeviceWidth-20, 90)];
//    viewBg.backgroundColor=[UIColor whiteColor];
//    viewBg.layer.cornerRadius=3.0;
//    viewBg.layer.masksToBounds=YES;
//    [imgSky addSubview:viewBg];
//    CGRect newframe=imgSky.frame;
//    viewBg.frame=CGRectMake(10, newframe.origin.y+newframe.size.height, kDeviceWidth-20, 45);
//    
//    NSArray* arrImg=@[@"toolbar_like",@"toolbar_msg",@"toolbar_gift",@"toolbar_comment",@"toolbar_more"];
//    for (int k=0; k<arrImg.count; k++) {
//        NSString* imgname=arrImg[k];
//        UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setBackgroundImage:[[UIImage imageNamed:imgname] stretchableImageWithLeftCapWidth:5 topCapHeight:0 ] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_h",imgname]] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
//        btn.tag=300+k;
//        btn.frame=CGRectMake(k*60, 3,60, 37);
//        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
//        [viewBg addSubview:btn];
//    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Web Data
-(void)cacheWebImage{
    SDWebImageManager *sdmanager = [SDWebImageManager sharedManager];
    [sdmanager downloadWithURL:[NSURL URLWithString:self.curInfo.ImageUrl]
                      delegate:self
                       options:SDWebImageRetryFailed
                       success:^(UIImage *image) {
                           self.curInfo.State=PrivateImageStateDownloaded;
						   [self stateChanged];
                       }
                       failure:^(NSError *error) {
                           self.curInfo.State=PrivateImageStateDownloadFailed;
						   [self stateChanged];
                       }];
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

-(void)clickUserBar{
	[[HomeViewController shared] gotoUserViewByImageInfo:self.curInfo];
}

-(void)clickBack{
   
	[self.navigationController popViewControllerAnimated:YES];
    // [[HomeViewController shared] refleshFujin];
}

-(void)clickMore{
	UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信分享给好友", @"举报该内容",nil];
	
	sheet.tag=100;
	[sheet showInView: self.view];
}
-(void)clickButton:(UIButton*)btn{
    int userid = [AppHelper getIntConfig:confUserId];
    if (!userid) {
        [AppHelper showAlertMessage:@"请先登录！"];
        return;
    }
	int itag=btn.tag-300;
	[self clickImageToolbar:self.curInfo itag:itag];
}
-(void)showMoreGift:(UIButton *)btn{
    MoreGiftViewController* controller=[[MoreGiftViewController alloc] init];
    controller.curInfo=self.curInfo;
    //[[HomeViewController shared] presentViewController:controller animated:YES completion:nil];
    [self.navigationController pushViewController:controller animated:YES];
}
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
            self.curInfo.LikeCount  = info.LikeCount;
            [self loadData];
			[tbContent reloadData];
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
		}
			break;
    }
}
-(void)moreFan:(UIButton *)btn{
    
    PrivateImage *funInfo = [PrivateImage new];
    NSDictionary *dic = [self.curInfo.arrGift objectAtIndex:btn.tag-50];
    funInfo.UserId = [[dic objectForKey:@"userid"]intValue];
    funInfo.AvatarUrl = [dic objectForKey:@"headimage"];
    funInfo.UserName = [dic objectForKey:@"username"];
    [[HomeViewController shared] gotoUserViewByImageInfo:funInfo];
}
-(void)clickLike{

}

-(void)gotoLikeList{

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (actionSheet.tag==100 ) {
        if (buttonIndex == 0) {
            ReportViewController* controller=[[ReportViewController alloc] init];
            controller.curImageId=self.curInfo.ImageId;
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
                
                [[AppDelegate App] sendAppImg:WXSceneSession withTitle:self.curInfo.UserName  withContent:self.curInfo.ThumbUrl withThumbImg:self.curInfo.ThumbUrl];
            }
                break;
            case 2:{
                [[AppDelegate App] sendAppImg:WXSceneTimeline withTitle:self.curInfo.UserName  withContent:self.curInfo.ThumbUrl withThumbImg:self.curInfo.ThumbUrl];
                
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark- sina share
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
    NSString *str = [NSString stringWithFormat:@"%@ 的靓图,%@%@",[self.curInfo.UserName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"去”泡泡美女”查看大图和更多！",SHAREAPPURL];
    // NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
    NSData *dataObj = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.curInfo.ThumbUrl]];
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
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 240+44+50;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 0;//self.curInfo.arrGift.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString* cellId=@"mycell";
	CommentCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
	if (!cell) {
		cell=[[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
	}
	int row=indexPath.row;
    NSLog(@"arrgift====%@",[self.curInfo.arrGift objectAtIndex:row]);
	CommentInfo* info= (CommentInfo*)[self.curInfo.arrGift objectAtIndex:row];
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	[cell loadData:info];
	return cell;
}

//#pragma mark - ActionSheet Delegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//	switch (buttonIndex) {
//		case 0:
//        {
//             [[AppDelegate App] sendAppImg:WXSceneSession withTitle:curInfo.UserName  withContent:curInfo.ImageUrl withThumbImg:curInfo.ThumbUrl];
//        }
//			break;
//		case 1:
//		{
//			ReportViewController* controller=[[ReportViewController alloc] init];
//			controller.curImageId=self.curInfo.ImageId;
//			[[HomeViewController shared] presentViewController:controller animated:YES completion:nil];
//		}
//			break;
//		default:
//			break;
//	}
//}

#pragma mark - Keyboard Events

- (void)keyboardWillShow:(NSNotification *)notification {
    if ([tvComment isFirstResponder]) {
        NSDictionary *info = [notification userInfo];
        CGRect kbFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        keyboardTop = kbFrame.origin.y;
        int barHeight=toolbar.frame.size.height;
		int newH= keyboardTop - barHeight - StatusBarHeight ;
		DLog(@"%d",newH);
        [UIView animateWithDuration:0.25 animations:^{
            toolbar.frame = CGRectMake(0, newH, kDeviceWidth, barHeight);
        }];
        commentMask.hidden=NO;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if ([tvComment isFirstResponder]) {
        NSDictionary *info = [notification userInfo];
        CGRect kbFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        keyboardTop = kbFrame.origin.y;
        int barHeight=toolbar.frame.size.height;
        [UIView animateWithDuration:0.25 animations:^{
            toolbar.frame = CGRectMake(0, kDeviceHeight - barHeight -StatusBarHeight , kDeviceWidth, barHeight);
        }];
        commentMask.hidden=YES;
    }
}

-(void)tapCommentMask:(UITapGestureRecognizer*)gesture{
    [self hideKeyboard];
}

-(void)hideKeyboard{
	[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - UITextView delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
//        [self clickComment];
		[self hideKeyboard];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
	//    CGFloat fontHeight = (textView.font.ascender - textView.font.descender) + 1;
    CGFloat contentHeight=textView.contentSize.height;
    int newHeight=contentHeight;
    if (contentHeight >= MaxTextViewHeight)
    {
        /* Enable vertical scrolling */
        if(!textView.scrollEnabled)
        {
            textView.scrollEnabled = YES;
            [textView flashScrollIndicators];
        }
		[textView scrollRectToVisible:CGRectMake(0, textView.contentSize.height-MaxTextViewHeight, 232, MaxTextViewHeight) animated:YES];
        newHeight=MaxTextViewHeight;
    }
    else
    {
        textView.scrollEnabled = NO;
    }
    int barHeight=newHeight + 14;
    NSLog(@"keyboardTop - %d ; barHeight- %d ",keyboardTop,barHeight);
    [UIView animateWithDuration:0.15 animations:^{
        toolbar.frame = CGRectMake(0, keyboardTop - barHeight - StatusBarHeight , kDeviceWidth, barHeight);
        textView.frame = CGRectMake(58, 12, 232, newHeight);
 
        tvCommentBg.frame=CGRectMake(48, 10, 252, newHeight+4);
    } ];
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
-(void)getDataWithId:(int)pid{
    [AppHelper showHUD:@"数据加载中" baseview:self.view];
    int userid=[AppHelper getIntConfig:confUserId];
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    [asirequest setPostValue:@"getimgInfoByid" forKey:@"method"];
    
    [asirequest setPostValue:[NSString stringWithFormat:@"%d", userid] forKey:@"userid"];
    [asirequest setPostValue:[NSString stringWithFormat:@"%d", pid] forKey:@"sid"];
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
            NSLog(@"respstring===%@",respString);
            PrivateImage *privateImg = [[PrivateImage alloc] initWithDict:data];
            self.curInfo = privateImg;
            [self loadData];
            [tbContent reloadData];
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
@end
