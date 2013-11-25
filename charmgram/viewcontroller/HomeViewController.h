//
//  HomeViewController.h
//  charmgram
//
//  Created by Rui Wei on 13-3-25.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomTabBar.h" 
#import "DongtaiViewController.h" 
#import "MenuViewController.h"
#import "FriendViewController.h"
#import "EntryViewController.h"
#import "UserViewController.h"
#import "IFFiltersViewController.h"
#import "TopSegmentBar.h"
#import "PlazaViewController.h"
#import "TrendsViewController.h"
#import "PrivateImage.h"
#import "UserInfo.h"
#import "CircularProgressView.h"
#import "SettingViewController.h"
#import "NewSViewController.h"
@interface HomeViewController : UIViewController<MenuDelegate,BottomTabBarDelegate,TopSegmentBarDelegate,BubbleCellDelegate>
{
    BottomTabBar* botBar;
//    SDSegmentedControl* segments;
	TopSegmentBar* topSegment;
    TrendsViewController * dongtaiController;
    //PlazaViewController* faxianController;
    UserViewController *faxianController;
    PlazaViewController* fujinController;
    MenuViewController* menuController;
    FriendViewController* friendController;
    SettingViewController* controllerSet;
    NewSViewController* controllerNew;
    UserViewController *paopaoVc;
    NSArray* tabBarItems;
    BOOL isShowMenu;
    BOOL isShowFriend;
    BOOL isAutoResetting;
    UIView *contentView;
    UIView* maskView;
    CGFloat panStartX;
	//int curCellTag;
	int curCellCol;
	int curTabTag;
	UIView* bgPreview;
    UIImageView *imgPreview;
	UIButton *btnTimer;
    UIView *firstView ;
    UIView *setView;
    UIView *newViw;
    UIView *userView;
}
@property (nonatomic,retain)NSTimer* timerCountDown;
+ (HomeViewController *)shared;
-(void)resetMe:(BOOL)animated;
-(void)gotoDetailView:(PrivateImage*)info;
-(void)gotoUserViewByImageInfo:(PrivateImage*)info;
-(void)gotoFriendView:(int)mode;
-(void)gotoUserView:(UserInfo*)info;
-(void)gotoGiftView:(PrivateImage *)info;
-(void)gotoMoreGiftView:(PrivateImage *)info;
-(void)changeTab:(int)index;
-(void)didLogout;
-(void)clearPaoPaoData;
-(void)ApliyView;
-(void)notView;
-(void)blackList;
-(void)clickMenuSetting:(BOOL)isUser;
-(void)refleshFujin;
@end
