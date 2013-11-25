//
//  ExhibitCell.m
//  charmgram
//
//  Created by Rui Wei on 13-4-6.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "FaxianCell.h"
#import "UIImageView+WebCache.h"
@implementation FaxianCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		for (int k=0; k<2; k++) {
//			UIView* mask=[[UIView alloc] initWithFrame:CGRectMake(155*k+9, 9, 143, 143)];
//			mask.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1.0];
//			mask.tag=200+k;
//			mask.layer.shadowPath = [UIBezierPath bezierPathWithRect:mask.bounds].CGPath;
//            [mask.layer setShadowColor:[UIColor blackColor].CGColor];
//            [mask.layer setShadowOffset:CGSizeMake(1, 1)];
//            [mask.layer setShadowOpacity:0.6];
//            [mask.layer setShadowRadius:2];
//			[self.contentView addSubview:mask];
			
			UIImageView* imgSky=[[UIImageView alloc] initWithFrame:CGRectMake(155*k+9, 9, 145, 145)];
			imgSky.contentMode=UIViewContentModeScaleAspectFill;
			imgSky.image=[UIImage imageNamed:@"item_bg310"];
			imgSky.tag=50+k;
			[self.contentView addSubview:imgSky];
			
			imgBubble=[[UIImageView alloc] initWithFrame:CGRectMake(108, 8, 30, 31)];
			imgBubble.image=[UIImage imageNamed:@"status_paopao_ico"];
			[imgSky addSubview:imgBubble];
			
			UIImageView* imgBase=[[UIImageView alloc] initWithFrame:CGRectMake(53, 53, 40, 40)];
			imgBase.contentMode=UIViewContentModeScaleAspectFill;
			imgBase.clipsToBounds=YES;
			imgBase.tag=100+k;
//			imgBase.layer.cornerRadius=2.0;
//			imgBase.layer.masksToBounds=YES;
//			imgBase.userInteractionEnabled=YES;
			[imgSky addSubview:imgBase];
			
			UIButton* btnMsk=[UIButton buttonWithType:UIButtonTypeCustom];
			[btnMsk setImage:[UIImage imageNamed:@"feeds_halffeed_bg"] forState:UIControlStateNormal];
			[btnMsk setImage:[UIImage imageNamed:@"feeds_halffeed_bg_h"] forState:UIControlStateHighlighted];
			btnMsk.frame=CGRectMake(155*k+4, 4, 155, 157);
			btnMsk.tag=200+k;
			[btnMsk addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
			[self.contentView addSubview:btnMsk];
			
			/*
			UIImageView* imgMsk=[[UIImageView alloc] initWithFrame:CGRectMake(155*k+8, 8, 155, 157)];
			imgMsk.contentMode=UIViewContentModeScaleAspectFill;
			imgMsk.clipsToBounds=YES;
			imgMsk.tag=200+k; 
			imgMsk.userInteractionEnabled=YES;
			[self.contentView addSubview:imgMsk];
			
			
			UITapGestureRecognizer*tapImg=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
			tapImg.numberOfTapsRequired=1;
			tapImg.numberOfTouchesRequired=1;
			[imgBase addGestureRecognizer:tapImg];*/
			
			UIImageView* imgLike=[[UIImageView alloc] initWithFrame:CGRectMake(10, 130, 14, 14)];
			imgLike.image=[UIImage imageNamed:@"list_item_like"];
			imgLike.tag=300+k;
			[btnMsk addSubview:imgLike];
			
			UILabel* lblLike=[[UILabel alloc] initWithFrame:CGRectMake(25, 130, 40, 13)];
			lblLike.text=@"100";
			lblLike.font=[UIFont boldSystemFontOfSize:10.0];
			lblLike.textColor=[UIColor whiteColor];
			lblLike.backgroundColor=[UIColor clearColor];
			lblLike.tag=350+k;
			[btnMsk addSubview:lblLike];
			
			UIImageView* imgComment=[[UIImageView alloc] initWithFrame:CGRectMake(110, 130, 14, 14)];
			imgComment.image=[UIImage imageNamed:@"list_item_comments"];
			[btnMsk addSubview:imgComment];
			imgComment.tag=400+k;
			
			UILabel* lblComment=[[UILabel alloc] initWithFrame:CGRectMake(125, 130, 40, 13)];
			lblComment.text=@"500";
			lblComment.font=[UIFont boldSystemFontOfSize:10.0];
			lblComment.textColor=[UIColor whiteColor];
			lblComment.backgroundColor=[UIColor clearColor];
			lblComment.tag=450+k;
			[btnMsk addSubview:lblComment];
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
		UIButton* btnMsk=(UIButton*)[self.contentView viewWithTag:200+k];
//		UIImageView* imgLike=(UIImageView*)[btnMsk viewWithTag:300+k];
		UILabel* lblLike=(UILabel*)[btnMsk viewWithTag:350+k];
//		UIImageView* imgComment=(UIImageView*)[btnMsk viewWithTag:400+k];
		UIImageView* imgSky=(UIImageView*)[self.contentView viewWithTag:50+k];
		UILabel* lblComment=(UILabel*)[btnMsk viewWithTag:450+k];
		if (k>images.count-1) {
			img.hidden=YES;
			btnMsk.hidden=YES;
			imgSky.hidden=YES;
			continue;
		}
		else{
			img.hidden=NO;
			btnMsk.hidden=NO;
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
		if (item.LikeCount>0) {
//			[imgLike setHidden:NO];
			[lblLike setHidden:NO];
			lblLike.text=[NSString stringWithFormat:@"%d",item.LikeCount];
		}
		else{
//			[imgLike setHidden:YES];
			[lblLike setHidden:YES];
		}
		if (item.CommentCount>0) {
//			[imgComment setHidden:NO];
			[lblComment setHidden:NO];
			lblComment.text=[NSString stringWithFormat:@"%d",item.CommentCount];
		}
		else{
//			[imgComment setHidden:YES];
			[lblComment setHidden:YES];
		}
	}
}

-(void)clickImage:(UIView*)sender {
	int itag=sender.tag-200;
	[[HomeViewController shared] gotoDetailView:images[itag]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
