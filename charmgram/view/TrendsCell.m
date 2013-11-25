//
//  TrendsCell.m
//  charmgram
//
//  Created by Rain on 13-6-6.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "TrendsCell.h"
#import "NSStringAdditions.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "AppHelper.h"
#import "HomeViewController.h"
@implementation TrendsCell
@synthesize toolbarDelegate,bubbleDelegate,curInfo,timerCountDown,row;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		//			self.contentView.backgroundColor=[UIColor whiteColor];
		UIImageView* imgBg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
		imgBg.image=[[UIImage imageNamed:@"feeds_post_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:35];
		self.backgroundView=imgBg;

		UIImageView* imgBg1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
		imgBg1.image=[[UIImage imageNamed:@"feeds_post_bg_h"] stretchableImageWithLeftCapWidth:0 topCapHeight:35];
		self.selectedBackgroundView=imgBg1;
		
		imgLine=[[UIView alloc] initWithFrame:CGRectMake(159, 0, 2, 10)];
		imgLine.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"feeds_timeline_seperator"]];
		
		viewBg=[[UIView alloc] initWithFrame:CGRectMake(10, kDeviceWidth-30, kDeviceWidth-20-20, 90)];
		viewBg.backgroundColor=[UIColor whiteColor];
		viewBg.layer.cornerRadius=3.0;
		viewBg.layer.masksToBounds=YES;
		[self.contentView addSubview:viewBg];
		
		int cutted=0;
		hideUserInfo=NO;
		if (style==UITableViewCellStyleDefault) {
			lblCreateDate=[[UILabel alloc] initWithFrame:CGRectMake(50, 12, kDeviceWidth-75, 20)];
			lblCreateDate.backgroundColor=[UIColor clearColor];
			lblCreateDate.font=[UIFont systemFontOfSize:10.0];
			lblCreateDate.textColor=[UIColor lightGrayColor];
			lblCreateDate.userInteractionEnabled=YES;
			
			UITapGestureRecognizer* tapGesture1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUser:)];
			tapGesture1.numberOfTapsRequired=1;
			tapGesture1.numberOfTouchesRequired=1;
			[lblCreateDate addGestureRecognizer:tapGesture1];
			
			lblViewCount=[[UILabel alloc] initWithFrame:CGRectMake(150, 27, kDeviceWidth-170, 20)];
			lblViewCount.backgroundColor=[UIColor clearColor];
			lblViewCount.font=[UIFont systemFontOfSize:10.0];
			lblViewCount.textColor=[UIColor lightGrayColor];
			lblViewCount.textAlignment=UITextAlignmentRight;
			
			lblNickName=[[UILabel alloc] initWithFrame:CGRectMake(50, 27, kDeviceWidth-75, 20)];
			lblNickName.backgroundColor=[UIColor clearColor];
			lblNickName.font=[UIFont systemFontOfSize:12.0];
			lblNickName.userInteractionEnabled=YES;
			
			UITapGestureRecognizer* tapGesture0=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUser:)];
			tapGesture0.numberOfTapsRequired=1;
			tapGesture0.numberOfTouchesRequired=1;
			[lblNickName addGestureRecognizer:tapGesture0];
			
			UIView* imgAvatarMask=[[UIView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
			imgAvatarMask.backgroundColor=[UIColor whiteColor];
			imgAvatarMask.layer.cornerRadius=2;
			imgAvatarMask.userInteractionEnabled=YES;
			imgAvatarMask.tag=500;
			
			imgAvatar=[[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 28, 28)];
			imgAvatar.userInteractionEnabled=YES;
			imgAvatar.tag=550;
			[imgAvatarMask addSubview:imgAvatar];
			
			UITapGestureRecognizer* tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUser:)];
			tapGesture.numberOfTapsRequired=1;
			tapGesture.numberOfTouchesRequired=1;
			[imgAvatar addGestureRecognizer:tapGesture];
			
			[self.contentView addSubview:imgAvatarMask];
			[self.contentView addSubview:lblViewCount];
			[self.contentView addSubview:lblCreateDate];
			[self.contentView addSubview:lblNickName];
		}
		else{
			cutted=40;
			hideUserInfo=YES;
		}
		
		UIImageView* imgSky=[[UIImageView alloc] initWithFrame:CGRectMake(10, 50-cutted, kDeviceWidth-20, 220-7)];
		imgSky.contentMode=UIViewContentModeScaleAspectFill;
		imgSky.clipsToBounds=YES;
		imgSky.image=[UIImage imageNamed:@"item_bg310"];
		imgSky.userInteractionEnabled=YES;
		
		UILongPressGestureRecognizer *longGR=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCell:)];
		longGR.numberOfTouchesRequired=1;
		longGR.minimumPressDuration=0.5;
		[imgSky addGestureRecognizer:longGR];
		
		imgBubble=[[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-60, 10, 30, 31)];
		imgBubble.image=[UIImage imageNamed:@"status_paopao_ico"];
		[imgSky addSubview:imgBubble];
		
		btnLike=[UIButton buttonWithType:UIButtonTypeCustom];
		if (self.curInfo.isLiked) {
			[btnLike setBackgroundImage:[UIImage imageNamed:@"feeddetail_like_btn"] forState:UIControlStateNormal];
			[btnLike setBackgroundImage:[UIImage imageNamed:@"feeddetail_unlike_btn"] forState:UIControlStateHighlighted];
			[btnLike setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		}
		else{
			[btnLike setBackgroundImage:[UIImage imageNamed:@"feeddetail_unlike_btn"] forState:UIControlStateNormal];
			[btnLike setBackgroundImage:[UIImage imageNamed:@"feeddetail_like_btn"] forState:UIControlStateHighlighted];
			[btnLike setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		}
		[btnLike setTitle:[NSString stringWithFormat:@"%d",self.curInfo.LikeCount] forState:UIControlStateNormal];
		btnLike.titleLabel.font=[UIFont boldSystemFontOfSize:12.0];
		btnLike.frame=CGRectMake(5, kDeviceWidth-130-27, 45,43);
		[btnLike addTarget:self action:@selector(clickLike) forControlEvents:UIControlEventTouchUpInside];
		btnLike.enabled=NO;
		[imgSky addSubview:btnLike];

		
		lblTimer=[[UILabel alloc] initWithFrame:CGRectMake(-1, 4, 30, 20)];
		lblTimer.font=[UIFont boldSystemFontOfSize:13.0];
		lblTimer.textAlignment=UITextAlignmentCenter;
		lblTimer.backgroundColor=[UIColor clearColor];
		lblTimer.textColor=[UIColor whiteColor];
		lblTimer.shadowColor=SHADOW_COLOR;
		lblTimer.shadowOffset=CGSizeMake(1, 1);
		[imgBubble addSubview:lblTimer];
		
		lblTip=[[UILabel alloc] initWithFrame:CGRectMake(10, kDeviceWidth-110-27, kDeviceWidth-43, 20)];
		lblTip.font=[UIFont systemFontOfSize:12.0];
		lblTip.textAlignment=UITextAlignmentRight;
		lblTip.backgroundColor=[UIColor clearColor];
		lblTip.text=@"按住查看";
		lblTip.textColor=[UIColor grayColor];
		[imgSky addSubview:lblTip];
		
		imgThumb=[[UIImageView alloc] initWithFrame:CGRectMake(129, 135-cutted-20, 72, 72)];
        imgThumb.layer.cornerRadius = 36;
        imgThumb.layer.borderWidth=3;
        imgThumb.layer.borderColor = [UIColor whiteColor].CGColor;
		imgThumb.contentMode=UIViewContentModeScaleAspectFill;
		imgThumb.layer.masksToBounds = YES;
		CGRect newframe=imgSky.frame;
		viewBg.frame=CGRectMake(10, newframe.origin.y+newframe.size.height, kDeviceWidth-20, 45);
		
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
		
		UIImageView* imgMsk=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feeds_photo_mask"]];
		imgMsk.frame=CGRectMake(10, 10, kDeviceWidth-20, 3);
		
		botMsk=[[UIView alloc] initWithFrame:CGRectMake(10, kDeviceWidth-32-cutted-27, kDeviceWidth-20, 2)];
		botMsk.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2];
		
        newframe=viewBg.frame;
        
        for (int k=0; k<3; k++) {
            UIView* vwGift=[[UIView alloc] initWithFrame:CGRectMake(10, newframe.origin.y+newframe.size.height+40*k, kDeviceWidth-20, 40)];
            vwGift.backgroundColor=[UIColor whiteColor];
            vwGift.tag=30+k;
            [self.contentView addSubview:vwGift];
            
            UIButton* imgGift=[[UIButton alloc] initWithFrame:CGRectMake(260, 4, 32, 32)];
            [imgGift addTarget:self action:@selector(moreGift:) forControlEvents:UIControlEventTouchUpInside];
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
        UIButton* vwMore=[[UIButton alloc] initWithFrame:CGRectMake(10, newframe.origin.y+newframe.size.height+40*3, kDeviceWidth-20, 30)];
        [vwMore setTitle:@"显示更多" forState:UIControlStateNormal];
        [vwMore.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [vwMore setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
        vwMore.backgroundColor=[UIColor clearColor];
        vwMore.tag=80+4;
        [vwMore addTarget:self action:@selector(showMoreGift:) forControlEvents:UIControlEventTouchUpInside];
        vwMore.hidden = NO;
        [self.contentView addSubview:vwMore];
		//        [self.contentView addSubview:imgLine];
		[self.contentView addSubview:imgSky];
		[self.contentView addSubview:imgThumb];
		[self.contentView addSubview:botMsk];
		[self.contentView addSubview:imgMsk];
	}
	return self;
 
}

-(void)refreshData{
	if (self.curInfo) {
		[self loadData:self.curInfo];
	}
}
-(void)refreshSecond:(int)Second{
    lblTimer.text=[NSString stringWithFormat:@"%d",Second];
}
-(void)loadData:(PrivateImage*)info{
    NSLog(@"WatchDate====%@",info.WatchDate);
	self.curInfo=info; 
	lblTimer.text=[NSString stringWithFormat:@"%d",info.Second];
	if (info.issee==1||info.Second <=0) {
		lblTip.text=[NSString stringWithFormat:@"%@ - 已阅",info.WatchDate];//[AppHelper getCurrentDate:@"yyyy年M月d日 HH:mm" ]]  ;
		lblTimer.text=@"";
		imgBubble.image=[UIImage imageNamed:@"status_opened_ico_gray"];
	}
	else{
		NSString *tip=@"";
		switch (info.State) {
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
		imgBubble.image=[UIImage imageNamed:@"status_paopao_ico"];
	}
	
	btnLike.titleLabel.text=[NSString stringWithFormat:@"%d",info.LikeCount];
	if (info.isLiked) {
		[btnLike setBackgroundImage:[UIImage imageNamed:@"feeddetail_like_btn"] forState:UIControlStateNormal];
		[btnLike setBackgroundImage:[UIImage imageNamed:@"feeddetail_unlike_btn"] forState:UIControlStateHighlighted];
		[btnLike setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	else{
		[btnLike setBackgroundImage:[UIImage imageNamed:@"feeddetail_unlike_btn"] forState:UIControlStateNormal];
		[btnLike setBackgroundImage:[UIImage imageNamed:@"feeddetail_like_btn"] forState:UIControlStateHighlighted];
		[btnLike setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	}
	btnLike.titleLabel.text=[NSString stringWithFormat:@"%d",info.LikeCount];
	[imgThumb setImageWithURL:[NSURL URLWithString:info.ThumbUrl] placeholderImage:[UIImage imageNamed:@"thumb_pic"]];
    [imgAvatar setImageWithURL:[NSURL URLWithString:info.AvatarUrl] placeholderImage:[UIImage imageNamed:@"thumb_pic"]];
    lblViewCount.text=[NSString stringWithFormat:@"%d观看",info.ViewCount];
    NSLog(@"info.CreatedDate====%@",info.CreatedDate);
    lblCreateDate.text=[info.CreatedDate compareDateAndDisplay:@"yyyy-MM-dd HH:mm:ss"];
	lblNickName.text=info.UserName;
    for (int k=0; k<3; k++) {
        UIView* vwGift=[self.contentView viewWithTag:30+k];
        if (k>=self.curInfo.arrGift.count) {
            vwGift.hidden=YES;
            continue;
        }
        vwGift.hidden=NO;
        NSDictionary* dict=info.arrGift[k];
        UIButton* imgGift=(UIButton*)[vwGift viewWithTag:40+k];
        [imgGift setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"photo"]]];
        UIButton* imgFan=(UIButton*)[vwGift viewWithTag:50+k];
        [imgFan setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"headimage"]]];
        UILabel* lbl=(UILabel*)[vwGift viewWithTag:60+k];
        lbl.text=[dict objectForKey:@"username"];
        UILabel* giftlbl=(UILabel*)[vwGift viewWithTag:70+k];
        giftlbl.text=[dict objectForKey:@"name"];
    }
     UIButton *vwMore =(UIButton *) [self.contentView viewWithTag:84];
    if (self.curInfo.arrGift.count< 3) {
       
        vwMore.hidden = YES;
    }else{
   
        vwMore.hidden = NO;
   
    }
//	lblTip.hidden=(info.UserId==userid);
//	viewBg.hidden=(info.UserId==userid);
//	imgBubble.hidden=(info.UserId==userid);
//	btnLike.hidden=(info.UserId==userid);
//	if (info.UserId==userid) {
//		imgThumb.frame=CGRectMake(8, 8, kDeviceWidth-16, kDeviceWidth-36);
//		[imgThumb setImageWithURL:[NSURL URLWithString:info.ImageUrl]];
//	}
//	else{
//		
//		imgThumb.frame=CGRectMake(140, 100, kDeviceWidth-280, kDeviceWidth-280);
//		[imgThumb setImageWithURL:[NSURL URLWithString:info.ThumbUrl]];
//	}
}
 
-(void)layoutSubviews{
//    int frameHeight=self.frame.size.height;
//    CGRect newframe =viewBg.frame;
//    newframe.size.height=frameHeight-kDeviceWidth+20;
//	newframe.origin.y= kDeviceWidth-30-(hideUserInfo?40:0);
//    viewBg.frame=newframe;
    [super layoutSubviews];
}

#pragma mark - Action Events
-(void)showMoreGift:(UIButton *)btn{
    [[HomeViewController shared] gotoMoreGiftView:self.curInfo];
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
    NSDictionary *dic = [self.curInfo.arrGift objectAtIndex:btn.tag-50];
    funInfo.UserId = [[dic objectForKey:@"userid"]intValue];
    funInfo.AvatarUrl = [dic objectForKey:@"headimage"];
    funInfo.UserName = [dic objectForKey:@"username"];
    [[HomeViewController shared] gotoUserViewByImageInfo:funInfo];
}
-(void)clickButton:(UIButton*)btn{
     int userid = [AppHelper getIntConfig:confUserId];
    if (!userid) {
        [AppHelper showAlertMessage:@"请先登录！"];
        return;
    }
	int itag=btn.tag-300;
	if (self.toolbarDelegate && [self.toolbarDelegate conformsToProtocol:@protocol(ImageToolbarDelegate)]&&self.curInfo) {
        
		[self.toolbarDelegate clickImageToolbar:self.curInfo itag:itag];
	}
}

-(void)clickLike{

}

-(void)tapUser:(UITapGestureRecognizer*)gesture{
	[[HomeViewController shared] gotoUserViewByImageInfo:self.curInfo];
}

-(void)longPressCell:(UILongPressGestureRecognizer*)gesture{
   
  
    int userid = [AppHelper getIntConfig:confUserId];
    if (!userid) {
        if( gesture.state ==UIGestureRecognizerStateBegan){
            if ([AppDelegate App].watchCount <9) {
                //[AppDelegate App].watchCount++;
            }else{
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                                   message:@"新账号登录，马上免费获得100靓点，可以查看100张泡泡靓照！"
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                [alertView show];
                 return;
            }
        }
    }
   
    //	DLog(@"longPressCell");
	int itag=gesture.view.tag;
	int k=itag-TAGOFFSET_MASK;
//	int userid=[AppHelper getIntConfig:confUserId];
//	if(self.curInfo.UserId==userid){
//		return;
//	}
	//	UILabel* lblsec=(UILabel*)[self.contentView viewWithTag:TAGOFFSET_SECOND];
	//	UIImageView* imgLock=(UIImageView*)[self.contentView viewWithTag:TAGOFFSET_LOCK+k];
    if (self.curInfo.State==PrivateImageStateNormal || self.curInfo.State==PrivateImageStateDownloading) {
        if (self.curInfo.State == PrivateImageStateDownloading) {
            self.curInfo.State = PrivateImageStateDownloaded;
            [self refreshData];
        }
       // [self.bubbleDelegate CellAddDownItem:self.curInfo];
        return;
    }
    if(self.curInfo.State == PrivateImageStateDownloadFailed){
        self.curInfo.State = PrivateImageStateNormal;
        [self refreshData];
        return;
    }
   
	int second=[lblTimer.text integerValue];
	if (second<=0) {
		lblTimer.text=@"0";
		lblTimer.hidden=YES;
		return;
	}
	if (self.bubbleDelegate && [self.bubbleDelegate conformsToProtocol:@protocol(BubbleCellDelegate) ]) {
		NSDictionary * dict=[NSDictionary dictionaryWithObjectsAndKeys:
							 self.curInfo.ImageUrl,@"url",
							 [NSString stringWithFormat:@"%d",self.curInfo.Second],@"second",
                             [NSString stringWithFormat:@"%d",self.row],@"row",
							 [NSString stringWithFormat:@"%d",self.tag],@"tag",
							 [NSString stringWithFormat:@"%d",k],@"col",[NSString stringWithFormat:@"%d",self.curInfo.UserId],@"curId",
							 nil];
		switch (gesture.state) {
			case UIGestureRecognizerStateBegan:
				[self.bubbleDelegate CellLongPressBegan:dict];
				break;
			case UIGestureRecognizerStateEnded:
				[self.bubbleDelegate CellLongPressEnded:dict];
				break;
			case UIGestureRecognizerStateCancelled:
				[self.bubbleDelegate CellLongPressCancelled:dict];
				break;
			default:
				break;
		}
	}
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[HomeViewController shared] clickBottomTabBar:9];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
 
}

@end
