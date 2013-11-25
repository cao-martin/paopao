//
//  UserCell.h
//  charmgram
//
//  Created by Rain on 13-4-15.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface UserCell : UITableViewCell
{
    UIImageView* imgAvatar;
    UILabel* lblName;
    UIView *topLine;
    UIView *topLine2;
    UIButton *btnFan;
    BOOL isGuanZhu;
    int friendid;
}
@property(nonatomic,assign)BOOL isFullScreen;
-(void)loadData:(UserInfo*)user;
@end
