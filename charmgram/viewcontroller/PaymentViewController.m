//
//  PaymentViewController.m
//  charmgram
//
//  Created by Rui Wei on 13-5-12.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "PaymentViewController.h"


@interface PaymentViewController ()<SKProductsRequestDelegate>

@end

@implementation PaymentViewController
@synthesize _strAddress,_strDay,_strMoney,sProduct,_strNongli,_strPayName;
 

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrProducts = [[NSMutableArray alloc] init];
    
	UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopbarHeight)];
    topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    [self.view addSubview:topbar];
    
    UILabel* lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 24)];
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.text=@"购买靓点";
    lblTitle.font=[UIFont boldSystemFontOfSize:20.0];
    [topbar addSubview:lblTitle];
	
	UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_off"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_back_on"] forState:UIControlStateHighlighted];
    btnCancel.frame=CGRectMake(8, 0, 54,44);
    [btnCancel addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnCancel];
    
    
   
    UIView *viewBg=[[UIView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth,  kDeviceHeight - 44)] ;
    viewBg.backgroundColor = [UIColor colorWithRed:245/255.0 green:241/255.0 blue:229/255.0 alpha:1.0];
    [self.view addSubview:viewBg];
	
    tbContent=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, kDeviceHeight-60) style:UITableViewStyleGrouped];
    tbContent.dataSource=self;
    tbContent.delegate=self;
    tbContent.backgroundColor=[UIColor clearColor];
    tbContent.backgroundView=nil;
    [self.view addSubview:tbContent];
	
    UIView* footer=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
    footer.backgroundColor=[UIColor clearColor];
    
    UIButton* btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOk setBackgroundImage:[UIImage imageNamed:@"confimpay_button.png"] forState:UIControlStateNormal];
    [btnOk setBackgroundImage:[UIImage imageNamed:@"confimpay_button_hover.png"] forState:UIControlStateHighlighted];
    btnOk.frame = CGRectMake( (kDeviceWidth - 299) / 2, 12, 299, 42);
    [btnOk addTarget:self action:@selector(gotoPayPage) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btnOk];
    [tbContent setTableFooterView:footer]; 
    
    selectedIndex=0;
	
    NSArray* arr=[_strPayName componentsSeparatedByString:@" "];
    arrPayInfo=[[NSMutableArray alloc] initWithCapacity:0];
    [arrPayInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"您的订单信息：",@"caption",_strPayName,@"value", nil]];
    [arrPayInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"支付金额：",@"caption",_strMoney,@"value", nil]];
    if (_strDay && _strDay.length>0) {
        [arrPayInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"祈福日期：",@"caption",_strDay,@"value", nil]];
    }
    if (_strAddress && _strAddress.length>0) {
        [arrPayInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"祈福地点：",@"caption",_strAddress,@"value", nil]];
    }
    

    
    [self initObservers];
}


-(void)initObservers{

}


-(void)releaseObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewWillAppear:(BOOL)animated{
    //[[AppDelegate App] ShowBottomTab:YES];
    
    self.navigationController.navigationBarHidden=YES;
    [self checkPayorNot];
    [super viewWillAppear:animated];
    
}

-(void)notificationPay:(NSNotification*)notification{
    
//    if (self.paydoneblock) {
//        self.paydoneblock();
//    }
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        [self.presentingViewController dismissModalViewControllerAnimated:YES]; // for IOS 5+
    } else {
        [self.parentViewController dismissModalViewControllerAnimated:YES]; // for pre IOS 5
    }
}

-(void)gotoPayPage
{
    SKPayment * payment = [SKPayment paymentWithProduct:sProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];

}

#pragma mark -----------------------------------------------
#pragma mark 购买靓点相关










- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
	
	
	[self dispAlert:@"警告" message:[error localizedDescription]];
}

- (void)requestDidFinish:(SKRequest *)request{
	
}


- (void)onTimeOut:(NSTimer *)tm{
	[self dispAlert:@"超时" message:@"获取超时"];
}


- (void)dispAlert:(NSString *)titl message:(NSString *)mess{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titl message:mess delegate:nil cancelButtonTitle:@"撤销" otherButtonTitles:nil];
	[alert show];
}



-(void)getwebpage{
    NSLog(@"%@===%@===%@",_strMoney,_strNo,_strPayName);
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://paopaobeauty.com/photoshare/wappay/alipayapi.php"]];
	//[asirequest setPostValue:METHOD_GETUNIQUEID forKey:@"method"];
    [asirequest setPostValue:_strPayName forKey:@"WIDsubject"];
    [asirequest setPostValue:_strNo forKey:@"WIDout_trade_no"];
    [asirequest setPostValue:_strMoney forKey:@"WIDtotal_fee"];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	
    [asirequest setCompletionBlock:^{
        WebViewController *webController = [[WebViewController alloc] init];
        webController.isModalView = YES;
        NSString* respString=[wrequest responseString];
        [self presentModalViewController:webController animated:YES];
        [webController loadHtml:respString];
    }];
    [asirequest setFailedBlock:^{
		[AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];

}
-(void)clickPayType:(UIButton*)btn{
    int itag=btn.tag;
    for (int k=0; k<arrPayType.count; k++) {
        UIImageView* imgCK=(UIImageView*)[viewPayBg viewWithTag:10+k];
        if (imgCK.tag+90==itag) {
            [imgCK setImage:[UIImage imageNamed:@"checkbox_checked" ]];
            selectedIndex=k;
        }
        else{
            [imgCK setImage:[UIImage imageNamed:@"checkbox" ]];
        }
    }
}

-(void)clickBack
{
    //[[AppDelegate App] ShowBottomTab:NO];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)closeMe{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [self dismissModalViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkPayorNot{
    if (_strNo.length>0) {
 
    }
}

#pragma mark - TableView
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 36.0;
    }
    else{
        return 46.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 4.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"支付信息";
    }
    else{
        return @"选择支付方式";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return arrPayInfo.count;
    }
    else{
        return 2;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int section=indexPath.section;
    int row=indexPath.row;
    UITableViewCell* cell=nil;
    if (section==0) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"] ;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor whiteColor];
        NSDictionary* dict=[arrPayInfo objectAtIndex:row];
        cell.textLabel.text=[dict objectForKey:@"caption"];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        cell.textLabel.font=[UIFont systemFontOfSize:14.0]; 
        
        UILabel* lbl=[[UILabel alloc] initWithFrame:CGRectMake(130, 0, 155, 36)];
        lbl.text=[dict objectForKey:@"value"];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.textAlignment=UITextAlignmentRight;
        lbl.font=[UIFont systemFontOfSize:16.0]; 
        [cell.contentView addSubview:lbl]; 
    }
    else{
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"] ;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        cell.backgroundColor=[UIColor whiteColor];
        NSDictionary* dict=[arrPayType objectAtIndex:row];
        UIImageView* img=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 22)];
        img.image=[UIImage imageNamed:[dict objectForKey:@"icon"]];
        img.contentMode=UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:img]; 
        
        UILabel* lbl=[[UILabel alloc] initWithFrame:CGRectMake(55, 4, 200, 18)];
        lbl.text=[dict objectForKey:@"caption"];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.font=[UIFont boldSystemFontOfSize:16.0]; 
        [cell.contentView addSubview:lbl];
        
        UILabel* lblsub=[[UILabel alloc] initWithFrame:CGRectMake(55, 23, 200, 18)];
        lblsub.text=[dict objectForKey:@"note"];
        lblsub.textColor=[UIColor colorWithWhite:0.35 alpha:1.0];
        lblsub.font=[UIFont systemFontOfSize:11.0];
        lblsub.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:lblsub]; 
        
        UIImageView *imgCK = [[UIImageView alloc] initWithFrame:CGRectMake( 260, 13 , 19, 19)];
        imgCK.image = [UIImage imageNamed:row==0?@"checkbox_checked":@"checkbox"];
        imgCK.tag=90+row;
        [cell.contentView addSubview:imgCK]; 
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        int itag=indexPath.row+90;
        for (int k=0; k<arrPayType.count; k++) {
            UIImageView* imgCK=(UIImageView*)[tableView viewWithTag:90+k];
            if (imgCK.tag==itag) {
                [imgCK setImage:[UIImage imageNamed:@"checkbox_checked" ]];
                selectedIndex=k;
            }
            else{
                [imgCK setImage:[UIImage imageNamed:@"checkbox" ]];
            }
        }
    }
}
@end
