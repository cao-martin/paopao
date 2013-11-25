//
//  HomeViewController.m
//  charmgram
//
//  Created by Rui Wei on 13-3-25.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "HomeViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "GiftViewController.h"
#import "MoreGiftViewController.h"
#import "FindFriendViewController.h"
#import "NotSetViewController.h"
#import "BlackViewController.h"
#define ANIMATED_DURATION   0.20

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize timerCountDown;

+ (HomeViewController *)shared {
    static HomeViewController *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[HomeViewController alloc] init];
    });
    
    return _shared;
}


- (void)viewDidLoad
{
    [super viewDidLoad]; 
    self.view.backgroundColor=[UIColor whiteColor]; 
    
    menuController=[[MenuViewController alloc] init]; 
    menuController.view.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
	menuController.delegate=self;
     [self.view addSubview:menuController.view];
    [menuController.view setHidden:YES];
    
    friendController=[[FriendViewController alloc] init];
    [self.view addSubview:friendController.view];
    [friendController.view setHidden:YES];
    friendController.view.frame=CGRectMake(kDeviceWidth-kFriendPanelWidth, 0, kDeviceWidth, kDeviceHeight);
//	[friendController refreshData];
    
    contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    contentView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:contentView];
    
    contentView.layer.masksToBounds = NO;
    contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    contentView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    contentView.layer.shadowOpacity = 1.0f;
    contentView.layer.shadowRadius = 2.5f;
    contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:contentView.bounds].CGPath;
 
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    firstView.layer.masksToBounds = YES;
    firstView.hidden = NO;
    firstView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:firstView];
    
    setView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    setView.hidden = YES;
    setView.layer.masksToBounds = YES;
    setView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:setView];
    

    
    UIViewController *controller = controllerSet;
    
    [firstView addSubview:controller.view];
    newViw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    newViw.hidden = YES;
    newViw.layer.masksToBounds = YES;
    newViw.backgroundColor = [UIColor clearColor];
    [contentView addSubview:newViw];
    
    userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    userView.hidden = YES;
    userView.layer.masksToBounds = YES;
    userView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:userView];
    
    dongtaiController = [[TrendsViewController alloc] init];

    UserInfo *info = [UserInfo new];
    info.UserId = [AppHelper getIntConfig:confUserId];
    info.UserName = [AppHelper getStringConfig:confUserName];
    info.AvatarURL = [AppHelper getStringConfig:confUserHeadUrl];
    
    faxianController = [[UserViewController alloc] init];
    faxianController.curUserInfo = info;
    faxianController.PlazaType = PLAZA_FAXIAN;
    [faxianController hidenLogo];
//    faxianController = [[PlazaViewController alloc] initWithStyle:UITableViewStylePlain plazatype:PLAZA_FAXIAN];
//	[faxianController refreshData];
    
    fujinController = [[PlazaViewController alloc] initWithStyle:UITableViewStylePlain plazatype:PLAZA_FUJIN];
	[fujinController refreshData];
    tabBarItems =[[NSArray alloc] initWithObjects:
                  dongtaiController,
                  faxianController,
                  fujinController,
                  nil];
    for (int k=tabBarItems.count-1; k>=0; k--) {
        UIViewController* controller =(UIViewController*) [tabBarItems objectAtIndex:k];
        controller.view.frame = CGRectMake(0,36,firstView.bounds.size.width, firstView.bounds.size.height-99);
        [firstView addSubview:controller.view];
    }
    
    
	
	topSegment=[[TopSegmentBar alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
//	[topSegment resetView:arrSeg];
    [topSegment resetView:@[@"动态",@"发现",@"附近"]
                 arrImage:@[@"segmental_mine",@"segmental_like",@"segmental_pin"] ];
	topSegment.delegate=self;
	[firstView addSubview:topSegment];
    
	[topSegment setSelectedIndex:1 animated:NO];
    
   

//    segments=[[SDSegmentedControl alloc] initWithItems:arrSeg];
//    segments.frame=CGRectMake(0, 0, kDeviceWidth, 44);
//    [segments setSelectedSegmentIndex:1];
//    [segments addTarget:self action:@selector(didChangeSegment ) forControlEvents:UIControlEventValueChanged];
//    [contentView addSubview:segments];
    
    
    paopaoVc = [[UserViewController alloc] init];
    paopaoVc.PlazaType = PLAZA_FAXIAN;
   // paopaoVc.view.backgroundColor = [UIColor redColor];
    paopaoVc.view.frame = CGRectMake(0,0,firstView.bounds.size.width, firstView.bounds.size.height-63);
    [contentView addSubview:paopaoVc.view];
    [paopaoVc hidenLogo];
    
    botBar = [[BottomTabBar alloc] initWithFrame:CGRectMake(0, kDeviceHeight-64, kDeviceWidth, 44)];
    botBar.delegate=self;
    [contentView addSubview:botBar];
//    [self changeTab:0];
    
    maskView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    maskView.backgroundColor=[UIColor clearColor];//[UIColor colorWithWhite:0 alpha:0.2];
    maskView.hidden=YES;
    
    UITapGestureRecognizer* tapmask=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMask)];
    tapmask.numberOfTapsRequired=1;
    tapmask.numberOfTouchesRequired=1;
    [maskView addGestureRecognizer:tapmask];
    
    UIPanGestureRecognizer* panMask=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMask:)];
    [maskView addGestureRecognizer:panMask];
    
    [contentView addSubview:maskView];
	
	[self initObservers];
	[self changeTab:1];
	[self initPreview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; 
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    friendController.view.frame=CGRectMake(kDeviceWidth-kFriendPanelWidth, 0, kDeviceWidth, kDeviceHeight);
    
}

-(void)viewWillAppear:(BOOL)animated{
	[botBar resetBar:[AppHelper isValidatedUser]];
    paopaoVc.view.hidden = [AppHelper isValidatedUser];
	[menuController resetMenu];
	[super viewWillAppear:animated];
}

-(void)initObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

-(void)initPreview{
	bgPreview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-20)];
    bgPreview.backgroundColor=[UIColor colorWithWhite:0 alpha:1.0];
    [bgPreview setHidden:YES];
	
	imgPreview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-20)];
    [imgPreview setContentMode:UIViewContentModeScaleAspectFit];
	[bgPreview addSubview:imgPreview];
	
	btnTimer=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnTimer setFrame:CGRectMake(kDeviceWidth-45, 36, 33, 30)];
    [btnTimer setBackgroundImage:[UIImage imageNamed:@"countdown_mask"] forState:UIControlStateNormal];
    [btnTimer setBackgroundImage:[UIImage imageNamed:@"countdown_mask"] forState:UIControlStateHighlighted];
    [btnTimer setTitle:@"10秒" forState:UIControlStateNormal];
    btnTimer.titleLabel.textColor=[UIColor whiteColor];
    btnTimer.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    [bgPreview addSubview:btnTimer];
	//btnTimer.hidden = YES;
	[self.view addSubview:bgPreview];
}



#pragma mark - Segments
-(void)didChangeSegment:(int)index {
    [self changeTab:index];
}

-(void)changeTab:(int)index{
    firstView.hidden = NO;
	if (index>tabBarItems.count-1) {
		return;
	}
    if (!paopaoVc.view.hidden) {
        [faxianController loadDefaultData];
        paopaoVc.view.hidden = YES;
         faxianController.btnPao.frame =  CGRectMake(14, kDeviceHeight-114-20-30, 61, 63);
    }else{
       
    }
    
    if (topSegment.selectedSegmentIndex!=index) {
        [topSegment setSelectedIndex:index animated:NO];
    }
	
    UIViewController<TabItemDelegate>* controller =(UIViewController<TabItemDelegate>*) [tabBarItems objectAtIndex:index];
    
    if (controller && [controller conformsToProtocol:@protocol(TabItemDelegate)]) {
        [controller refreshData];
    }
	//    [contentView addSubview:controller.view];
    [firstView insertSubview:controller.view belowSubview:topSegment];
}
-(void)refleshFujin{
    [fujinController clearData];
    [fujinController refreshData];
}
-(void)clearPaoPaoData{
    [faxianController clearSaveData];
}
-(void)didLogout{
    paopaoVc.btnPao.frame = CGRectMake(14, kDeviceHeight-114-20, 61, 63);
    firstView.hidden = YES;
	for (int k=0; k<tabBarItems.count; k++) {
		UIViewController<TabItemDelegate>* controller =(UIViewController<TabItemDelegate>*) tabBarItems[k];
		
		if (controller && [controller conformsToProtocol:@protocol(TabItemDelegate)]) {
            
			[controller clearData];
		}
        else if([controller isKindOfClass:[UserViewController class]]){
            [(UserViewController *)controller clearData];
        }
	}
     //[AppHelper setArrayConfig:@"paopaoData" val:nil];
    [AppHelper setStringConfig:confUserInfo val:@""];
   // [AppHelper setStringConfig:confUserCoin val:@""];
    [AppHelper setIntConfig:confUserId val:0];
    //[AppHelper setStringConfig:confNotData val:@""];
    [friendController clearData];
    [paopaoVc clearData];
    [self clickMenuFirst];
    [botBar resetBar:[AppHelper isValidatedUser]];
    paopaoVc.view.hidden = [AppHelper isValidatedUser];
	[menuController resetMenu];
}
-(void)ApliyView{
    PurchaseViewController* controller=[[PurchaseViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)notView{
    NotSetViewController *controller = [[NotSetViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)blackList{
    BlackViewController *controller = [[BlackViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - Click Bottom Menu
-(void)clickMask{
    [self resetMe:YES];
}

-(void)panMask:(UIPanGestureRecognizer*)gesture{
 
    if (isAutoResetting) {
        return;
    }
	[friendController hideKeyWin];
    CGPoint curPoint=[gesture locationInView:self.view];
    CGFloat curX=curPoint.x;
    
    CGPoint curViewPoint=[gesture locationInView:gesture.view];
    CGFloat curViewX=curViewPoint.x;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            panStartX = curViewX;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
//            DLog(@"panStartX - %f; curX - %f; kMenuPanelWidth- %f; curViewX- %f",
//                 panStartX,curX,kMenuPanelWidth,curViewX);
//            contentView.transform=CGAffineTransformMakeTranslation(curPoint.x-panStartX,0);
//            contentView.frame=CGRectMake(curPoint.x, 0, kDeviceWidth, kDeviceHeight);
            if (isShowMenu && curX-panStartX<kMenuPanelWidth ) {
                CGRect newframe=contentView.frame;
                newframe.origin.x=curX-panStartX;
                contentView.frame=newframe;
            }
            if (isShowFriend && panStartX-curX<kFriendPanelWidth) {
                CGRect newframe=contentView.frame;
                newframe.origin.x=curX-panStartX;
                contentView.frame=newframe;
            }
        }
            break;
        default:
        {
            if (isShowMenu) {
                isAutoResetting=YES;
                CGRect newframe=contentView.frame;
                CGFloat originX=newframe.origin.x;
                BOOL needReset=(kMenuPanelWidth-originX>kPanPanelDistance);
                newframe.origin.x=(needReset)?0.0:kMenuPanelWidth;
                
                [UIView animateWithDuration:ANIMATED_DURATION-0.05 animations:^{
                    contentView.frame=newframe;
                } completion:^(BOOL finished) {
                    isShowMenu=!needReset;
                    isAutoResetting=NO;
                    maskView.hidden=needReset;
                    menuController.view.hidden=needReset;
                }];
            }
            if (isShowFriend) {
                isAutoResetting=YES;
                CGRect newframe=contentView.frame;
                CGFloat originX=newframe.origin.x;
                BOOL needReset=(originX+kFriendPanelWidth>kPanPanelDistance);
                DLog(@"originX - %f",originX);
                newframe.origin.x=(needReset)?0.0:-kFriendPanelWidth;
                
                [UIView animateWithDuration:ANIMATED_DURATION-0.05 animations:^{
                    contentView.frame=newframe;
                } completion:^(BOOL finished) {
                    isShowFriend=!needReset;
                    isAutoResetting=NO;
                    maskView.hidden=needReset;
                    friendController.view.hidden=needReset;
                }];
            }
        }
            break;
    } 
}
 
-(void)clickBottomTabBar:(int)index{
    switch (index) {
        case 9:
        {
            EntryViewController* controller=[[EntryViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 0:
        { 
            if (![AppHelper isValidatedUser]) {
                return;
            }
            isShowMenu=!isShowMenu;
			[self showMenu:YES];
        }
            break;
		case 1:
		{
			if (![AppHelper isValidatedUser]) {
                return;
            }
			IFFiltersViewController *filtersViewController = [[IFFiltersViewController alloc] init];
			filtersViewController.uploadDelegate=tabBarItems[0];
            filtersViewController.shouldLaunchAsAVideoRecorder = NO;
            filtersViewController.shouldLaunchAshighQualityVideo = NO;
			[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            [self presentViewController:filtersViewController animated:YES completion:nil];
//			[self presentViewController:filtersViewController animated:YES completion:^(){
//				filtersViewController = nil;
//			}];
		}
			break;
        case 2:
        {
            if (![AppHelper isValidatedUser]) {
                return;
            }
            isShowFriend=!isShowFriend;
            [self showFriend:YES];
        }
            break;
        default:
            break;
    }
}

-(void)showMenu:(BOOL)animated{
	[friendController.view setHidden:YES];
	[menuController.view setHidden:NO]; 
    CGRect newFrame=contentView.frame;
	if(isShowMenu){ 
        newFrame.origin.x=kMenuPanelWidth;
	}
	else{
        newFrame.origin.x=0;
	}
	if (animated) {
		[UIView animateWithDuration:ANIMATED_DURATION delay:0.0
							options:UIViewAnimationOptionCurveEaseOut
						 animations:^{
							 contentView.frame=newFrame;
						 } completion:^(BOOL finished) {
							 if (!isShowMenu) {
								 [menuController.view setHidden:YES];
							 }
                             maskView.hidden=!isShowMenu;
						 }];
	}
	else{
		contentView.frame=newFrame;
		if (!isShowMenu) {
			[menuController.view setHidden:YES];
		}
        maskView.hidden=!isShowMenu;
	}
    [[AppDelegate App] getMessage];
}

-(void)showFriend:(BOOL)animated{ 
	[friendController hideKeyWin];
	[friendController.view setHidden:NO];
	[friendController refreshData]; 
	[menuController.view setHidden:YES];
	CGRect newFrame=contentView.frame;
	if(isShowFriend){
        newFrame.origin.x=-kFriendPanelWidth; 
	}
	else{
		newFrame.origin.x=0;
	}
	if (animated) {
		[UIView animateWithDuration:ANIMATED_DURATION delay:0.0
							options:UIViewAnimationOptionCurveEaseOut
						 animations:^{
							 contentView.frame=newFrame;
						 } completion:^(BOOL finished) {
							 if (!isShowFriend) {
								 [friendController.view setHidden:YES];
							 }
                             maskView.hidden=!isShowFriend;
						 }];
	}
	else{
		contentView.frame=newFrame;
		if (!isShowFriend) {
			[friendController.view setHidden:YES];
		}
        maskView.hidden=!isShowFriend;
	}
}

#pragma mark - MenuDelegate
-(void)clickMenuUser{
    setView.hidden = YES;
    firstView.hidden = YES;
    newViw.hidden = YES;
    userView.hidden = NO;
}
-(void)clickMenuFirst{
    setView.hidden = YES;
    firstView.hidden = NO;
    newViw.hidden = YES;
    userView.hidden = YES;
}
-(void)clickMenuSetting:(BOOL)isUser{
    setView.hidden = NO;
    firstView.hidden = YES;
    newViw.hidden = YES;
    userView.hidden = YES;
    //[self performSelector:@selector(resetMe:) withObject:NO afterDelay:0.3];
    for (UIView *view in [setView subviews]) {
        [view removeFromSuperview];
    }
    controllerSet=[[SettingViewController alloc] init];
    controllerSet.view.frame = CGRectMake(0,0,setView.bounds.size.width, setView.bounds.size.height-66);
    controllerSet.isUserMader = NO;
    [setView addSubview:controllerSet.view];
}

-(void)clickMenuNew{
    setView.hidden = YES;
    firstView.hidden = YES;
    newViw.hidden = NO;
    userView.hidden = YES;
   // [self performSelector:@selector(resetMe:) withObject:NO afterDelay:0.3];
    for (UIView *view in [newViw subviews]) {
        [view removeFromSuperview];
    }
	 controllerNew=[[NewSViewController alloc] init];
    [controllerNew refreshData];
    controllerNew.view.frame = CGRectMake(0,0,newViw.bounds.size.width, newViw.bounds.size.height-60);
	[newViw addSubview:controllerNew.view];
    
}
#pragma mark - BubbleCell Delegate
-(void)CellStateChanged:(NSDictionary*)dict{
	
//	int index=[[dict objectForKey:@"index"] integerValue];
//	NSString* state=[dict objectForKey:@"state"];
	
	/*
	PrivateImage* item=(PrivateImage*) arrData[index];
	switch ([state integerValue]) {
		case 0:
		{
//			if (cartBar.hidden) {
//				[self showCartBar];
//			}
			item.State=PrivateImageStateNormal;
//			selectedCount--;
//			if (selectedCount<0) {
//				selectedCount=0;
//			}
//			selectedAmount-=10;
//			if (selectedAmount<0) {
//				selectedAmount=0;
//			}
		}
			break;
			
		case 1:
		{
//			if (cartBar.hidden) {
//				[self showCartBar];
//			}
			item.State=PrivateImageStateSelected;
//			selectedCount++;
//			selectedAmount+=10;
		}
			break;
		case 3:
		{
			item.State=PrivateImageStateDownloaded;
		}
			break;
	}
	*/
	
//	lblSelectedCount.text=[NSString stringWithFormat:@"选择图片\n%d",selectedCount];
//	lblSelectedAmount.text=[NSString stringWithFormat:@"需支付靓点\n%d",selectedAmount];
}

-(void)CellLongPressBegan:(NSDictionary*)dict{
    if ([AppHelper getIntConfig:confUserCoin ] <=1&&[AppHelper getIntConfig:confUserId]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"靓点不足"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
       
        return;
    }
	NSString* url=[dict objectForKey:@"url"];
	int second=[[dict objectForKey:@"second"] integerValue];
	int curCellTag=[[dict objectForKey:@"tag"] integerValue];
    curTabTag = curCellTag;
	curCellCol=[[dict objectForKey:@"col"] integerValue];
	int curCellId = [[dict objectForKey:@"curId"] integerValue];
   //  int row = [[dict objectForKey:@"row"] intValue];
     TrendsCell *cell=(TrendsCell *)[dongtaiController.tableView viewWithTag:curCellTag];
    cell.curInfo.Second = second;
	[btnTimer setTitle:[NSString stringWithFormat:@"%d秒",second] forState:UIControlStateNormal];
	bgPreview.hidden=NO;
//	imgPreview.image=[UIImage imageWithContentsOfFile:url];
    [imgPreview setImageWithURL:[NSURL URLWithString:url]];
	
	if (cell.timerCountDown) {
		[cell.timerCountDown invalidate];
	}
  int  userId =  [AppHelper getIntConfig:confUserId];
    if (curCellId != userId) {
        cell.timerCountDown=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTimer:) userInfo:dict repeats:YES];
    }else{
        [dongtaiController changeLblSec:second celltag:curCellTag];
    }
	
}

-(void)CellLongPressEnded:(NSDictionary*)dict{
//	if (self.timerCountDown) {
//		[self.timerCountDown invalidate];
//	}
    int curCellTag=[[dict objectForKey:@"tag"] integerValue];
     int row = [[dict objectForKey:@"row"] intValue];
	[self changeLblSec:curCellTag withRow:row];
	bgPreview.hidden=YES;
}

-(void)CellLongPressCancelled:(NSDictionary*)dict{
    int curCellTag=[[dict objectForKey:@"tag"] integerValue];
     int row = [[dict objectForKey:@"row"] intValue];
     TrendsCell *cell=(TrendsCell *)[dongtaiController.tableView viewWithTag:curCellTag];
	if (cell.timerCountDown) {
		[cell.timerCountDown invalidate];
	}
	[self changeLblSec:curCellTag withRow:row];
	bgPreview.hidden=YES;
}

-(void)changeLblSec:(int)curCellTag withRow:(int)row{
   // TrendsCell *cell=(TrendsCell *)[dongtaiController.tableView viewWithTag:curCellTag];
    if (curCellTag>0) {
        PrivateImage*currInfo = dongtaiController.arrImage[row];
		int second= currInfo.Second;//cell.curInfo.Second;//[[btnTimer.titleLabel.text stringByReplacingOccurrencesOfString:@"秒" withString:@""] intValue];
		[dongtaiController changeLblSec:second celltag:curCellTag];
	}
}
 

#pragma mark - Timer
-(void)showTimer:(NSTimer *)timer{
    NSDictionary * dic = [timer userInfo] ;
    int curCellTag = [[dic objectForKey:@"tag"] intValue];
    int row = [[dic objectForKey:@"row"] intValue];
    NSLog(@"row===%d",row);
     TrendsCell *cell=(TrendsCell *)[dongtaiController.tableView viewWithTag:curCellTag];
	//if (bgPreview.hidden) {
        [self changeLblSec:curCellTag withRow:row];
		//return;
	//}
     PrivateImage*currInfo = dongtaiController.arrImage[row];
	int second=currInfo.Second;// cell.curInfo.Second;//[[btnTimer.titleLabel.text stringByReplacingOccurrencesOfString:@"秒" withString:@""] intValue];
	if (second<=0) {
        if (timer) {
            [timer invalidate];
        }
		[self changeLblSec:curCellTag withRow:row];
		bgPreview.hidden=YES;
        if (curTabTag ==curCellTag) {
            [btnTimer setTitle:@"0秒" forState:UIControlStateNormal];
            btnTimer.hidden = YES;
        }
		return;
	}
	else{
        second--;
         cell.curInfo.Second = second;
        NSLog(@"second===%d",second);
        currInfo.Second = second;
        [dongtaiController.arrImage replaceObjectAtIndex:row withObject:currInfo];
        if (curTabTag ==curCellTag) {
            [btnTimer setTitle:[NSString stringWithFormat:@"%d秒",second] forState:UIControlStateNormal];           
        }
		
	}
}


#pragma mark - Notification
-(void)becomeActive{

}

-(void)resignActive{

}

-(void)resetMe:(BOOL)animated{
    if (isShowMenu) {
        isShowMenu=NO;
        [self showMenu:animated];
    }
    if (isShowFriend) {
        isShowFriend=NO;
        [self showFriend:animated];
    }
    [botBar resetBar:YES];
    maskView.hidden=YES;
}

-(void)gotoDetailView:(PrivateImage*)info{
	if ([AppHelper isValidatedUser]) {
		DetailViewController* controller=[[DetailViewController alloc] init];
		controller.curInfo=info;
		controller.bubbleDelegate=self;
		[self.navigationController pushViewController:controller animated:YES];
	}
}

-(void)gotoUserViewByImageInfo:(PrivateImage*)info{
	if ([AppHelper isValidatedUser]) {
		UserViewController* controller=[[UserViewController alloc] init];
		controller.curUserInfo=[[UserInfo alloc] init];
		controller.curUserInfo.UserId=info.UserId;
		controller.curUserInfo.AvatarURL=info.AvatarUrl;
		controller.curUserInfo.UserName=info.UserName;
		[self.navigationController pushViewController:controller animated:YES];
//		DetailViewController* controller=[[DetailViewController alloc] init];
//		controller.curInfo=info;
//		[self.navigationController pushViewController:controller animated:YES];
	}
}
-(void)gotoFriendView:(int)mode{
    FindFriendViewController *findFirind = [[FindFriendViewController alloc] init];
    [self.navigationController  pushViewController:findFirind animated:YES];
}
-(void)gotoUserView:(UserInfo*)info{
	if ([AppHelper isValidatedUser]) {
		UserViewController* controller=[[UserViewController alloc] init];
		controller.curUserInfo=info;
		[self.navigationController pushViewController:controller animated:YES]; 
	}
}


-(void)gotoGiftView:(PrivateImage *)info{
    GiftViewController* controller=[[GiftViewController alloc] init];
    controller.curInfo=info;
    [[HomeViewController shared] presentViewController:controller animated:YES completion:nil];
}
-(void)gotoMoreGiftView:(PrivateImage *)info{
    MoreGiftViewController* controller=[[MoreGiftViewController alloc] init];
    controller.curInfo=info;
    //[[HomeViewController shared] presentViewController:controller animated:YES completion:nil];
    [self.navigationController pushViewController:controller animated:YES]; 
}
-(void)notificationCustom:(NSNotification*)notification{
    int noticeID=[[notification.userInfo objectForKey:NOTIFICATION_KEYNAME] intValue];
    switch (noticeID) {   
		default:
			break;
	}
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[HomeViewController shared] ApliyView];
}
@end
