//
//  ThirdLoginViewController.m
//  charmgram
//
//  Created by lide on 13-7-6.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "ThirdLoginViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "SinaWeiboRequest.h"
#import "QYAPIClient.h"
#import "ASIHTTPRequest.h"

@interface ThirdLoginViewController ()

@end

@implementation ThirdLoginViewController

@synthesize url = _url;
@synthesize oauthType = _oauthType;

#pragma mark - private

- (void)clickCloseButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
//    _backButton.hidden = YES;
//    _closeButton.hidden = NO;
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _headView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_headView];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(2, 2, 40, 40);
    _closeButton.backgroundColor = [UIColor whiteColor];
    [_closeButton setTitle:@"C" forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_closeButton];
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)];
    webView.delegate = self;
    
    [self.view addSubview:webView];
    if(_url && _url.length){
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
        [webView loadRequest:request];
    }
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        MBProgressHUD *hud;
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"无法连接到网络,请检查网络配置";
        hud.yOffset -= 35;
        dispatch_time_t popTime;
        popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissModalViewControllerAnimated:YES];
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (NSString *)stringFromBaseURL:(NSString *)baseURL withParams:(NSDictionary *)dictionary
{
    NSString *fullString = [NSString stringWithString:[baseURL stringByAppendingFormat:@"?"]];
    
    for(id key in [dictionary allKeys])
    {
        fullString = [fullString stringByAppendingFormat:@"%@=%@&", key, [dictionary objectForKey:key]];
    }
    
    fullString = [fullString substringToIndex:([fullString length] - 1)];
    
    return fullString;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if(_oauthType == SINA)
    {
        NSString *url = request.URL.absoluteString;
        
        if ([url hasPrefix:kSinaRedirectURI])
        {
            NSString *error_code = [SinaWeiboRequest getParamValueFromUrl:url paramName:@"error_code"];
            
            if (error_code)
            {
                [self dismissModalViewControllerAnimated:YES];
            }
            else
            {
                if([url rangeOfString:@"error_code"].length)
                {
                    [self dismissModalViewControllerAnimated:YES];
                }
                else
                {
                    int begin = [url rangeOfString:@"="].location+1;
                    NSString *sina_access_code = [url substringFromIndex:(NSUInteger) begin];
                    
                    if([sina_access_code length] > 0)
                    {
                        NSString *urlStr = @"https://api.weibo.com/oauth2/access_token";
                        
                        NSDictionary *params = @{@"client_id":@"419321585",@"client_secret":@"d7005e6ac1778880d6dfbe2e0384688c",@"grant_type":@"authorization_code",@"redirect_uri":kSinaRedirectURI,@"code":sina_access_code};
                        
                        //                    urlStr = [self stringFromBaseURL:urlStr withParams:params];
                        
                        ASIFormDataRequest *myRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                        //                    [myRequest setRequestMethod:@"GET"];
                        __weak ASIFormDataRequest *wrequest=myRequest;
                        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                            
                            if([obj isKindOfClass:[UIImage class]])
                            {
                                [myRequest addData:UIImageJPEGRepresentation(obj, 1.0) forKey:key];
                            }
                            else if([obj isKindOfClass:[NSData class]])
                            {
                                [myRequest addData:obj forKey:key];
                            }
                            else
                            {
                                [myRequest addPostValue:obj forKey:key];
                            }
                        }];
                        
                        [myRequest setCompletionBlock:^{
                            
                            NSData *data = [wrequest responseData];
                            
                            NSDictionary *dictionary = (NSDictionary *)[[QYAPIClient sharedAPIClient] responseJSON:data];
                            
                            if (dictionary[@"access_token"]) {
                                
                                NSString *access_token = [dictionary objectForKey:@"access_token"];
                                NSString *uid = [dictionary objectForKey:@"uid"];
                                NSString *remind_in = [dictionary objectForKey:@"remind_in"];
                                //                                                                                                                NSString *refresh_token = [d objectForKey:@"refresh_token"];
                                NSDate *expirationDate = nil;
                                if (access_token && uid)
                                {
                                    if (remind_in != nil)
                                    {
                                        int expVal = [remind_in intValue];
                                        if (expVal == 0)
                                        {
                                            expirationDate = [NSDate distantFuture];
                                        }
                                        else
                                        {
                                            expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
                                        }
                                    }
                                    
                                    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                                                              access_token, @"sina_access_token",
                                                              expirationDate, @"expires_in",
                                                              uid, @"uid", nil];
                                    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
                                    [[NSUserDefaults standardUserDefaults] setObject:access_token forKey:@"sina_access_token"];
                                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"third_access_weibo"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                }
                                
                                [self dismissViewControllerAnimated:YES completion:^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushSinaWeiboViewController" object:self userInfo:nil ];
                                }];
                            }
                            
//                            [[QYAPIClient sharedAPIClient] loginWithSina];
                        }];
                        
                        [myRequest startAsynchronous];
                    }
//
//
//                    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
//                    NSURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/oauth2/access_token" parameters:params];
//                    //
//                    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
//                                                                                                        success:^(NSURLRequest *request1, NSHTTPURLResponse *response, id JSON) {
//
//                                                                                                            NSDictionary *d = (NSDictionary *) JSON;
//                                                                                                            if (d[@"access_token"]) {
//
//                                                                                                                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                                                                                                                [userDefaults setValue:d[@"access_token"] forKey:@"sina_access_token"];
//                                                                                                                [userDefaults setBool:YES forKey:@"third_access_weibo"];
//                                                                                                                [[NSUserDefaults standardUserDefaults] setObject:d forKey:@"SinaWeiboAuth"];
//                                                                                                                [userDefaults synchronize];
//
//                                                                                                                [self dismissViewControllerAnimated:YES completion:^{
//                                                                                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushSinaWeiboViewController" object:self userInfo:nil ];
//                                                                                                                }];
//                                                                                                            }
//                                                                                                        } failure:^(NSURLRequest *request2, NSHTTPURLResponse *response, NSError *error, id JSON) {
//                                                                                                            
//                                                                                                        }];
//                    [operation start];
                    
                }
            }
            
            return NO;
        }
        
        return YES;
    }
    else
    {
        NSString *url = request.URL.absoluteString;
        if([url hasPrefix:[NSString stringWithFormat:@"http://%@",@"www.qq.com"]]){
            
            if(_oauthType==TENCENT){
                NSUInteger begin = [url rangeOfString:@"="].location+1;
                NSUInteger end = [url rangeOfString:@"&"].location;
                NSString *tencent_access_token = [url substringWithRange:NSMakeRange(begin, end-begin)];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setValue:tencent_access_token forKey:@"tencent_access_token"];
                [userDefaults setBool:YES forKey:@"third_access_qzone"];
                [userDefaults synchronize];
                [[QYAPIClient sharedAPIClient] queryOpenIdFromTencent:tencent_access_token];
                [self dismissViewControllerAnimated:YES completion:^{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushQZoneViewController" object:self userInfo:nil];
                }];
            }
            
            return NO;
        }
        else
        {
            return YES;
        }
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
