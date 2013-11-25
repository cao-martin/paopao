//
//  MenuViewController.m
//  PhotoFrame
//
//  Created by Rui Wei on 13-3-10.
//  Copyright (c) 2013年 wujin. All rights reserved.
//

#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "MLPAccessoryBadge.h"
@interface MenuViewController ()
{
    MLPAccessoryBadge *accessoryBadge;
}
@end

@implementation MenuViewController
@synthesize delegate;
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor=[UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    
//    UIImageView* imgBg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg"]];
//    imgBg.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
//    imgBg.contentMode=UIViewContentModeScaleAspectFill;
//    imgBg.userInteractionEnabled=YES;
    
    UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
    topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    
    UILabel* lblTitle= [[UILabel alloc] initWithFrame:CGRectMake(0, 11, kMenuPanelWidth, 22)];
    lblTitle.text=@"泡泡美女";
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.font=[UIFont boldSystemFontOfSize:22.0];
    lblTitle.userInteractionEnabled=YES;
	lblTitle.shadowColor=[UIColor blackColor];
	lblTitle.shadowOffset=CGSizeMake(1, 1);
    [topbar addSubview:lblTitle];
    
    UILabel* lblVersion= [[UILabel alloc] initWithFrame:CGRectMake(0, 23, kMenuPanelWidth-12, 16)];
    lblVersion.hidden = YES;
    lblVersion.text=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    lblVersion.textAlignment=UITextAlignmentRight;
    lblVersion.backgroundColor=[UIColor clearColor];
    lblVersion.textColor=[UIColor whiteColor];
    lblVersion.font=[UIFont systemFontOfSize:12.0];
	lblVersion.shadowColor=[UIColor blackColor];
	lblVersion.shadowOffset=CGSizeMake(1, 1);
    [topbar addSubview:lblVersion];
    
    UIView *userbar=[[UIView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, 64)];
    userbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_account_base"]];

    UIButton *btnSetting=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSetting setImage:[UIImage imageNamed:@"menu_settings_off"] forState:UIControlStateNormal];
    [btnSetting setImage:[UIImage imageNamed:@"menu_settings_on"] forState:UIControlStateHighlighted];
    [btnSetting addTarget:self action:@selector(clickSetting) forControlEvents:UIControlEventTouchUpInside];
    btnSetting.frame=CGRectMake(kMenuPanelWidth-66, 8, 56, 48);
    [userbar addSubview:btnSetting];
    
    tbView=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, kMenuPanelWidth, kDeviceHeight-64) style:UITableViewStylePlain];
    tbView.dataSource=self;
    tbView.delegate=self;
    tbView.backgroundColor=[UIColor clearColor];
    tbView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
//    [self.view addSubview:imgBg];
    [self.view addSubview:topbar];
//    [self.view addSubview:userbar];
    [self.view addSubview:tbView];
    [self initObservers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; 
}
-(void)initObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCustom:)
                                                 name:NOTIFICATION_TO_TRENDS
                                               object:nil];
}

-(void)notificationCustom:(NSNotification*)notification{
    
    lblCoin.text=[NSString stringWithFormat:@"靓点余额: %d",[AppHelper getIntConfig:confUserCoin]];
    [self resetMenu];
}
#pragma mark - MISC
-(void)resetMenu{
	lblName.text=[AppHelper getStringConfig:confUserName];
    
	NSString* avatarPath=[AppHelper getStringConfig:confUserHeadUrl];
	if (avatarPath.length>0) {
		[imgAvatar setImageWithURL:[NSURL URLWithString:avatarPath]];
	}
    if ([AppHelper getIntConfig:confNotCount]+[AppHelper getIntConfig:confMsgCount]) {
        accessoryBadge.hidden = NO;
    }else
        accessoryBadge.hidden = YES;
    NSNumber *numb = [NSNumber numberWithInt:[AppHelper getIntConfig:confNotCount]+[AppHelper getIntConfig:confMsgCount] ];
    [accessoryBadge setTextWithNumber:numb];
    accessoryBadge.center = CGPointMake(230, 20);
}

#pragma mark - Click Event
-(void)clickUser{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol (MenuDelegate) ]) {
		[self.delegate clickMenuFirst];
	}
}
-(void)clickFirst{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol (MenuDelegate) ]) {
		[self.delegate clickMenuFirst];
	}
}
-(void)clickSetting{
    DLog(@"Click Setting!!!");
	if (self.delegate && [self.delegate conformsToProtocol:@protocol (MenuDelegate) ]) {
		[self.delegate clickMenuSetting:NO];
	}
}
-(void)clickNew{
    DLog(@"Click Setting!!!");
	if (self.delegate && [self.delegate conformsToProtocol:@protocol (MenuDelegate) ]) {
		[self.delegate clickMenuNew];
	}
}
#pragma mark - TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 64.0;
    }
    return 44.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return (section==0) ? 0.0f :0.0f;//: 21.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    }
    int row=indexPath.row;
    int section=indexPath.section;
    cell.clipsToBounds = YES;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithRed:(38.0f/255.0f) green:(44.0f/255.0f) blue:(58.0f/255.0f) alpha:1.0f];
    cell.selectedBackgroundView = bgView;
    
    if (section==0) {
        imgAvatar=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_noimage"]];
        imgAvatar.frame=CGRectMake(10, 16, 32, 32);
        imgAvatar.contentMode=UIViewContentModeScaleAspectFill;
        imgAvatar.clipsToBounds=YES;
        [cell.contentView addSubview:imgAvatar];
        
        UIImageView* avatarBg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_account_icon_cover"]];
        avatarBg.frame=CGRectMake(2, 8, 48, 48);
        [cell.contentView addSubview:avatarBg];
        
        lblName= [[UILabel alloc] initWithFrame:CGRectMake(50, 14, kMenuPanelWidth-120, 20)];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=[UIColor whiteColor];
        lblName.text=[AppHelper getStringConfig:confUserName];
        lblName.font=[UIFont systemFontOfSize:18.0];
        [cell.contentView addSubview:lblName];
        
        lblCoin= [[UILabel alloc] initWithFrame:CGRectMake(50, 34, kMenuPanelWidth-120, 20)];
        lblCoin.backgroundColor=[UIColor clearColor];
        lblCoin.textColor=[UIColor whiteColor];
        lblCoin.text=[NSString stringWithFormat:@"靓点余额: %d",[AppHelper getIntConfig:confUserCoin]];
        lblCoin.font=[UIFont systemFontOfSize:11.0];
        [cell.contentView addSubview:lblCoin];
    }
    else{
        NSString* caption=@"";
        switch (row) {
            case 0:
                caption=@"首页";
                break;
            case 1:{
                caption=@"消息";
                accessoryBadge = [MLPAccessoryBadge new];
                if ([AppHelper getIntConfig:confNotCount]) {
                    accessoryBadge.hidden = NO;
                }else
                    accessoryBadge.hidden = YES;
                NSNumber *numb = [NSNumber numberWithInt:[AppHelper getIntConfig:confNotCount] ];
                [accessoryBadge setCornerRadius:100];
                [accessoryBadge setTextWithNumber:numb];
                [accessoryBadge setBackgroundColor:[UIColor redColor]];
                [cell setAccessoryView:accessoryBadge];

            }
                break;
            case 2:
                caption=@"设置";
                break; 
        }
        cell.textLabel.text=[NSString stringWithFormat:@" %@",caption];//caption;
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.textLabel.font=[UIFont boldSystemFontOfSize:18.0];
        
   
    }
    cell.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    cell.textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    cell.textLabel.textColor = [UIColor colorWithRed:(196.0f/255.0f) green:(204.0f/255.0f) blue:(218.0f/255.0f) alpha:1.0f];
    
    UIImageView* imgArrow=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_rear_accessory_arrow"]];
    imgArrow.frame=CGRectMake(kMenuPanelWidth-30, 12, 11, 19);
    if (section==0) {
        imgArrow.frame=CGRectMake(kMenuPanelWidth-30, 22, 11, 19);
    }
    [cell.contentView addSubview:imgArrow];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 43.0f, kMenuPanelWidth, 1.0f)];
    if (section==0) {
        bottomLine.frame=CGRectMake(0.0f, 63.0, kMenuPanelWidth, 1.0f);
    }
    else{
    
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kMenuPanelWidth, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(54.0f/255.0f) green:(61.0f/255.0f) blue:(76.0f/255.0f) alpha:1.0f];
		[cell.contentView addSubview:topLine];
		
		UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, kMenuPanelWidth, 1.0f)];
		topLine2.backgroundColor = [UIColor colorWithRed:(54.0f/255.0f) green:(61.0f/255.0f) blue:(77.0f/255.0f) alpha:1.0f];
		[cell.contentView addSubview:topLine2]; 
    }
    bottomLine.backgroundColor = [UIColor colorWithRed:(40.0f/255.0f) green:(47.0f/255.0f) blue:(61.0f/255.0f) alpha:1.0f];
    [cell.contentView addSubview:bottomLine];
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//	NSString *headerText = @"快速导航";
//	UIView *headerView = nil;
//	if (section==1) {
//		headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 21.0f)];
//		CAGradientLayer *gradient = [CAGradientLayer layer];
//		gradient.frame = headerView.bounds;
//		gradient.colors = @[
//                      (id)[UIColor colorWithRed:(67.0f/255.0f) green:(74.0f/255.0f) blue:(94.0f/255.0f) alpha:1.0f].CGColor,
//                      (id)[UIColor colorWithRed:(57.0f/255.0f) green:(64.0f/255.0f) blue:(82.0f/255.0f) alpha:1.0f].CGColor,
//                      ];
//		[headerView.layer insertSublayer:gradient atIndex:0];
//		
//		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)];
//		textLabel.text = headerText;
//		textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:([UIFont systemFontSize] * 0.8f)];
//		textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
//		textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
//		textLabel.textColor = [UIColor colorWithRed:(125.0f/255.0f) green:(129.0f/255.0f) blue:(146.0f/255.0f) alpha:1.0f];
//		textLabel.backgroundColor = [UIColor clearColor];
//		[headerView addSubview:textLabel];
//		
//		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
//		topLine.backgroundColor = [UIColor colorWithRed:(78.0f/255.0f) green:(86.0f/255.0f) blue:(103.0f/255.0f) alpha:1.0f];
//		[headerView addSubview:topLine];
//		
//		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 21.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
//		bottomLine.backgroundColor = [UIColor colorWithRed:(36.0f/255.0f) green:(42.0f/255.0f) blue:(5.0f/255.0f) alpha:1.0f];
//		[headerView addSubview:bottomLine];
//	}
//	return headerView;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row=indexPath.row;
    if (indexPath.section==1) {
        switch (row) {
            case 0:
            {
                [[HomeViewController shared] changeTab:1];
                [[HomeViewController shared] resetMe:YES];
                [self clickFirst];
            }
                
                break;
            case 1:{
                [[HomeViewController shared] resetMe:YES];
                [self clickNew];
            }
                
                break;
            case 2:
            {
                [[HomeViewController shared] resetMe:YES];
                [self clickSetting];
            }
                
                break;
        }
    }else{

        
        UserInfo *info = [UserInfo new];
        info.UserId=[AppHelper getIntConfig:confUserId];
		info.AvatarURL=[AppHelper getStringConfig:confUserHeadUrl];
		info.UserName=[AppHelper getStringConfig:confUserName];
        [[HomeViewController shared] gotoUserView:info];
    }
}

@end