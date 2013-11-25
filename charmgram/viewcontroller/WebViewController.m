//
//  WebViewController.m
//  woqifu
//
//  Created by Rain on 13-3-16.
//  Copyright (c) 2013年 woqifu. All rights reserved.
//

#import "WebViewController.h"
#import "AppHelper.h"
#import "Constants.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
@interface WebViewController ()

@end

@implementation WebViewController
@synthesize isModalView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *topBar=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    topBar.image=[UIImage imageNamed:@"navi_bg"];
    
    _lblName =[[UILabel alloc] initWithFrame:CGRectMake(45, 10, kDeviceWidth-45, 24.0)];
    _lblName.textColor=[UIColor colorWithRed:139/255.0 green:105/255.0 blue:95/255.0 alpha:1.0];
    _lblName.font=[UIFont boldSystemFontOfSize:18.0];
    _lblName.text=@"正在加载...";
    _lblName.backgroundColor=[UIColor clearColor];
    _lblName.textAlignment=UITextAlignmentCenter;
    
	UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"header_btn_back_off"] forState:UIControlStateNormal];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"header_btn_back_on"] forState:UIControlStateHighlighted];
    btnBack.frame=CGRectMake(8, 0, 54,44);
    [btnBack addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 39, kDeviceWidth, kDeviceHeight-59)];
    webView.scalesPageToFit =YES;
    webView.delegate = self;
    
    [self.view addSubview:topBar];
    [self.view addSubview:_lblName];
    [self.view addSubview:btnBack];
    [self.view addSubview:webView];
	
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
}

#pragma mark - Click Events
-(void)clickBack{
    if (isModalView) {
        [self dismissModalViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)loadURL:(NSString*)strUrl{
    if (strUrl.length==0) {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.woqifu.com"]]];
        return;
    }
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]]];
}
-(void)loadHtml:(NSString *)html{
    NSLog(@"html===%@",html);
    [webView loadHTMLString:html baseURL:nil];
}
#pragma mark - webview

- (void)webViewDidFinishLoad:(UIWebView *)webvw {
    _lblName.text = [webvw stringByEvaluatingJavaScriptFromString:@"document.title"];
    [hud hide:YES afterDelay:0.5];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [hud hide:YES afterDelay:0.5];
}

- (void)webViewDidStartLoad:(UIWebView *)webView { 
    hud.labelText = @"加载中...";
    [hud show:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
    navigationType:(UIWebViewNavigationType)navigationType{
    //http://paopaobeauty.com/photoshare/wappay/call_back_url.php?out_trade_no=10057&request_token=requestToken&result=success&trade_no=2013072723865983&sign=QeWuLXhQ%2BL42qTQWsMSP8DB1ji2K1eEgXWKLmwnl7dSJ%2BcT3r6C8AqUYldiE65tuZTqJaSn4GAe5gV1%2BrZ571eYcYWOa62SK%2F9V1MemD2uh8yxtI55UmSX4t9SaElVbfRZELVe4vZphgzZukQXRK2eIUcAzrYV7bRA7%2Bvb5CaDE%3D&sign_type=0001
    NSString *urlString = [[request URL] absoluteString];
    NSLog(@"urlString===%@",urlString);
    if ([urlString hasPrefix:@"http://paopaobeauty.com/photoshare/wappay/call_back_url.php?"]) {
        [self updateCoin];
    }
//    NSArray *urlComps = [urlString componentsSeparatedByString:@":"];
//    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"about"]){
////    if ([urlString hasPrefix:@"qifu."]) {
// 
//        NSString *funcStr = [urlComps objectAtIndex:1];
//        if([funcStr hasPrefix:@"blank"])
//        {
////            [self updateCoin];
////            [self dismissModalViewControllerAnimated:NO];
////            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Custom_ClosePay object:nil];
//        }
//        return NO;
//    }
    return YES;
}
-(void)updateCoin{
    NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	[asirequest setPostValue:METHOD_USER_STATUS forKey:@"method"];
	[asirequest setPostValue:userid forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            NSString* coin=[JSON objectForKey:@"data"];
            int coinInt =[coin intValue];
            NSLog(@"JSON===%@",JSON);
            if (coinInt) {
                [AppHelper setIntConfig:confUserCoin val:coinInt];
            }
            [self dismissModalViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TO_TRENDS object:nil];
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
- (void)viewDidUnload
{ 
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 


@end
