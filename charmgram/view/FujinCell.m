//
//  ExhibitCell.m
//  charmgram
//
//  Created by Rui Wei on 13-4-6.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//
#import "FujinCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
@implementation FujinCell
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		for (int k=0; k<2; k++) {
			/*
			UIView* mask=[[UIView alloc] initWithFrame:CGRectMake(155*k+9, 9, 143, 143)];
			mask.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1.0];
			mask.tag=200+k;
			mask.layer.shadowPath = [UIBezierPath bezierPathWithRect:mask.bounds].CGPath;
            [mask.layer setShadowColor:[UIColor blackColor].CGColor];
            [mask.layer setShadowOffset:CGSizeMake(1, 1)];
            [mask.layer setShadowOpacity:0.6];
            [mask.layer setShadowRadius:2];
			[self.contentView addSubview:mask];
			 */
			UIImageView* imgSky=[[UIImageView alloc] initWithFrame:CGRectMake(155*k+9, 9, 145, 145)];
			//imgSky.contentMode=UIViewContentModeScaleAspectFill;
			imgSky.image=[UIImage imageNamed:@"fujin_bg"];
			imgSky.tag=50+k;
			[self.contentView addSubview:imgSky];
			
			imgBubble=[[UIImageView alloc] initWithFrame:CGRectMake(108, 8, 30, 31)];
			imgBubble.image=[UIImage imageNamed:@"status_paopao_ico"];
			[imgSky addSubview:imgBubble];
			
			UIImageView* imgBase=[[UIImageView alloc] initWithFrame:CGRectMake(45, 45, 57, 57)];
			imgBase.contentMode=UIViewContentModeScaleAspectFill;
            imgBase.layer.cornerRadius = 28.5;
            imgBase.layer.borderWidth=3;
            imgBase.layer.borderColor = [UIColor whiteColor].CGColor;
            imgBase.layer.masksToBounds = YES;
			imgBase.clipsToBounds=YES;
			imgBase.tag=100+k; 
			[imgSky addSubview:imgBase];
			
			UIButton* btnMsk=[UIButton buttonWithType:UIButtonTypeCustom];
			[btnMsk setImage:[UIImage imageNamed:@"feeds_halffeed_bg"] forState:UIControlStateNormal];
			[btnMsk setImage:[UIImage imageNamed:@"feeds_halffeed_bg_h"] forState:UIControlStateHighlighted];
			btnMsk.frame=CGRectMake(155*k+4, 4, 155, 157);
			btnMsk.tag=200+k;
			[btnMsk addTarget:self action:@selector(clickAvatar:) forControlEvents:UIControlEventTouchUpInside];
			[self.contentView addSubview:btnMsk];
			 
			/*
			UITapGestureRecognizer *tapMask=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAvatar)];
			tapMask.numberOfTapsRequired=1;
			tapMask.numberOfTouchesRequired=1;
			[imgBase addGestureRecognizer:tapMask];*/
			
			UIImageView* imgPin=[[UIImageView alloc] initWithFrame:CGRectMake(11, 132, 10, 10)];
			imgPin.image=[UIImage imageNamed:@"feeds_half_pin"];
			imgPin.tag=300+k;
			[btnMsk addSubview:imgPin];
			
			UILabel* lblDistance=[[UILabel alloc] initWithFrame:CGRectMake(23, 130, 60, 13)];
			lblDistance.font=[UIFont boldSystemFontOfSize:10.0];
			lblDistance.textColor=[UIColor whiteColor];
			lblDistance.backgroundColor=[UIColor clearColor];
			lblDistance.tag=350+k;
			[btnMsk addSubview:lblDistance];
			
			UIView* imgAvatarMask=[[UIView alloc] initWithFrame:CGRectMake(115, 115, 30, 30)];
			imgAvatarMask.backgroundColor=[UIColor whiteColor];
			imgAvatarMask.layer.cornerRadius=2;
			[btnMsk addSubview:imgAvatarMask];
			imgAvatarMask.userInteractionEnabled=YES;
			imgAvatarMask.tag=400+k;
			
			UIImageView* imgAvatar=[[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 28, 28)];
//			imgAvatar.image=[UIImage imageNamed:@"example103.jpg"];
			[imgAvatarMask addSubview:imgAvatar];
			imgAvatar.userInteractionEnabled=YES;
			imgAvatar.tag=450+k;
			
			UITapGestureRecognizer *tapAvatar=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar:)];
			tapAvatar.numberOfTapsRequired=1;
			tapAvatar.numberOfTouchesRequired=1;
			[imgAvatar addGestureRecognizer:tapAvatar];
		}
		
		images=[[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

-(void) removeImages{
	[images removeAllObjects];
}

-(void)addImage:(PrivateImage*)info{
	[images addObject:info];
}

-(void)loadData{

	for (int k=0; k<2; k++) {
		UIImageView* img=(UIImageView*)[self.contentView viewWithTag:100+k];
		UIButton* imgMask=(UIButton*)[self.contentView viewWithTag:200+k];
		UIImageView* imgSky=(UIImageView*)[self.contentView viewWithTag:50+k];
		UILabel* lblDistance=(UILabel*)[imgMask viewWithTag:350+k];
		UIView* imgAvatarMask=[imgMask viewWithTag:400+k];
		UIImageView* imgAvatar=(UIImageView*)[imgAvatarMask viewWithTag:450+k];
		if (k>images.count-1) {
			img.hidden=YES;
			imgMask.hidden=YES;
			imgSky.hidden=YES;
			continue;
		}
		else{
			img.hidden=NO;
			imgMask.hidden=NO;
			imgSky.hidden=NO;
		}
		
		PrivateImage* item=[images objectAtIndex:k];
		if (item.ImageUrl.length==0) {
			continue;
		}

		if ([item.ThumbUrl hasPrefix:@"http"]) {
			[img setImageWithURL:[NSURL URLWithString:item.ThumbUrl]];
		}
		else{
			[img setImage:[UIImage imageNamed:item.ThumbUrl]];
		}
		if ([item.AvatarUrl hasPrefix:@"http"]) {
			[imgAvatar setImageWithURL:[NSURL URLWithString:item.AvatarUrl]];
		}
		else{
			[imgAvatar setImage:[UIImage imageNamed:item.AvatarUrl]];
		}
            NSLog(@"images====%f",item.Distance);
        if (item.Distance >60) {
            lblDistance.text=[NSString stringWithFormat:@">60km"];
        }
        else if (item.Distance<0.1) {
			lblDistance.text=[NSString stringWithFormat:@"<100m"];
		}
 		else if (item.Distance>1) {
			lblDistance.text=[NSString stringWithFormat:@"<%.1fkm",item.Distance];
		}
		else{
			lblDistance.text=[NSString stringWithFormat:@"<%.0fm",item.Distance*1000];
		}
	}
}

-(void)tapAvatar:(UITapGestureRecognizer*)gesture{
	int itag=gesture.view.tag-450;
	[[HomeViewController shared] gotoUserViewByImageInfo:images[itag]];
}

-(void)clickAvatar:(UIView*)sender{
	int itag=sender.tag-200;
	[[HomeViewController shared] gotoDetailView:images[itag]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated]; 
}

@end
