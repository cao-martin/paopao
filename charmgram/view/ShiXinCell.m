//
//  ShiXinCell.m
//  charmgram
//
//  Created by martin on 13-10-21.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "ShiXinCell.h"
#import "UIImageView+WebCache.h"
@implementation ShiXinCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imgAvatar=[[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 30, 30)];
        imgAvatar.contentMode=UIViewContentModeScaleAspectFill;
		imgAvatar.clipsToBounds=YES;
        [self.contentView addSubview:imgAvatar];
        
        UIImageView* imgmsk=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pub_memtion_avatar_border"]];
        imgmsk.frame=CGRectMake(13, 9, 32, 32);
        imgmsk.contentMode=UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgmsk];
        
        lblName=[[UILabel alloc] initWithFrame:CGRectMake(56, 10, kFriendPanelWidth-66, 20)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=[UIColor whiteColor];
        lblName.font=[UIFont boldSystemFontOfSize:14.0];
        [self.contentView addSubview:lblName];
        
   
        lblContent=[[UILabel alloc] initWithFrame:CGRectMake(56, 30, kFriendPanelWidth-66, 15)];
        lblContent.backgroundColor=[UIColor clearColor];
        lblContent.textColor=[UIColor whiteColor];
        lblContent.font=[UIFont boldSystemFontOfSize:10.0];
        [self.contentView addSubview:lblContent];
        
        lblTime=[[UILabel alloc] initWithFrame:CGRectMake(kFriendPanelWidth, 30, 66, 15)];
        
        lblTime.backgroundColor=[UIColor clearColor];
        lblTime.textColor=[UIColor lightGrayColor];
        lblTime.font=[UIFont boldSystemFontOfSize:10.0];
        [self.contentView addSubview:lblTime];
        
        topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kDeviceWidth, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(38.0f/255.0f) green:(39.0f/255.0f) blue:(46.0f/255.0f) alpha:1.0f];
		[self.contentView addSubview:topLine];
		
		topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, kDeviceWidth, 1.0f)];
		topLine2.backgroundColor = [UIColor colorWithRed:(48/255.0f) green:(51/255.0f) blue:(57/255.0f) alpha:1.0f];
		[self.contentView addSubview:topLine2];
        

        
        
    }
    return self;
   
}
-(void)loadData:(UserInfo*)user{
//        [topLine setFrame:CGRectMake(0.0f, 0.0f, kDeviceWidth, 1.0f)];
//        topLine.backgroundColor=[UIColor colorWithWhite:0.75 alpha:1.0];
//        [topLine2 setFrame:CGRectMake(0.0f, 1.0f, kDeviceWidth, 1.0f)];
//        topLine2.hidden=YES;
       // lblName.textColor=[UIColor blackColor];
    lblTime.text = user.show_time;
        // [btnFan setBackgroundImage:[UIImage imageNamed:@""] forState:<#(UIControlState)#>];
 
    lblContent.text = user.Content;

    lblName.text=user.UserName;
	[imgAvatar setImageWithURL:[NSURL URLWithString:user.AvatarURL]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
