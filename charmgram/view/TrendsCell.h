//
//  TrendsCell.h
//  charmgram
//
//  Created by Rain on 13-6-6.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "PrivateImage.h"

@interface TrendsCell : UITableViewCell
{
    UIImageView* imgThumb; 
    UIImageView* imgBubble;
    UIView* viewBg;
    UILabel* lblLike; 
    UILabel* lblDate;
    UILabel* lblTemperature;
    UILabel* lblLocation;
    UILabel* lblDateLoc;
	UILabel* lblTip;
	UILabel* lblTimer;  
	UIView* botMsk;
	UIButton* btnLike;
	UILabel* lblNickName;
	UILabel* lblViewCount;
	UILabel* lblCreateDate;
	UIImageView* imgAvatar;
	UIView* imgLine;
	BOOL hideUserInfo;
     
}
@property(nonatomic,strong)id toolbarDelegate;
@property(nonatomic,assign)id bubbleDelegate;
@property(nonatomic)int row;
@property(nonatomic,strong)PrivateImage* curInfo;
@property (nonatomic,retain)NSTimer* timerCountDown;
-(void)loadData:(PrivateImage*)info;
-(void)refreshData;
-(void)refreshSecond:(int)Second;
@end
