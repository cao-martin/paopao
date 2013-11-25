//
//  AppHelper.m
//  mobile
//
//  Created by Rain on 13-3-20.
//  Copyright (c) 2013年 com.inlove. All rights reserved.
//

#import "AppHelper.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "MBProgressHUD.h"
@implementation AppHelper
 
#pragma mark - NSUserDefaults Functions
+ (NSString*)getStringConfig:(NSString*)key{
    NSString *temp = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    return temp?temp:@"";
}

+ (void)setStringConfig:(NSString*)key val:(NSString*)val{
    [[NSUserDefaults standardUserDefaults] setObject:val forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSArray *)getArrayConfig:(NSString*)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
+ (void)setArrayConfig:(NSString*)key val:(NSArray*)val{
    [[NSUserDefaults standardUserDefaults] setObject:val forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getBoolConfig:(NSString*)key{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (void)setBoolConfig:(NSString*)key val:(BOOL)val{
    [[NSUserDefaults standardUserDefaults] setBool:val forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)getIntConfig:(NSString*)key{
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (void)setIntConfig:(NSString*)key val:(int)val{
    [[NSUserDefaults standardUserDefaults] setInteger: val forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSData *)getDataConfig:(NSString*)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setDataConfig:(NSString *)key val:(NSData *)val{
    [[NSUserDefaults standardUserDefaults] setObject:val forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - System Functions
+(void)hideHUD:(UIView*)baseview{
    [MBProgressHUD hideHUDForView:baseview animated:YES];
}

+(void)showHUD:(NSString*)message baseview:(UIView*)baseview{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:baseview animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = message;
}

+(void)showAlertMessage:(NSString*)msg
                  title:(NSString*)title
              lbtnTitle:(NSString*)lbtnTitle
              lbtnBlock:(void(^)())lbtnBlock
              rbtnTitle:(NSString*)rbtnTitle
              rbtnBlock:(void(^)())rbtnBlock{
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = lbtnTitle;
    cancelItem.action = lbtnBlock;
    
	if (rbtnTitle && rbtnTitle.length>0) {
		RIButtonItem *deleteItem = [RIButtonItem item];
		deleteItem.label = rbtnTitle;
		deleteItem.action = rbtnBlock;
		//调用
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
															message:msg
												   cancelButtonItem:cancelItem
												   otherButtonItems:deleteItem, nil];
		[alertView show];
	}
    else{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
															message:msg
												   cancelButtonItem:cancelItem
												   otherButtonItems: nil];
		[alertView show];
	}
}

+(void)showAlertMessage:(NSString*)msg title:(NSString*)title{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:title
                                                       message:msg
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
    [alertView show];
}

+(void)showAlertMessage:(NSString*)msg{
    [[self class] showAlertMessage:msg title:nil];
}

+(BOOL)isValidatedUser{
    return ![[[self class] getStringConfig:confUserName] isEqualToString:@""];
}

+(void)hideKeyWindow{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - Validation
+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - Custom Functions
+ (NSString *)generateGuid {
	CFUUIDRef	uuidObj = CFUUIDCreate(nil);//create a new UUID
	//get the string representation of the UUID
	NSString	*uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return uuidString;
}

+(NSString*)TrimString:(NSString*)str{
	NSString* temp=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return temp;
}

+(NSString*)AvatarPath{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString* temp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	temp=[ temp stringByAppendingPathComponent:@"profile"];
	BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:temp isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
		[fileManager createDirectoryAtPath:temp withIntermediateDirectories:YES attributes:nil error:nil];
    }
	temp=[temp stringByAppendingPathComponent:@"avatar.jpg"];
	return temp;
}

+ (NSString*)getStringFromDictionary:(NSDictionary *)dictionary key:(NSString*)strKey
{
    id findValue = [dictionary objectForKey:strKey];
    if (!findValue) {
        return @"";
    }
    if ([findValue isKindOfClass:[NSString class]] )
    {
        
        NSString* strValue = findValue;
        if (!strValue) {
            return @"";
        }
        return  strValue;
    }
    else if ([findValue isKindOfClass:[NSNumber class]] )
    {
        NSString *myString = [findValue stringValue];
        return myString;
    }
    return @"";
}

+ (int)getIntFromDictionary:(NSDictionary *)dictionary key:(NSString*)strKey
{
    
    id findValue = [dictionary objectForKey:strKey];
    if ([findValue isKindOfClass:[NSString class]] )
    {
        //如果是字符串， 那么就转换为int
        NSString* strValue = findValue;
        return [strValue intValue];
    }
    else if ([findValue isKindOfClass:[NSNumber class]] )
    {
        return [findValue intValue];
    }
    
    return 0;
}
+ (double)getDoubleFromDictionary:(NSDictionary *)dictionary key:(NSString*)strKey
{
    
    id findValue = [dictionary objectForKey:strKey];
    if ([findValue isKindOfClass:[NSString class]] )
    {
        //如果是字符串， 那么就转换为int
        NSString* strValue = findValue;
        return [strValue intValue];
    }
    else if ([findValue isKindOfClass:[NSNumber class]] )
    {
        return [findValue doubleValue];
    }
    
    return 0;
}
#pragma mark - Date Functions
+(NSDate *)String2Date:(NSString *)string {
    return [[self class] String2Date:string format:StandardDateTimeFormat];
}

+(NSDate *)String2Date:(NSString *)string format:(NSString*)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

+(NSString *)Date2String:(NSDate *)date format:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(NSString *)getCurrentDate { 
    return [[self class] getCurrentDate:StandardDateTimeFormat];
}

+(NSString *)getCurrentDate:(NSString*)format {
    NSDate* date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *strdate = [formatter stringFromDate:date];
    return strdate;
}

+(NSString*)DateString2Display:(NSString*)strDate strFormat:(NSString*)strFormat {
    NSLog(@"strDate===%@,strformat===%@",strDate,strFormat);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat :strFormat];
    //NSDate *dateFromString = [[NSDate alloc] init];
    NSDate *dateFromString = [dateFormatter dateFromString:strDate];
    NSDate* theDate=dateFromString;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDate *today = [[NSDate alloc] init];
    NSDateComponents *components = [gregorian components:unitFlags fromDate:theDate toDate:today options:0];
    NSInteger months=[components month];
    NSInteger days=[components day];
    NSInteger hours=[components hour];
    NSInteger minutes=[components minute];
    if (months==0 && days==0 && hours==0 && minutes>=0 ) {
        if (minutes==0) {
            return @"刚刚";
        }
        else{
            return [NSString stringWithFormat:@"%d分钟前",minutes];
        }
    }
    if (months==0 && days==0 && hours>0) {
        return [NSString stringWithFormat:@"%d小时前",hours];
    }
    if (months==0 && days >0) {
        return [NSString stringWithFormat:@"%d天前",days];
    }
    
    if (months>0) {
        return [NSString stringWithFormat:@"%d月前",months];
    }
    if (months>12) {
        return [NSString stringWithFormat:@"%d年前", (int)floor(months/12) ];
    }
    return @"";
}

+ (NSTimeInterval)intervalSinceNow: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:StandardDateTimeFormat];
    NSDate *d=[date dateFromString:theDate]; 
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha=now-late;
    return cha;
}
@end
