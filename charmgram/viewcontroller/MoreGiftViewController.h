//
//  MoreGiftViewController.h
//  charmgram
//
//  Created by martin on 13-8-10.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivateImage.h"
@interface MoreGiftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray* arrItem;
    UITableView* tbGift;
    
    
    UIView* header;
	UIImageView* imgDetail;
	UIImageView* imgAvatar;
    UILabel* lblName;
    UIImageView *imgPhoto;
    UILabel *lblTip;
    UIImageView *imgBubble;
    UILabel *lblTimer;
    UIView *bgPreview;
    UIImageView *imgPreview;
    UIButton *btnTimer;
}
@property(nonatomic,strong)PrivateImage *curInfo;
@property (nonatomic,retain)NSTimer* timerCountDown;
@end
