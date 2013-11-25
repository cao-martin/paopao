//
//  UserListViewController.m
//  charmgram
//
//  Created by Rain on 13-7-7.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "UserListViewController.h"

@interface UserListViewController ()

@end

@implementation UserListViewController
@synthesize isFanList;
 

- (void)viewDidLoad
{
    [super viewDidLoad];

	UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopbarHeight)];
    topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    
    lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 24)];
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.textColor=[UIColor whiteColor];
	//    lblTitle.text=@"账号登录";
    lblTitle.font=[UIFont boldSystemFontOfSize:20.0];
    [topbar addSubview:lblTitle];
    
    UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"navi_back_btn"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"navi_back_btn_h"] forState:UIControlStateHighlighted];
    btnCancel.frame=CGRectMake(8, 6, 52,32);
    btnCancel.titleLabel.font=[UIFont boldSystemFontOfSize:12.0];
    //[btnCancel setTitle:@"  返回" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnCancel];
    
    [self.view addSubview:topbar];
    
    tbContent=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];
	tbContent.dataSource=self;
	tbContent.delegate=self;
	tbContent.backgroundColor=[UIColor colorWithRed:234/255.0 green:230/255.0 blue:231/255.0 alpha:1.0];
    tbContent.separatorStyle=UITableViewCellSeparatorStyleNone;
	tbContent.showsVerticalScrollIndicator=YES; 
    [self.view addSubview:tbContent];
    
    arrUser=[[NSMutableArray alloc] initWithCapacity:0];
}
 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)refreshData{
    if (self.isFanList) {
        [self loadFanFromWeb];
    }
    else{
        [self loadFollowFromWeb];
    }
}

-(void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    return arrUser.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID=@"cellID";
    UserCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    int row=indexPath.row;
    cell.isFullScreen=YES;
    UserInfo* item=[arrUser objectAtIndex:row];
    [cell loadData:item];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfo *info = [arrUser objectAtIndex:indexPath.row];
    UserViewController* controller=[[UserViewController alloc] init];
    controller.curUserInfo=info;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Load Data
-(void)loadFollowFromWeb{
	NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
    NSString *ownerid = [NSString stringWithFormat:@"%d",_listUserid];
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	[asirequest setPostValue:METHOD_MYFOLLOW forKey:@"method"];
	[asirequest setPostValue:userid forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:ownerid forKey:@"ownerid"];
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
			
            [arrUser removeAllObjects];
            
            for (NSDictionary *di in data) {
				UserInfo* item=[[UserInfo alloc] initWithDict:di];
                [arrUser addObject:item];
            }
            [tbContent reloadData];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
    }];
    [asirequest setFailedBlock:^{
        //        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
	
}

-(void)loadFanFromWeb{
	NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
    NSString *ownerid = [NSString stringWithFormat:@"%d",_listUserid];
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	[asirequest setPostValue:METHOD_MYFAN forKey:@"method"];
	[asirequest setPostValue:userid forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:ownerid forKey:@"ownerid"];
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
			
            [arrUser removeAllObjects];
            
            for (NSDictionary *di in data) {
				UserInfo* item=[[UserInfo alloc] initWithDict:di];
                [arrUser addObject:item];
            }
            [tbContent reloadData];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
    }];
    [asirequest setFailedBlock:^{
        //        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
	
}
@end
