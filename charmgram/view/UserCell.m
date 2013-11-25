//
//  UserCell.m
//  charmgram
//
//  Created by Rain on 13-4-15.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "UserCell.h"
#import "UIImageView+WebCache.h"
@implementation UserCell
@synthesize isFullScreen;
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
        
        lblName=[[UILabel alloc] initWithFrame:CGRectMake(56, 10, kFriendPanelWidth-66, 30)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=[UIColor whiteColor];
        lblName.font=[UIFont boldSystemFontOfSize:14.0];
        [self.contentView addSubview:lblName];
        
        btnFan = [[UIButton alloc] initWithFrame:CGRectMake(kFriendPanelWidth-33-15, 12, 33, 25)];
        [btnFan addTarget:self action:@selector(changeFan) forControlEvents:UIControlEventTouchUpInside];
        //[btnFan setImage:<#(UIImage *)#> forState:<#(UIControlState)#>]
        if ([reuseIdentifier isEqualToString:@"friend2"]||[reuseIdentifier isEqualToString:@"friend4"]) {
             [btnFan setBackgroundImage:[UIImage imageNamed:@"profile_unfovored_btn"] forState:UIControlStateNormal];
            btnFan.hidden = NO;
        }else{
            btnFan.hidden = YES;
        }
       
        [self.contentView addSubview:btnFan];
        
        topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kMenuPanelWidth, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(38.0f/255.0f) green:(39.0f/255.0f) blue:(46.0f/255.0f) alpha:1.0f];
		[self.contentView addSubview:topLine];
		
		topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, kMenuPanelWidth, 1.0f)];
		topLine2.backgroundColor = [UIColor colorWithRed:(48/255.0f) green:(51/255.0f) blue:(57/255.0f) alpha:1.0f];
		[self.contentView addSubview:topLine2];
        
      
    }
    return self;
}
-(void)changeFan{
    int myuserid=[AppHelper getIntConfig:confUserId];
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
	if (isGuanZhu) {
		[asirequest setPostValue:METHOD_UNFOLLOWUSER forKey:@"method"];
	}
	else{
		[asirequest setPostValue:METHOD_FOLLOWUSER forKey:@"method"];
	}
	isGuanZhu=!isGuanZhu;
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", myuserid] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d",friendid] forKey:@"ownerid"];

    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        NSLog(@"respString===%@",respString);
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
       // NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            
			if (isGuanZhu) {
                [btnFan setBackgroundImage:[UIImage imageNamed:@"profile_unfovored_btn"] forState:UIControlStateNormal];
			}
			else{
                 [btnFan setBackgroundImage:[UIImage imageNamed:@"profile_fovored_blue"] forState:UIControlStateNormal];
             
			}
        }
		else{
		}
		//isGuanZhu=NO;
    }];
    [asirequest setFailedBlock:^{
		//isGuanZhu=NO;
    }];
    [asirequest startAsynchronous];


}
-(void)loadData:(UserInfo*)user{
    if (self.isFullScreen) {
        [topLine setFrame:CGRectMake(0.0f, 0.0f, kDeviceWidth, 1.0f)];
        topLine.backgroundColor=[UIColor colorWithWhite:0.75 alpha:1.0];
        [topLine2 setFrame:CGRectMake(0.0f, 1.0f, kDeviceWidth, 1.0f)];
        topLine2.hidden=YES;
        lblName.textColor=[UIColor blackColor];
    }
    else{
        [topLine setFrame:CGRectMake(0.0f, 0.0f, kMenuPanelWidth, 1.0f)];
        topLine.backgroundColor=[UIColor colorWithWhite:0.2 alpha:1.0];
        [topLine2 setFrame:CGRectMake(0.0f, 1.0f, kMenuPanelWidth, 1.0f)];
        topLine2.hidden=NO;
        lblName.textColor=[UIColor whiteColor];
    }
   // [btnFan setBackgroundImage:[UIImage imageNamed:@""] forState:<#(UIControlState)#>];
    isGuanZhu = user.isCare;
    if (isGuanZhu) {
        [btnFan setBackgroundImage:[UIImage imageNamed:@"profile_unfovored_btn"] forState:UIControlStateNormal];
    }
    else{
        [btnFan setBackgroundImage:[UIImage imageNamed:@"profile_fovored_blue"] forState:UIControlStateNormal];
        
    }
    friendid = user.UserId;
    lblName.text=user.UserName;
	[imgAvatar setImageWithURL:[NSURL URLWithString:user.AvatarURL]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
