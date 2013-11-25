//
//  NewsInfo.m
//  charmgram
//
//  Created by martin on 13-8-23.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "NewsInfo.h"

@implementation NewsInfo
@synthesize UserId,AvatarURL,UserName,isFan,isFollow;

-(id)init{
    self=[super init];
    self.UserId=0;
    self.UserName=@"";
    self.AvatarURL=@"";
    self.isFollow=NO;
    self.isFan=NO;
    self.Content = @"";
    self.SendId = 0;
    self.SendName = @"";
    self.SendHeadimg = @"";
    self.pic = @"";
    self.typeMes = 0;
    self.info_sid = 0;
    return self;
}

-(id)initWithDict:(NSDictionary*)dict{
	self=[self init];
 	self.UserId=[AppHelper getIntFromDictionary:dict key:@"userid"];
 	self.AvatarURL=[AppHelper getStringFromDictionary:dict key:@"headimage"];
 	self.UserName=[AppHelper getStringFromDictionary:dict key:@"username"];
    self.Content = [AppHelper getStringFromDictionary:dict key:@"info"];
    self.SendId = [AppHelper getIntFromDictionary:dict key:@"fromid"];
    self.SendName = [AppHelper getStringFromDictionary:dict key:@"fromname"];
    self.SendHeadimg = [AppHelper getStringFromDictionary:dict key:@"frompic"];
    self.pic = [AppHelper getStringFromDictionary:dict key:@"pic"];
    self.typeMes = [AppHelper getIntFromDictionary:dict key:@"type"];
     self.info_sid = [AppHelper getIntFromDictionary:dict key:@"info_sid"];
	return self;
}

@end
