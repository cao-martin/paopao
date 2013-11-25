//
//  EntryViewController.m
//  charmgram
//
//  Created by Rui Wei on 13-4-1.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "EntryViewController.h"
#import "LoginViewController.h" 
#import "ThirdLoginViewController.h"
#import "SinaWeibo.h"
#import "NSString+SBJSON.h"
#import <CommonCrypto/CommonDigest.h>

@interface EntryViewController ()
{
    SinaWeibo *sinaWeibo;
}
@end

@implementation EntryViewController
@synthesize tencentOAuth;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"appbg"]];
    
    UIView *topbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kTopbarHeight)];
    topbar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg"]];
    [self.view addSubview:topbar];
    
    UILabel* lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 24)];
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.backgroundColor=[UIColor clearColor];
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.text=@"登录";
    lblTitle.font=[UIFont boldSystemFontOfSize:20.0];
    [topbar addSubview:lblTitle];
    
    UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_off"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"header_btn_on"] forState:UIControlStateHighlighted];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.titleLabel.font=[UIFont systemFontOfSize:14.0];
    btnCancel.frame=CGRectMake(8, 7, 56,30);
    [btnCancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:btnCancel];
    
   // NSArray* arrText=[NSArray arrayWithObjects:@"新浪微博账户登录",@"QQ账户登录",@"邮件账户登录",@"密码找回" ,nil];
    NSArray* arrImage=[NSArray arrayWithObjects:@"login_btn_sina",@"login_btn_qq",@"login_btn_email",@"login_btn_pwd",nil];
    for (int k=0; k<arrImage.count; k++) {
       // NSString* text=[arrText objectAtIndex:k];
        NSString* img=[arrImage objectAtIndex:k];
        
        UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_off",img]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_on",img]] forState:UIControlStateHighlighted];
//        [btn setTitle:@"    新浪微博账户登录" forState:UIControlStateNormal];
//        btn.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
        btn.frame=CGRectMake((kDeviceWidth-200)/2, 100+80*k, 200,42);
        btn.tag=100+k;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
//        UILabel* lbltext=[[UILabel alloc] initWithFrame:CGRectMake(38, 0, 168, 48)];
//        lbltext.backgroundColor=[UIColor clearColor];
//        lbltext.textColor=[UIColor whiteColor];
//        lbltext.textAlignment=UITextAlignmentCenter;
//        lbltext.text=text;
//        lbltext.font=[UIFont boldSystemFontOfSize:14.0];
//        lbltext.shadowOffset=CGSizeMake(0, 1.0);
//        lbltext.shadowColor=SHADOW_COLOR;
//        [btn addSubview:lbltext];
    }
    
//    UIButton* btnSina=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btnSina setBackgroundImage:[UIImage imageNamed:@"login_btn_facebook_off"] forState:UIControlStateNormal];
//    [btnSina setBackgroundImage:[UIImage imageNamed:@"login_btn_facebook_on"] forState:UIControlStateHighlighted];
//    [btnSina setTitle:@"    新浪微博账户登录" forState:UIControlStateNormal];
//    btnSina.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
//    btnSina.frame=CGRectMake((kDeviceWidth-208)/2, 100, 208,48);
//    [btnSina addTarget:self action:@selector(clickSina) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnSina];
//    
//    UIButton* btnQQ=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btnQQ setBackgroundImage:[UIImage imageNamed:@"login_btn_twitter_off"] forState:UIControlStateNormal];
//    [btnQQ setBackgroundImage:[UIImage imageNamed:@"login_btn_twitter_on"] forState:UIControlStateHighlighted];
//    [btnQQ setTitle:@"    QQ账户登录" forState:UIControlStateNormal];
//    btnQQ.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
//    btnQQ.frame=CGRectMake((kDeviceWidth-208)/2, 180, 208,48);
//    [btnQQ addTarget:self action:@selector(clickQQ) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnQQ];
//    
//    UIButton* btnEmail=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btnEmail setBackgroundImage:[UIImage imageNamed:@"login_btn_email_off"] forState:UIControlStateNormal];
//    [btnEmail setBackgroundImage:[UIImage imageNamed:@"login_btn_email_on"] forState:UIControlStateHighlighted];
//    [btnEmail setTitle:@"    邮件账户登录" forState:UIControlStateNormal];
//    btnEmail.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
//    btnEmail.frame=CGRectMake((kDeviceWidth-208)/2, 260, 208,48);
//    [btnEmail addTarget:self action:@selector(clickEmail) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnEmail];
    
    UITextView* tvTerm=[[UITextView alloc] initWithFrame:CGRectMake(0, 440, kDeviceWidth, 40)];
    tvTerm.text=@"By proceeding, you agree to Charmgram's Terms of Use\n and Privacy Policy";
    tvTerm.textAlignment=UITextAlignmentCenter;
    tvTerm.backgroundColor=[UIColor clearColor];
    tvTerm.font=[UIFont systemFontOfSize:9.0];
    tvTerm.textColor=[UIColor grayColor];
    [self.view addSubview:tvTerm];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Click Events
-(void)clickCancel{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickSina{

    ThirdLoginViewController *thirdOAuthViewController = [[ThirdLoginViewController alloc] init];
    NSString *url = @"https://open.weibo.cn/2/oauth2/authorize?client_id=419321585&response_type=code&redirect_uri=http%3A%2F%2Fpaopaobeauty.com&display=mobile";

    thirdOAuthViewController.url = url;
    thirdOAuthViewController.oauthType = SINA;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:thirdOAuthViewController];
    navigationController.navigationBar.hidden = YES;
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentModalViewController:navigationController animated:YES];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(pushSinaWeiboViewController)
//                                                 name:@"pushSinaWeiboViewController"
//                                               object:nil];
}

-(void)clickQQ{
    
    ThirdLoginViewController *thirdOAuthViewController = [[ThirdLoginViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"https://openmobile.qq.com/oauth2.0/m_authorize?response_type=token&scope=add_share,add_one_blog&client_id=%@&redirect_uri=%@&display=mobile", @"100476128", @"www.qq.com"];
    thirdOAuthViewController.url = url;
    thirdOAuthViewController.oauthType = TENCENT;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:thirdOAuthViewController];
    navigationController.navigationBar.hidden = YES;
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentModalViewController:navigationController animated:YES];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(pushQZoneViewController)
//                                                 name:@"pushQZoneViewController"
//                                               object:nil];
}

-(void)clickBtn:(UIView*)sender{
    int itag=sender.tag;
    switch (itag) {
        case 100:
        {
//            [self clickSina];
            sinaWeibo = [[AppDelegate App] sinaweibo];
        
            sinaWeibo.delegate = self;
			if ([sinaWeibo isLoggedIn]) {
				[sinaWeibo logOut];
                [sinaWeibo logIn];
			}
			else {
				[sinaWeibo logIn];
			}
        }
            break;
        case 101:
           // [self clickQQ];
        {
            tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"100476128"  andDelegate:self];
           // tencentOAuth.redirectURI = @"www.qq.com";

            [tencentOAuth authorize:[NSArray arrayWithObjects:kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_SHARE, nil] inSafari:NO];
            
        }
            break;
        case 102:
        {
            [self clickEmail];
        }
            break;
        default:
            [self clickFindPwd];
            break;
    }
}
-(void)clickFindPwd{
    LoginViewController* regist=[[LoginViewController alloc] init];
    
    [self.navigationController pushViewController:regist animated:YES];
    [regist initViews:isFindPwd];
}
-(void)clickEmail{
    UIActionSheet *actions=[[UIActionSheet alloc]
              					initWithTitle:nil
								delegate:self
								cancelButtonTitle:@"取消"
								destructiveButtonTitle:nil
                            	otherButtonTitles:@"账号登录",@"创建新账号", nil];
    [actions showInView:self.view];
}

#pragma mark - Actionsheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            LoginViewController* login=[[LoginViewController alloc] init];
			
            [self.navigationController pushViewController:login animated:YES];
			[login initViews:isLogin];
        }
            break;
            
        case 1:
        {
            LoginViewController* regist=[[LoginViewController alloc] init];
			
            [self.navigationController pushViewController:regist animated:YES];
			[regist initViews:isRegist];
        }
            break;
    }
}

-(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

-(void)paopaoRegister:(NSDictionary *)userInfo withType:(NSString *)type{
    NSString *strName ;
    NSString *strHeadUrl;
    NSString *strUid;
    
    if([type isEqual:@"qq"]){
        strName = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"nickname"]];
        strHeadUrl = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"figureurl_qq_2"]];
        strUid = tencentOAuth.openId;
    }
    else{
        strName = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"name"]];
        strHeadUrl = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"profile_image_url"]];
        strUid = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"] ];
    }
    
    
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://paopaobeauty.com/photoshare/webService.php"]];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=20;
    
    [asirequest setPostValue:@"registerapi" forKey:@"method"];
    [asirequest setPostValue:type forKey:@"type"];
    [asirequest setPostValue:strName forKey:@"username"];
    [asirequest setPostValue:@"" forKey:@"email"];
    [asirequest setPostValue:strUid forKey:@"uid"];
    [asirequest setPostValue:strHeadUrl forKey:@"headpic"];
    
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        NSLog(@"respString===%@",respString);
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSLog(@"JSON===%@",JSON);
        //        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        [AppHelper hideHUD:self.view];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]] && [data count]>0) {
                NSDictionary* dict=(NSDictionary*)data[0];
                int userid=[AppHelper getIntFromDictionary:dict key:@"userid"];
                NSString* username=[AppHelper getStringFromDictionary:dict key:@"username"];
                NSString* headimage=[AppHelper getStringFromDictionary:dict key:@"headimage"];
                NSString *introduction = [AppHelper getStringFromDictionary:dict key:@"introduction"];
                
                int remainCoin=[AppHelper getIntFromDictionary:dict key:@"prettyCoin"];                NSString* userToken;
                if([type isEqual:@"qq"]){
                    //userToken = tencentOAuth.accessToken;
                     userToken = [AppHelper getStringFromDictionary:dict key:@"token"];
                }
                else{
                    //userToken = [[AppDelegate App] sinaweibo].accessToken;
                     userToken = [AppHelper getStringFromDictionary:dict key:@"token"];
                }
                
                [AppHelper setIntConfig:confUserId val:userid];
                [AppHelper setStringConfig:confUserName val:username];
                [AppHelper setStringConfig:confUserHeadUrl val:headimage];
                [AppHelper setStringConfig:confUserToken val:userToken];
                [AppHelper setStringConfig:confUserInfo val:introduction];
                if (remainCoin) {
                    [AppHelper setIntConfig:confUserCoin val:remainCoin];
                }
                [AppHelper setStringConfig:confZanNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_zan"]];
                [AppHelper setStringConfig:confGuanZhuNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_care"]];
                [AppHelper setStringConfig:confLiWuNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_gift"]];
                [AppHelper setStringConfig:confShiXinNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_message"]];
            }
            [self updateToken];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TO_TRENDS object:nil userInfo:nil];
            
        }
        else{
            //to do
          [AppHelper hideHUD:self.view];
        }
    }];
    [asirequest setFailedBlock:^{
        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
    
}

-(void)paopaoLogin:(NSDictionary *)userInfo withType:(NSString *)type{
    NSLog(@"userInfo===%@",userInfo);
    NSString *strUid;
    
    if([type isEqual:@"qq"]){
        strUid = [NSString stringWithFormat:@"%@",tencentOAuth.openId ];
    }
    else{
        strUid = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id"] ];
    }
    NSLog(@"strUid====%@",strUid);
    NSString *strKey = [self md5:[NSString stringWithFormat:@"%@%@",[self md5:[NSString stringWithFormat:@"%@pt12r@e3*t4t5tG6ru7sh",strUid]],type]];
     [AppHelper showHUD:@"正在登录...." baseview:self.view];
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://paopaobeauty.com/photoshare/webService.php"]];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=20;
    
    [asirequest setPostValue:@"loginapi" forKey:@"method"];
    [asirequest setPostValue:type forKey:@"type"];
    [asirequest setPostValue:strUid forKey:@"uid"];
    [asirequest setPostValue:strKey forKey:@"key"];
    NSLog(@"strKey===%@",strKey);
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
         NSLog(@"data===%@",JSON);
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        [AppHelper hideHUD:self.view];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]] && [data count]>0) {
               
                NSDictionary* dict=(NSDictionary*)data[0];
                int userid=[AppHelper getIntFromDictionary:dict key:@"userid"];
                NSString* username=[AppHelper getStringFromDictionary:dict key:@"username"];
                NSString* headimage=[AppHelper getStringFromDictionary:dict key:@"headimage"];
                NSString *introduction = [AppHelper getStringFromDictionary:dict key:@"introduction"];
                int prettyCoin=[AppHelper getIntFromDictionary:dict key:@"prettyCoin"];

                NSString* userToken;
                if([type isEqual:@"qq"]){
                   // userToken = tencentOAuth.accessToken;
                     userToken = [AppHelper getStringFromDictionary:dict key:@"token"];
                }
                else{
                    userToken = [AppHelper getStringFromDictionary:dict key:@"token"];//[[AppDelegate App] sinaweibo].accessToken;
                }
                [AppHelper setIntConfig:confUserId val:userid];
                [AppHelper setStringConfig:confUserName val:username];
                 [AppHelper setStringConfig:confUserInfo val:introduction];
                [AppHelper setStringConfig:confUserHeadUrl val:headimage];
                [AppHelper setStringConfig:confUserToken val:userToken];
                if (prettyCoin) {
                    [AppHelper setIntConfig:confUserCoin val:prettyCoin];
                }
                [AppHelper setStringConfig:confZanNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_zan"]];
                [AppHelper setStringConfig:confGuanZhuNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_care"]];
                [AppHelper setStringConfig:confLiWuNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_gift"]];
                [AppHelper setStringConfig:confShiXinNotOn val:[AppHelper getStringFromDictionary:dict key:@"notice_message"]];
                [self updateToken];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TO_TRENDS object:nil userInfo:nil];
            }
         
        }
        else{
            [self paopaoRegister:userInfo withType:type];
        }
    }];
    [asirequest setFailedBlock:^{
        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
    
    
    
}
-(void)updateToken{
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIHTTPRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=20;
    [asirequest setPostValue:METHOD_UPDATETOKEN forKey:@"method"];
    [asirequest setPostValue:[NSString stringWithFormat:@"%d",[AppHelper getIntConfig:confUserId]] forKey:@"userid"];
    [asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
    [asirequest setPostValue:[AppHelper getStringConfig:confNotData] forKey:@"devicetoken"];
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            id data=[JSON objectForKey:@"data"];
            NSLog(@"data====%@",data);
            // [AppHelper showAlertMessage:respString];
            [[AppDelegate App] loadLocationWeb];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
        [AppHelper hideHUD:self.view];
        [[HomeViewController shared] changeTab:1];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    [asirequest setFailedBlock:^{
        [AppHelper hideHUD:self.view];
        [[HomeViewController shared] changeTab:1];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    [asirequest startAsynchronous];
}

- (void)storeAuthData
{
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              tencentOAuth.accessToken, @"qq_access_token",
                              tencentOAuth.expirationDate, @"qq_expires_in",
                              tencentOAuth.openId, @"qq_uid",nil];
  //                            tencentOAuth.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"TencentQQAuthData"];
    [[NSUserDefaults standardUserDefaults] setObject:tencentOAuth.accessToken forKey:@"qq_access_token"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"third_access_qq"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeSinaAuthData
{
    SinaWeibo *sinaweibo = [[AppDelegate App] sinaweibo];
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"sina_access_token",
                              sinaweibo.expirationDate, @"expires_in",
                              sinaweibo.userID, @"uid",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] setObject:sinaweibo.accessToken forKey:@"sina_access_token"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"third_access_weibo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeSinaAuthData];
    NSLog(@"===%@",sinaweibo.userID);
   NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                           sinaweibo.accessToken, @"access_token",
                            sinaweibo.userID, @"uid", nil];
    
    SinaWeiboRequest* sinaWeiboRequest = [SinaWeiboRequest requestWithURL:@"https://api.weibo.com/2/users/show.json"
                                                      httpMethod:@"GET"
                                                          params:params
                                                        delegate:self];
    
    [sinaWeiboRequest  connect];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushSinaWeiboViewController" object:self userInfo:nil];
}
/**
 * Called when the user successfully logged in.
 */
- (void)tencentDidLogin {
	// 登录成功
    [self storeAuthData];
    [tencentOAuth getUserInfo];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushTencentQQViewController" object:self userInfo:nil];

}
- (void)getUserInfoResponse:(APIResponse*) response{
    
    if (response.retCode == URLREQUEST_SUCCEED)
    {
        NSLog(@"%@===%@",response.userData,response.message);
    
        [self paopaoLogin:response.jsonResponse withType:@"qq"];
    }
}

#pragma mark - SinaWeiboRequestDelegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    NSLog(@"result===%@",result);
    NSDictionary *userInfo = (NSDictionary *)result;
   // NSLog(@"request====%@",request.params);
    [self paopaoLogin:userInfo withType:@"weibo"];
}


@end
