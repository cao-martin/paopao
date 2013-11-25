//
//  AppHelper.h
//  mobile
//
//  Created by Rain on 13-3-20.
//  Copyright (c) 2013年 com.inlove. All rights reserved.
//

#import <Foundation/Foundation.h>
#define confUserId                      @"confUserId"
#define confUserToken                   @"confUserToken"
#define confUserName                    @"confUserName"
#define confUserInfo                    @"confUserInfo"
#define confUserEmail                   @"confUserEmail"
#define confUserHeadUrl                 @"confUserHeadUrl"
#define confUserSex                     @"confUserSex"
#define confUserMobile                  @"confUserMobile"
#define confUserCoin                    @"confUserCoin"
#define confNotData                     @"getStringConfig"
#define confNotCount                    @"notcount"
#define confMsgCount                    @"msgcount"
#define confZanNotOn                    @"zanNotOn"
#define confLiWuNotOn                   @"liWuNotOn"
#define confShiXinNotOn                 @"shiXinNotOn"
#define confGuanZhuNotOn                @"guanZhuNotOn"
@interface AppHelper : NSObject
+ (NSString*)getStringConfig:(NSString*)key;
+ (void)setStringConfig:(NSString*)key val:(NSString*)val;

+ (BOOL)getBoolConfig:(NSString*)key;
+ (void)setBoolConfig:(NSString*)key val:(BOOL)val;
+ (NSArray *)getArrayConfig:(NSString*)key;
+ (void)setArrayConfig:(NSString*)key val:(NSArray*)val;
+ (int)getIntConfig:(NSString*)key;
+ (void)setIntConfig:(NSString*)key val:(int)val;

+ (NSData *)getDataConfig:(NSString*)key;
+ (void)setDataConfig:(NSString *)key val:(NSData *)val;

+(BOOL)isValidatedUser;

+(void)hideHUD:(UIView*)baseview;
+(void)showHUD:(NSString*)message baseview:(UIView*)baseview;
+(void)hideKeyWindow;
+(void)showAlertMessage:(NSString*)msg
                  title:(NSString*)title
              lbtnTitle:(NSString*)lbtnTitle
              lbtnBlock:(void(^)())lbtnBlock
              rbtnTitle:(NSString*)rbtnTitle
              rbtnBlock:(void(^)())rbtnBlock;
+(void)showAlertMessage:(NSString*)msg;
+(void)showAlertMessage:(NSString*)msg title:(NSString*)title;
+(BOOL) NSStringIsValidEmail:(NSString *)checkString;
+(NSString*)TrimString:(NSString*)str;
+(NSString*)AvatarPath;
+ (NSString *)generateGuid;
+ (NSString*)getStringFromDictionary:(NSDictionary *)dictionary key:(NSString*)strKey;
+ (int)getIntFromDictionary:(NSDictionary *)dictionary key:(NSString*)strKey;
+ (double)getDoubleFromDictionary:(NSDictionary *)dictionary key:(NSString*)strKey;
+(NSDate *)String2Date:(NSString *)string;
+(NSDate *)String2Date:(NSString *)string format:(NSString*)format;
+(NSString *)Date2String:(NSDate *)date format:(NSString*)format;
+(NSString *)getCurrentDate;
+(NSString *)getCurrentDate:(NSString*)format;
+(NSString*)DateString2Display:(NSString*)strDate strFormat:(NSString*)strFormat;
+(NSTimeInterval)intervalSinceNow: (NSString *) theDate;
@end
