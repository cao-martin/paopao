//
//  AppDelegate.m
//  charmgram
//
//  Created by Rui Wei on 13-3-25.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "AppDelegate.h"
#import "AlixPay.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import <CommonCrypto/CommonDigest.h>

@implementation AppDelegate

+(AppDelegate *)App{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}



- (void) sendTextContent:(NSString*)nsText withScene:(int)scene
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = nsText;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

#define BUFFER_SIZE 1024 * 100
- (void) sendAppContent:(int )scene  withTitle:(NSString *)title withContent:(NSString *)content 
{
    // 发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description =SHAREAPPURL;
    //[message setThumbImage:img];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
   // ext.extInfo = [NSString stringWithFormat:@"%@:%@",mode,sId];
    ext.url = @"http://";
    
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    
    ext.fileData = data;
    //    WXMusicObject *ext = [WXMusicObject object];
    //    ext.musicUrl =@"www.baidu.com";// @"wxce40b0994463e21e://";
    //    ext.musicDataUrl = @"http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    //req.scene = WXSceneTimeline;
    BOOL bo = [WXApi sendReq:req];
    NSLog(@"bo======%d",bo);
}

- (void) sendAppImg:(int )scene  withTitle:(NSString *)title withContent:(NSString *)imgUrl withThumbImg:(NSString *)thumbUrl
{
    // 发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = @"这张图片不错哦";
    message.thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbUrl]];
    //[message setThumbImage:img];
    
    WXImageObject *ext = [WXImageObject object];
    // ext.extInfo = [NSString stringWithFormat:@"%@:%@",mode,sId];
    //ext.url = @"http://www.baidu.com";
    ext.imageUrl = SHAREAPPURL;

    //    WXMusicObject *ext = [WXMusicObject object];
    //    ext.musicUrl =@"www.baidu.com";// @"wxce40b0994463e21e://";
    //    ext.musicDataUrl = @"http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    //req.scene = WXSceneTimeline;
    BOOL bo = [WXApi sendReq:req];
    NSLog(@"bo======%d",bo);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _watchCount = 0;
    [WXApi registerApp:@"wx718cf9bc6fb99ed3"];//
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self openHome];
    [self.window makeKeyAndVisible];
    
    //推送通知
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     
	 UIRemoteNotificationTypeBadge |
     
	 UIRemoteNotificationTypeAlert |
     
	 UIRemoteNotificationTypeSound];
    
    _sinaweibo = [[SinaWeibo alloc] initWithAppKey:kSinaAppKey appSecret:kSinaAppSecret appRedirectURI:kSinaRedirectURI andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"sina_access_token"] && [sinaweiboInfo objectForKey:@"expires_in"] && [sinaweiboInfo objectForKey:@"uid"])
    {
        _sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"sina_access_token"];
        _sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"expires_in"];
        _sinaweibo.userID = [sinaweiboInfo objectForKey:@"uid"];
    }
    MyStoreObserver *myObserver = [[MyStoreObserver alloc] init];
	_observer = myObserver;
	_observer.dele = self;
	[[SKPaymentQueue defaultQueue] addTransactionObserver:_observer];
    return YES;
}
#pragma mark - Load Data
-(void)loadLocationWeb{
	NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	[asirequest setPostValue:@"updateUserLocation" forKey:@"method"];
	[asirequest setPostValue:userid forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
    NSString* lat=[NSString stringWithFormat:@"%f",checkinLocation.coordinate.latitude];
	NSString* lng=[NSString stringWithFormat:@"%f",checkinLocation.coordinate.longitude];
	[asirequest setPostValue:lat forKey:@"latitude"];
    [asirequest setPostValue:lng forKey:@"longitude"];
    NSLog(@"lat=====%@,lng===%@",lat,lng);
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
            NSLog(@"JSON===%@",respString);
			//lblFollow.text=[NSString stringWithFormat:@"粉丝 %d",arrFollow.count];
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

//- (void)storeAuthData
//{
//    SinaWeibo *sinaweibo = [self sinaweibo];
//    
//    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
//                              sinaweibo.accessToken, @"sina_access_token",
//                              sinaweibo.expirationDate, @"expires_in",
//                              sinaweibo.userID, @"uid",
//                              sinaweibo.refreshToken, @"refresh_token", nil];
//    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
//    [[NSUserDefaults standardUserDefaults] setObject:sinaweibo.accessToken forKey:@"sina_access_token"];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"third_access_weibo"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
//{
//    [self storeAuthData];
//    
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            sinaweibo.accessToken, @"access_token",
//                            sinaweibo.userID, @"uid", nil];
//    
//   SinaWeiboRequest *request = [SinaWeiboRequest requestWithURL:@"https://api.weibo.com/2/users/show.json"
//                                     httpMethod:@"GET"
//                                         params:params
//                                       delegate:self];
//    
//    [request connect];
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushSinaWeiboViewController" object:self userInfo:nil];
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark- 获取token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    NSLog(@"newDeviceToken====%@",newDeviceToken);
    NSString *token = [NSString stringWithFormat:@"%@",newDeviceToken];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];

    [AppHelper setStringConfig:confNotData val:token];
	
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
        [AppHelper showAlertMessage:[[userInfo objectForKey:key] objectForKey:@"alert"]];
    }
    [self getMessage];
}
-(void)getMessage{
    NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	[asirequest setPostValue:METHOD_GETCOLLECT forKey:@"method"];
	[asirequest setPostValue:userid forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        NSLog(@"respString===%@",respString);
       id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        if (code==REQUEST_CODE_SUCCESS) {
            int msgCount = [[[JSON objectForKey:@"data"] objectForKey:@"messagecount"] intValue];
            int notCount = [[[JSON objectForKey:@"data"] objectForKey:@"pushcount"] intValue];
            
                [AppHelper setIntConfig:confNotCount val:notCount];
                [AppHelper setIntConfig:confMsgCount val:msgCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TO_TRENDS object:nil];
           
        }
     
    }];
    [asirequest setFailedBlock:^{
        //        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];

}
#pragma mark - Open ViewController
-(void)openHome{
    if (!homeController) {
        homeController=[HomeViewController shared];//[[HomeViewController alloc] init];
    }
    if (!nav) {
        nav=[[UINavigationController alloc] initWithRootViewController:homeController];
        [nav setNavigationBarHidden:YES];
    }
    [self.window setRootViewController:nav];
	[self setupLocationManager];
//    [self.window addSubview:nav.view];
    
}

#pragma mark - Play Sound
-(void)playSound:(NSString *)fName ext:(NSString *)ext
{
    NSString *path  = [[NSBundle mainBundle] pathForResource : fName ofType :ext];
    if ([[NSFileManager defaultManager] fileExistsAtPath : path])
    {
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        
        if (soundFileObject) {
            AudioServicesDisposeSystemSoundID (soundFileObject);
        }
        OSStatus err = AudioServicesCreateSystemSoundID((CFURLRef) CFBridgingRetain(pathURL), &soundFileObject);
        if (err != kAudioServicesNoError)
            NSLog(@"Could not load %@, error code: %ld", pathURL, err);
        AudioServicesPlaySystemSound(soundFileObject);
    }
    else
    {
        NSLog(@"error, file not found: %@", path);
    }
    //在非ARC模式下，还需要释放 audioEffect
    //AudioServicesDisposeSystemSoundID(audioEffect);
}

#pragma mark - Location Func
- (void) setupLocationManager {
	if (!locationManager) {
		locationManager = [[CLLocationManager alloc] init];
	}
    if ([CLLocationManager locationServicesEnabled]) {
		DLog( @"Starting CLLocationManager" );
		locationManager.delegate = self;
		locationManager.distanceFilter = 200;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//		locationManager.pausesLocationUpdatesAutomatically=YES;
		[locationManager startUpdatingLocation];
    } else {
        DLog( @"Cannot Starting CLLocationManager" );
		[AppHelper showAlertMessage:@"您还没有开启定位服务，请到设置中开启。"];
        /*self.locationManager.delegate = self;
		 self.locationManager.distanceFilter = 200;
		 locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		 [self.locationManager startUpdatingLocation];*/
    }
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation{
	checkinLocation=newLocation;
	[self stopCheckinLocation];
}

- (CLLocation*)getCheckinLocation{
	if (!checkinLocation) {
		[self setupLocationManager];
		return nil;
	}
	else{
		return checkinLocation;
	}
}

-(void)stopCheckinLocation{
    if ([AppHelper getIntConfig:confUserId]) {
         [self loadLocationWeb];
    }
   
	if (locationManager && [CLLocationManager locationServicesEnabled]) {
		[locationManager stopUpdatingLocation];
	}
}


- (BOOL)parseURL:(NSURL *)url application:(UIApplication *)application {
	AlixPay *alixpay = [AlixPay shared];
    NSLog(@"url====%@",url);
	AlixPayResult *result = [alixpay handleOpenURL:url];
    NSLog(@"xxxx====%@",result.resultString);
    NSLog(@"%@==%d==%@",result.signString,result.statusCode,result.signType);
	if (result) {
		//是否支付成功
		if (9000 == result.statusCode) {
			/*
			 *用公钥验证签名
			 */
            NSLog(@"result.statusMessage====%@",result.statusMessage);
			id<DataVerifier> verifier = CreateRSADataVerifier(ALIPAYPUBLICKEY);
			if ([verifier verifyString:result.resultString withSign:result.signString]) {
//				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//																	 message:result.statusMessage
//																	delegate:nil
//														   cancelButtonTitle:@"确定"
//														   otherButtonTitles:nil];
//				[alertView show];
              [self notify_url:result.resultString];
                NSLog(@"result.statusMessage====%@",result.statusMessage);
			}//验签错误
			else {
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																	 message:@"签名错误"
																	delegate:nil
														   cancelButtonTitle:@"确定"
														   otherButtonTitles:nil];
				[alertView show];
			}
		}
		//如果支付失败,可以通过result.statusCode查询错误码
		else {
			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																 message:result.statusMessage
																delegate:nil
													   cancelButtonTitle:@"确定"
													   otherButtonTitles:nil];
			[alertView show];
		}
		
	}
    return YES;
}

-(void)notify_url:(NSString *)result{
    
    NSArray *arrResult = [result componentsSeparatedByString:@"&"];
    NSMutableDictionary *dicResult = [NSMutableDictionary new];
    for (NSString *strSub in arrResult) {
         NSArray *arrResult = [strSub componentsSeparatedByString:@"="];
        if ([arrResult count]==2) {
            NSString *vlue = [arrResult objectAtIndex:1];
            vlue =[vlue stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            [dicResult setValue:vlue forKey:[arrResult objectAtIndex:0]];
        }
    
    }
    NSLog(@"dicResult=====%@",dicResult);
    
    NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
    NSString *trade_no = [dicResult objectForKey:@"out_trade_no"];
    NSString *total_fee = [dicResult objectForKey:@"total_fee"];
     NSString *strKey = [self md5:[NSString stringWithFormat:@"%@%@%@",[self md5:[NSString stringWithFormat:@"%@%@",userid,trade_no]],@"p!w@e#r$%t^&yy*u()iui_o+ao",total_fee]];
	ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	[asirequest setPostValue:METHOD_POSTORDER forKey:@"method"];
	[asirequest setPostValue:userid forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:[dicResult objectForKey:@"out_trade_no"] forKey:@"out_trade_no"];
    [asirequest setPostValue:[dicResult objectForKey:@"subject"] forKey:@"ordername"];
    [asirequest setPostValue:[dicResult objectForKey:@"total_fee"] forKey:@"fee"];
    [asirequest setPostValue:strKey forKey:@"key"];
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        NSLog(@"respString===%@",respString);
        NSString *str = [NSString stringWithFormat:@"%@----%@++++%@++++%@++++%@",respString,[dicResult objectForKey:@"out_trade_no"],[dicResult objectForKey:@"subject"],[dicResult objectForKey:@"total_fee"],strKey];
        id JSON=[respString objectFromJSONString];
        NSLog(@"JSON===%@",JSON);
        //[AppHelper showAlertMessage:str];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        NSDictionary *dict = [JSON objectForKey:@"data"];
        if (code==REQUEST_CODE_SUCCESS) {
            
            int prettyCoin=[AppHelper getIntFromDictionary:dict key:@"coin"];
            if (prettyCoin) {
                [AppHelper setIntConfig:confUserCoin val:prettyCoin];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TO_TRENDS object:nil userInfo:nil];
        } }];

    [asirequest setFailedBlock:^{
        //        [AppHelper hideHUD:self.view];
    }];
    [asirequest startAsynchronous];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSLog(@"url=====%@",[url absoluteString]);
    if ([[url absoluteString] hasPrefix:@"AlixPay"]) {
        return [self parseURL:url application:application];
    }else if ([[url absoluteString] hasPrefix:@"tencent100476128"]){
        return [TencentOAuth HandleOpenURL:url];
    }else if ([[url absoluteString] hasPrefix:@"sinaweibosso"]){
       return  [self.sinaweibo handleOpenURL:url];
    }else if([[url absoluteString] hasPrefix:@"wx718cf9bc6fb99ed3"]){
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        return NO;
    }
   
   
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return ([TencentOAuth HandleOpenURL:url] || [self.sinaweibo handleOpenURL:url]|| [WXApi handleOpenURL:url delegate:self]);
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


//完成交易
- (void)observerPayComplete:(MyStoreObserver *)_observer transation:(SKPaymentTransaction *)_transation{
	// NSString * productIdentifier = _transation.payment.productIdentifier;
    NSString *temptransactionReceipt  = [[NSString alloc] initWithData:[_transation transactionReceipt] encoding:NSUTF8StringEncoding];
    
   // temptransactionReceipt =  [temptransactionReceipt stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
	NSLog(@"paydelegate------complete=%@",temptransactionReceipt);
    [self postVisear:temptransactionReceipt];
	//[self completeTransaction:_transation];
}

//交易失败
- (void)observerPayFailed:(MyStoreObserver *)_observer transation:(SKPaymentTransaction *)_transation{
	
	NSLog(@"paydelegate-------failed");
}

-(void)postVisear:(NSString *)strVar{
    [AppHelper showHUD:@"交易验证中" baseview: self.window];
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]];
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
    [asirequest setPostValue:@"checkBuy" forKey:@"method"];
    NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
    [asirequest setPostValue:userid forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
   
    [asirequest setPostValue:strVar  forKey:@"data"];

  
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        NSLog(@"成功===%@",respString);
        if (code==REQUEST_CODE_SUCCESS) {
            NSLog(@"成功===%@",respString);
             NSDictionary *dict = [JSON objectForKey:@"data"];
            int prettyCoin=[AppHelper getIntFromDictionary:dict key:@"coin"];
            if (prettyCoin) {
                [AppHelper setIntConfig:confUserCoin val:prettyCoin];
            }
            [AppHelper showAlertMessage:@"支付成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TO_TRENDS object:nil userInfo:nil];
            //			[refreshHeader RefreshScrollViewDidScroll:self.tableView];
            //			[refreshHeader ManualDragScrollViewToRefresh:self.tableView];
        }
        else{
            [AppHelper showAlertMessage:msg];
        }
             [AppHelper hideHUD:self.window];
    }];
    [asirequest setFailedBlock:^{
               [AppHelper hideHUD:self.window];
    }];
    [asirequest startAsynchronous];

}
@end
