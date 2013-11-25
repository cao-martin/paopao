//
//  CommentCell.m
//  charmgram
//
//  Created by Rui Wei on 13-4-16.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		imgAvatar=[[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 30, 30)];
        imgAvatar.contentMode=UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imgAvatar];
        
        UIImageView* imgmsk=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatarmask_small_gray"]];
        imgmsk.frame=CGRectMake(13, 9, 32, 32);
        imgmsk.contentMode=UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgmsk];
        
        tvName=[[UILabel alloc] initWithFrame:CGRectMake(48, 0, kDeviceWidth-110, 50)];
        tvName.backgroundColor=[UIColor clearColor]; 
        tvName.font=[UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:tvName];
		
		imgGift=[[UIImageView alloc] initWithFrame:CGRectMake( kDeviceWidth-70, 10, 27, 27)];
		imgGift.tag=100 ;
		imgGift.layer.cornerRadius=4.0;
		imgGift.layer.masksToBounds=YES;
		[self.contentView addSubview:imgGift];
        
        UIButton* btnReply=[UIButton buttonWithType:UIButtonTypeCustom];
        btnReply.frame=CGRectMake(kDeviceWidth-60, 0, 60, 45);
        [btnReply setImage:[UIImage imageNamed:@"comment_reply_btn_d"] forState:UIControlStateNormal];
        [btnReply setImage:[UIImage imageNamed:@"comment_reply_btn"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:btnReply];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 48, kDeviceWidth, 1.0f)];
		topLine.backgroundColor =  [UIColor colorWithRed:(227/255.0f) green:(224/255.0f) blue:(221/255.0f) alpha:1.0f];
		[self.contentView addSubview:topLine];
		
		UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 49, kDeviceWidth, 1.0f)];
		topLine2.backgroundColor = [UIColor colorWithRed:(239/255.0f) green:(235/255.0f) blue:(234/255.0f) alpha:1.0f];
		[self.contentView addSubview:topLine2];
    }
    return self;
}

-(void)loadData:(CommentInfo*)info{
//    tvComment.text=[NSString stringWithFormat:@"%@: %@",info.UserName,info.Text];//info.UserName;
	tvName.text=info.UserName;
    imgAvatar.image=[UIImage imageNamed:info.AvatarURL];
	
    imgGift.image=[UIImage imageNamed:info.GiftUrl];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
