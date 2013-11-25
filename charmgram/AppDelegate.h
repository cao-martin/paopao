//
//  AppDelegate.h
//  charmgram
//
//  Created by Rui Wei on 13-3-25.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreLocation/CoreLocation.h>
#import "SinaWeibo.h"
#import "WXApi.h"
#import "MyStoreObserver.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate, SinaWeiboDelegate,WXApiDelegate,PayDelegate>
{
    HomeViewController* homeController;
    UINavigationController *nav;
    SystemSoundID	soundFileObject;
	CLLocationManager *locationManager;
	CLLocation *checkinLocation;
    
    SinaWeibo   *_sinaweibo;
   // MyStoreObserver *observer;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SinaWeibo *sinaweibo;
@property (nonatomic, assign) int watchCount;
+(AppDelegate *)App;
-(void)playSound:(NSString *)fName ext:(NSString *)ext;
- (CLLocation*)getCheckinLocation;
-(void)stopCheckinLocation;
- (void) sendAppContent:(int )scene  withTitle:(NSString *)title withContent:(NSString *)content ;
- (void) sendAppImg:(int )scene  withTitle:(NSString *)title withContent:(NSString *)imgUrl withThumbImg:(NSString *)thumbUrl;
-(void)getMessage;
-(void)loadLocationWeb;
//支付相关

@property (nonatomic ,retain) MyStoreObserver *observer;
@end
