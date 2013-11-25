//
//  TXLCell.m
//  charmgram
//
//  Created by martin on 13-9-17.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "TXLCell.h"

@implementation TXLCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSel:(id)sel
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];//colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        UIImageView *imageBk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBk"]];
        self.backgroundView = imageBk;
        UIImageView* imgmsk=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pub_memtion_avatar_border"]];
        imgmsk.frame=CGRectMake(13, 9, 32, 32);
        imgmsk.contentMode=UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgmsk];
        imgmsk.hidden = YES;
        lblName=[[UILabel alloc] initWithFrame:CGRectMake(56, 10, kFriendPanelWidth-100, 30)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=[UIColor blackColor];
        lblName.font=[UIFont boldSystemFontOfSize:14.0];
        [self.contentView addSubview:lblName];
        
//        topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kMenuPanelWidth, 1.0f)];
//		topLine.backgroundColor = [UIColor colorWithRed:(38.0f/255.0f) green:(39.0f/255.0f) blue:(46.0f/255.0f) alpha:1.0f];
//		[self.contentView addSubview:topLine];
//		
//		topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, kMenuPanelWidth, 1.0f)];
//		topLine2.backgroundColor = [UIColor colorWithRed:(48/255.0f) green:(51/255.0f) blue:(57/255.0f) alpha:1.0f];
//		[self.contentView addSubview:topLine2];
        
        _check1 = [[QCheckBox alloc] initWithDelegate:sel];
        _check1.frame = CGRectMake(240, 2, 80, 40);
        [_check1 setTitle:@"" forState:UIControlStateNormal];
        [_check1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_check1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [self addSubview:_check1];
        [_check1 setChecked:NO];
    }
    return self;
}
-(void)loadData:(UserInfo*)user{
    [topLine setFrame:CGRectMake(0.0f, 0.0f, kDeviceWidth, 1.0f)];
    topLine.backgroundColor=[UIColor colorWithWhite:0.75 alpha:1.0];
    [topLine2 setFrame:CGRectMake(0.0f, 1.0f, kDeviceWidth, 1.0f)];
    topLine2.hidden=YES;
    lblName.textColor=[UIColor blackColor];
    lblName.text=user.UserName;
    _check1.tag = self.tag;
    [_check1 setChecked:user.isSelectde];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
