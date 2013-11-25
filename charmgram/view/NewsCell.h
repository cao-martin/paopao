//
//  NewsCell.h
//  charmgram
//
//  Created by martin on 13-8-23.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsInfo.h"
#import "PrivateImage.h"
@interface NewsCell : UITableViewCell
{
    UIImageView* imgAvatar;
    UILabel* lblName;
    UIView *topLine;
    UIView *topLine2;
    UIButton *imgRight;
    PrivateImage *privateImg;
    NewsInfo *newsInfo;
}
-(void)loadData:(NewsInfo*)user;
@end
