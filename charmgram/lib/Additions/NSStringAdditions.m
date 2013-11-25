//
//  NSStringAdditions.m
//  Weibo
//
//  Created by junmin liu on 10-9-29.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "NSStringAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Additions)

+ (NSString *)generateGuid {
	CFUUIDRef	uuidObj = CFUUIDCreate(nil);//create a new UUID
	//get the string representation of the UUID
	NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return uuidString;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isWhitespaceAndNewlines {
	NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	for (NSInteger i = 0; i < self.length; ++i) {
		unichar c = [self characterAtIndex:i];
		if (![whitespace characterIsMember:c]) {
			return NO;
		}
	}
	return YES;
} 

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isEmptyOrWhitespace {
	return !self.length ||
	![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

- (BOOL)isEmailValid {
	NSString* regex = @"^[A-Za-z0-9._%+-]+@[A-Za-z0-9._%+-]+\\.[A-Za-z0-9._%+-]+$";
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([regextest evaluateWithObject:self] == YES) {
        return YES;
    } else {
        return NO;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Copied and pasted from http://www.mail-archive.com/cocoa-dev@lists.apple.com/msg28175.html
- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding {
	NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
	NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
	NSScanner* scanner = [[NSScanner alloc] initWithString:self];
	while (![scanner isAtEnd]) {
		NSString* pairString = nil;
		[scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
		[scanner scanCharactersFromSet:delimiterSet intoString:NULL];
		NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
		if (kvPair.count == 2) {
			NSString* key = [[kvPair objectAtIndex:0]
							 stringByReplacingPercentEscapesUsingEncoding:encoding];
			NSString* value = [[kvPair objectAtIndex:1]
							   stringByReplacingPercentEscapesUsingEncoding:encoding];
			[pairs setObject:value forKey:key];
		}
	}
	
	return [NSDictionary dictionaryWithDictionary:pairs];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query {
	NSMutableArray* pairs = [NSMutableArray array];
	for (NSString* key in [query keyEnumerator]) {
		NSString* value = [query objectForKey:key];
		value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
		value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
		NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
		[pairs addObject:pair];
	}
	
	NSString* params = [pairs componentsJoinedByString:@"&"];
	if ([self rangeOfString:@"?"].location == NSNotFound) {
		return [self stringByAppendingFormat:@"?%@", params];
	} else {
		return [self stringByAppendingFormat:@"&%@", params];
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSComparisonResult)versionStringCompare:(NSString *)other {
	NSArray *oneComponents = [self componentsSeparatedByString:@"a"];
	NSArray *twoComponents = [other componentsSeparatedByString:@"a"];
	
	// The parts before the "a"
	NSString *oneMain = [oneComponents objectAtIndex:0];
	NSString *twoMain = [twoComponents objectAtIndex:0];
	
	// If main parts are different, return that result, regardless of alpha part
	NSComparisonResult mainDiff;
	if ((mainDiff = [oneMain compare:twoMain]) != NSOrderedSame) {
		return mainDiff;
	}
	
	// At this point the main parts are the same; just deal with alpha stuff
	// If one has an alpha part and the other doesn't, the one without is newer
	if ([oneComponents count] < [twoComponents count]) {
		return NSOrderedDescending;
	} else if ([oneComponents count] > [twoComponents count]) {
		return NSOrderedAscending;
	} else if ([oneComponents count] == 1) {
		// Neither has an alpha part, and we know the main parts are the same
		return NSOrderedSame;
	}
	
	// At this point the main parts are the same and both have alpha parts. Compare the alpha parts
	// numerically. If it's not a valid number (including empty string) it's treated as zero.
	NSNumber *oneAlpha = [NSNumber numberWithInt:[[oneComponents objectAtIndex:1] intValue]];
	NSNumber *twoAlpha = [NSNumber numberWithInt:[[twoComponents objectAtIndex:1] intValue]];
	return [oneAlpha compare:twoAlpha];
}

-(NSString*)cutStringByByte:(int)length
{
    int nIndex = [self length];
    int nCurrLen = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    //int nLen = [str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
    int nLen = nIndex;
    for (int i = 0; i < nLen; i++) {
        if (i == 0) {
            p ++;
        }
        else
        {
            p += 2;
        }
        
        nCurrLen ++;
        if (*p)
        {
            //汉字
            nCurrLen ++;
        }
        //判断
        if (nCurrLen > length) {
            //超过了
            nIndex = i;
            break;
        }
    }
    if (nIndex < 0 ) {
        nIndex = 0;
    }
    if (nIndex == 0) {
        return [NSString stringWithFormat:@""];
    }
    NSString * to = [self substringToIndex:nIndex];
    
    return to;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)md5Hash {
	return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}

#pragma mark - Date Function
-(NSDate *)getDateByString:(NSString*)format{
 
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *fromdate=[dateFormatter dateFromString:self];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
     
    return fromDate;
}

-(NSString *)getDateStringByString:(NSString*)format newFormat:(NSString*)newFormat{
    if (self.length==0) {
        return @"";
    }
    NSLog(@"%@",self);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]]; 
    [dateFormatter setDateFormat :format];
    NSDate *dateFromString  = [dateFormatter dateFromString:self];
    [dateFormatter setDateFormat:newFormat];
    NSString *strDate = [dateFormatter stringFromDate:dateFromString];
     
    return strDate;
}
-(NSString*)compareDateAndDisplay:(NSString*)format{
 NSLog(@"%@",self);
    NSDate *today = [[NSDate alloc] init];
    NSString* strReturn =  [self compareDateAndDisplay:format anotherDate:today];
     
    return strReturn;
}

-(NSString*)compareDateAndDisplay:(NSString*)format  anotherDate:(NSDate*)anotherDate{
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat :format];
    //NSDate *dateFromString = [[NSDate alloc] init];
    NSDate *dateFromString = [dateFormatter dateFromString:self];
     
    NSDate* theDate=dateFromString;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:theDate toDate:anotherDate options:0];
    NSInteger months=[components month];
    NSInteger days=[components day];
    NSInteger hours=[components hour];
    NSInteger minutes=[components minute];
    NSLog(@"format===%@==%d----%d----%d---%d",format,months,days,hours,minutes);
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

-(NSString*)compareDateAndDisplay2:(NSString*)format  anotherDate:(NSDate*)anotherDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat :format];
    //NSDate *dateFromString = [[NSDate alloc] init];
    NSDate *dateFromString = [dateFormatter dateFromString:self]; 
    NSDate* theDate=dateFromString;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; 
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:theDate toDate:anotherDate options:0];
    NSInteger months=[components month];
    NSInteger days=[components day];
    NSInteger hours=[components hour];
    NSInteger minutes=[components minute]; 
    if (months==0 && days==0 && hours==0 && minutes>=0 ) {
        if (minutes==0) {
            return @"好运灯即将熄灭";
        }
        else{
            return [NSString stringWithFormat:@"好运灯还将点亮%d分钟",minutes];
        }
    }
    if (months==0 && days==0 && hours>0) {
        return [NSString stringWithFormat:@"好运灯还将点亮%d小时",hours];
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
@end
