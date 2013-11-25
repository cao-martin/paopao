//
//  UserViewController.h
//  charmgram
//
//  Created by Rui Wei on 13-4-16.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "CommentCell.h"
#import "PrivatePhotoCell.h"
#import "PrivateImage.h"
#import "BubbleCell.h"
@interface UserViewController : UIViewController<ImageToolbarDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,BubbleCellDelegate,SinaWeiboDelegate>
{
	UILabel* lblTitle;
	UITableView* tbContent;
	UIImageView* imgDetail;
	UIImageView* imgAvatar;
    UILabel* lblName;
    UILabel* lblProfile;
	UILabel* lblFan;
	UILabel* lblFollow;
    UIButton* btnMsg;
    UIButton* btnFollow;
    UIImageView* imgVSep;
    NSMutableArray *arrImage;
    NSMutableArray *arrData;
	 NSMutableArray *arrTimer;
	UIView* bgPreview;
    UIImageView *imgPreview;
	UIButton *btnTimer;
	
	UIView* cartBar;
	UILabel* lblBalance;
	UILabel* lblSelectedCount;
	UILabel* lblSelectedAmount;
	int selectedCount;
	int selectedAmount;
	
	//int curCellTag;
	int curCellCol;
	UIView* header;
	UIImageView* paoBar;
	//UIButton* btnPao;
	
	BOOL isFollowed;
	BOOL isFollowing;
	int pageIndex;
	int fanCount;
	int followCount;
	BOOL isWebMsgRunning;
	NSMutableArray * arrWebMsg;
    PrivateImage *pinfoImg;
    UIImageView *imageNo;
    NSMutableArray *arrPaoPao;
    int curTabTag;
    int reportedImageId;
}
@property(nonatomic,assign)int PlazaType;
@property (nonatomic,retain)NSTimer* timerCountDown;
@property (nonatomic,strong)UserInfo* curUserInfo;
@property(nonatomic,strong)UIButton *btnPao;
-(void)loadData:(UserInfo*)info;
-(void)pickPaoPao;
-(void)hidenLogo;
-(void)clearData;
-(void)clearSaveData;
-(void)loadDefaultData;
@end
