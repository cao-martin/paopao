//
//  ShiXinCell.h
//  charmgram
//
//  Created by martin on 13-10-21.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShiXinCell : UITableViewCell
{
    UIImageView* imgAvatar;
    UILabel* lblName;
    UIView *topLine;
    UIView *topLine2;
    UIButton *btnFan;
    UILabel *lblContent;
    UILabel *lblTime;
}
-(void)loadData:(UserInfo*)user;
@end
