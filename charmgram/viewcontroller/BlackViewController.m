//
//  BlackViewController.m
//  charmgram
//
//  Created by martin on 13-9-11.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "BlackViewController.h"

@interface BlackViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrBlack;
    UITableView * tbBlack;
}
@end

@implementation BlackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
      [self loadBlackList];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:(43/255.0f) green:(45/255.0f) blue:(52/255.0f) alpha:1.0f];

    arrBlack = [NSMutableArray new];
    UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopbarHeight)];
    topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    [self.view addSubview:topbar];
    
    UILabel* lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 24)];
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.text=@"黑名单";
    lblTitle.font=[UIFont boldSystemFontOfSize:20.0];
    [topbar addSubview:lblTitle];
    
    UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_off"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_on"] forState:UIControlStateHighlighted];
    btnCancel.frame=CGRectMake(8, 0, 54,44);
    [btnCancel addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnCancel];
	// Do any additional setup after loading the view.
    tbBlack=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, kDeviceHeight-110) style:UITableViewStylePlain];
    tbBlack.dataSource=self;
    tbBlack.delegate=self;
    tbBlack.backgroundColor=[UIColor clearColor];
    tbBlack.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tbBlack];
  
}
-(void)loadBlackList{
    [AppHelper showHUD:@"数据加载中" baseview:self.view];
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
	int myuserid=[AppHelper getIntConfig:confUserId];
    [asirequest setPostValue:METHOD_MYBLACKLIST forKey:@"method"];
    // [asirequest setPostValue:METHOD_DELBLACK forKey:@"method"];
    //[asirequest setPostValue:METHOD_MYBLACKLIST forKey:@"method"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", myuserid] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	
    [asirequest setCompletionBlock:^{
        [AppHelper hideHUD:self.view];
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        // NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            NSLog(@"JSON===%@",JSON);
            id data=[JSON objectForKey:@"data"];
            for (NSDictionary *di in data) {
				 UserInfo *item = [[UserInfo alloc] initWithDict:di];
                [arrBlack addObject:item];
            }
            [tbBlack reloadData];
        }
		else{
            
		}
    }];
    [asirequest setFailedBlock:^{
         [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
}
-(void)deleteList:(UIButton *)btn{
   UserInfo* item=[arrBlack objectAtIndex:btn.tag];
    [AppHelper showHUD:@"数据加载中" baseview:self.view];
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
	int myuserid=[AppHelper getIntConfig:confUserId];
    [asirequest setPostValue:METHOD_DELBLACK forKey:@"method"];
    // [asirequest setPostValue:METHOD_DELBLACK forKey:@"method"];
    //[asirequest setPostValue:METHOD_MYBLACKLIST forKey:@"method"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", myuserid] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", item.UserId] forKey:@"blackid"];
    [asirequest setCompletionBlock:^{
        [AppHelper hideHUD:self.view];
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
         NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            NSLog(@"JSON===%@",JSON);
            
            id data=[JSON objectForKey:@"data"];
            if ([data isEqual:@"fail"]) {
             // [AppHelper showAlertMessage:msg];
            }else{
                [arrBlack removeObjectAtIndex:btn.tag];
                [tbBlack reloadData];
            }
            
        }
		else{
            
		}
    }];
    [asirequest setFailedBlock:^{
        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
}
-(void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      
    return arrBlack.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID2=@"mycell";
    UserCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID2];
    if (!cell) {
        cell=[[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
    }
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(250, 10, 60, 25)];
    btn.tag = indexPath.row;
    [btn setTitle:@"解除黑名单" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    [btn addTarget:self action:@selector(deleteList:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
    int row=indexPath.row;
    UserInfo* item=[arrBlack objectAtIndex:row];
    item.UserName = item.UserName;
    [cell loadData:item];
    return cell;
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	int row=indexPath.row;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
