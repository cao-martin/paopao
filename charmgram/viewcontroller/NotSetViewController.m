//
//  NotSetViewController.m
//  charmgram
//
//  Created by martin on 13-8-23.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "NotSetViewController.h"

@interface NotSetViewController ()<UITableViewDataSource,UITableViewDelegate>
{
   NSMutableArray *arrCaption;
    UITableView *tbInput;
}
@end

@implementation NotSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopbarHeight)];
    topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    [self.view addSubview:topbar];
    
    UILabel* lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 24)];
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.text=@"设置";
    lblTitle.font=[UIFont boldSystemFontOfSize:20.0];
    [topbar addSubview:lblTitle];
	
	UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_off"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_on"] forState:UIControlStateHighlighted];
    btnCancel.frame=CGRectMake(8, 0, 54,44);
    [btnCancel addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnCancel];
	
	tbInput=[[UITableView alloc] initWithFrame:CGRectMake(0, kTopbarHeight, kDeviceWidth, kDeviceHeight-kTopbarHeight-20) style:UITableViewStyleGrouped];
	tbInput.backgroundColor=[UIColor whiteColor];
	tbInput.backgroundView=nil;
	tbInput.dataSource=self;
	tbInput.delegate=self;
	[self.view addSubview:tbInput];
	[self initArray];
}

-(void)initArray{
	arrCaption=[[NSMutableArray alloc] initWithCapacity:0];
	[arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"被赞",@"caption",@"uiswich",@"type", [AppHelper getStringConfig:confZanNotOn], @"value",nil]];
	[arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"被关注",@"caption",@"uiswich",@"type",[AppHelper getStringConfig:confGuanZhuNotOn], @"value", nil]];
	[arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"私信",@"caption",@"uiswich",@"type", [AppHelper getStringConfig:confShiXinNotOn],@"value",nil]];
    [arrCaption addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"礼物",@"caption",@"uiswich",@"type", [AppHelper getStringConfig:confLiWuNotOn], @"value",nil]];
   

}


#pragma mark - Tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [arrCaption count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	static NSString* cellId=@"mycell";
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
	if (!cell) {
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
	}
	cell.selectionStyle=UITableViewCellSelectionStyleGray ;
	int row=indexPath.row;
	NSDictionary* dict=(NSDictionary*)[arrCaption objectAtIndex:row];
	cell.textLabel.text=[NSString stringWithFormat:@" %@",  [dict objectForKey:@"caption"]];
	cell.textLabel.textAlignment=UITextAlignmentLeft;
	cell.textLabel.font=[UIFont boldSystemFontOfSize:18.0];

	NSString* ctype=[dict objectForKey:@"type"];
	NSString* val=[dict objectForKey:@"value"];

    if ([ctype isEqualToString:@"uiswich"]) {
		UISwitch *notSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 7, 70, 30)];
        [notSwitch setOnTintColor:[UIColor colorWithRed:0 green:0.5 blue:0.72 alpha:1]];
        notSwitch.tag = row+100+1;
        notSwitch.on = [val boolValue];
        [notSwitch addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:notSwitch];
	}
	return cell;
}
-(void)changeValue:(UISwitch *)switchView{
    __weak NSString *type = [NSString stringWithFormat:@"%d",switchView.tag-100];
    __weak NSString *status = [NSString stringWithFormat:@"%d",switchView.on];
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=20;
    [asirequest setPostValue:METHOD_UPDATEPUSH forKey:@"method"];
    [asirequest setPostValue:[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
    [asirequest setPostValue:type forKey:@"type"];
   [asirequest setPostValue:status forKey:@"status"];
    
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        NSLog(@"JSON====%@",JSON);
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        [AppHelper hideHUD:self.view];
        if (code==REQUEST_CODE_SUCCESS) {
            NSString *modeType;
            switch ([type intValue]) {
                case 1:
                    modeType = confZanNotOn;
                    break;
                case 2:
                    modeType = confGuanZhuNotOn;
                    break;
                case 3:
                    modeType = confShiXinNotOn;
                    break;
                case 4:
                    modeType = confLiWuNotOn;
                    break;
                default:
                    break;
            }
            [AppHelper setStringConfig:modeType val:status];
            // [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
    }];
    [asirequest setFailedBlock:^{
        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];

}
-(void)clickBack{
	[self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
