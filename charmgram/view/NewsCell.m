//
//  NewsCell.m
//  charmgram
//
//  Created by martin on 13-8-23.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ChatViewController.h"
@implementation NewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imgAvatar=[[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 30, 30)];
        imgAvatar.contentMode=UIViewContentModeScaleAspectFill;
		imgAvatar.clipsToBounds=YES;
        [self.contentView addSubview:imgAvatar];
        imgAvatar.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapAvatar=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar:)];
        tapAvatar.numberOfTapsRequired=1;
        tapAvatar.numberOfTouchesRequired=1;
        [imgAvatar addGestureRecognizer:tapAvatar];
        
        UIImageView* imgmsk=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pub_memtion_avatar_border"]];
        imgmsk.frame=CGRectMake(13, 9, 32, 32);
        imgmsk.contentMode=UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgmsk];
        
        lblName=[[UILabel alloc] initWithFrame:CGRectMake(56, 10, kFriendPanelWidth-66, 30)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=[UIColor whiteColor];
        lblName.font=[UIFont boldSystemFontOfSize:14.0];
        [self.contentView addSubview:lblName];
        
        
        imgRight=[[UIButton alloc] initWithFrame:CGRectMake(260, 10, 30, 30)];
        [imgRight addTarget:self action:@selector(gotoImg) forControlEvents:UIControlEventTouchUpInside];
        imgRight.contentMode=UIViewContentModeScaleAspectFill;
		imgRight.clipsToBounds=YES;
        imgRight.hidden = YES;
        [self.contentView addSubview:imgRight];
        
        topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kDeviceWidth, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(38.0f/255.0f) green:(39.0f/255.0f) blue:(46.0f/255.0f) alpha:1.0f];
		[self.contentView addSubview:topLine];
		
		topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, kDeviceWidth, 1.0f)];
		topLine2.backgroundColor = [UIColor colorWithRed:(48/255.0f) green:(51/255.0f) blue:(57/255.0f) alpha:1.0f];
		[self.contentView addSubview:topLine2];
    }
    return self;
}
-(void)tapAvatar:(UITapGestureRecognizer*)gesture{
    
    if (newsInfo.typeMes == 3 ) {
        ChatViewController* controller=[[ChatViewController alloc] init];
        controller.strUserName=newsInfo.SendName;
        controller.PeerId=newsInfo.SendId;
        [[HomeViewController shared] presentViewController:controller animated:YES completion:nil];
    }else if(newsInfo.typeMes == 5){
        UserInfo *userItem = [UserInfo new];
        userItem.UserId = newsInfo.UserId;
        //NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
        if (userItem.UserId ==[AppHelper getIntConfig:confUserId]) {
            userItem.UserName = [AppHelper getStringConfig:confUserName];;
            userItem.AvatarURL = [AppHelper getStringConfig:confUserHeadUrl];
        }else{
            userItem.UserName = newsInfo.SendName;
            userItem.AvatarURL = newsInfo.SendHeadimg;
        }
        
        [[HomeViewController shared] gotoUserView:userItem];
    }else{
        UserInfo *userItem = [UserInfo new];
        userItem.UserId = newsInfo.SendId;
        //NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
        
        userItem.UserName = newsInfo.SendName;
        userItem.AvatarURL = newsInfo.SendHeadimg;
        
        
        [[HomeViewController shared] gotoUserView:userItem];
    }
    

}
-(void)loadData:(NewsInfo*)user{
    newsInfo = user;
    switch (user.typeMes) {
        case 1://赞
        {
            imgRight.hidden = NO;
            [imgRight setImageWithURL:[NSURL URLWithString:user.pic]];
            [imgAvatar setImageWithURL:[NSURL URLWithString:user.SendHeadimg]];
        }
            break;
        case 4://赞
        {
            imgRight.hidden = NO;
            [imgRight setImageWithURL:[NSURL URLWithString:user.pic]];
            [imgAvatar setImageWithURL:[NSURL URLWithString:user.SendHeadimg]];
        }
            break;
        case 5://赞
        {
            imgRight.hidden = NO;
            [imgRight setImageWithURL:[NSURL URLWithString:user.pic]];
            [imgAvatar setImageWithURL:[NSURL URLWithString:[AppHelper getStringConfig:confUserHeadUrl]]];
        }
            
            break;
      
        default:
            [imgAvatar setImageWithURL:[NSURL URLWithString:user.SendHeadimg]];
            break;
    }
    lblName.text = user.Content;
//    if (self.isFullScreen) {
//        [topLine setFrame:CGRectMake(0.0f, 0.0f, kDeviceWidth, 1.0f)];
//        topLine.backgroundColor=[UIColor colorWithWhite:0.75 alpha:1.0];
//        [topLine2 setFrame:CGRectMake(0.0f, 1.0f, kDeviceWidth, 1.0f)];
//        topLine2.hidden=YES;
//        lblName.textColor=[UIColor blackColor];
//    }
//    else{
//        [topLine setFrame:CGRectMake(0.0f, 0.0f, kMenuPanelWidth, 1.0f)];
//        topLine.backgroundColor=[UIColor colorWithWhite:0.2 alpha:1.0];
//        [topLine2 setFrame:CGRectMake(0.0f, 1.0f, kMenuPanelWidth, 1.0f)];
//        topLine2.hidden=NO;
//        lblName.textColor=[UIColor whiteColor];
//    }
//    lblName.text=user.UserName;
	
}
-(void)gotoImg{
    
    PrivateImage *pImg = [PrivateImage new];
    pImg.ImageId  = newsInfo.info_sid;
    if (newsInfo.typeMes ==4) {
        pImg.UserName = @"gundan";
        [[HomeViewController shared] gotoMoreGiftView:pImg];
    }else{
        [[HomeViewController shared]gotoDetailView:pImg];
    }
    
    
   // [[HomeViewController shared] gotoGiftView:pImg]
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
