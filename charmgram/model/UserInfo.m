//
//  UserInfo.m
//  charmgram
//
//  Created by Rui Wei on 13-3-25.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
@synthesize UserId,AvatarURL,UserName,isFan,isFollow,isCare;

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
    self.PhoneNum = @"";
    self.isSelectde = 0;
    self.isCare = 0;
    self.show_time = @"";
    return self;

}

-(id)initWithDict:(NSDictionary*)dict{
	self=[self init];
 	self.UserId=[AppHelper getIntFromDictionary:dict key:@"userid"];
 	self.AvatarURL=[AppHelper getStringFromDictionary:dict key:@"headimage"];
 	self.UserName=[AppHelper getStringFromDictionary:dict key:@"username"];
    self.Content = [AppHelper getStringFromDictionary:dict key:@"content"];
     self.SendId = [AppHelper getIntFromDictionary:dict key:@"senderid"];
    self.SendName = [AppHelper getStringFromDictionary:dict key:@"sendername"];
     self.SendHeadimg = [AppHelper getStringFromDictionary:dict key:@"sender_headimg"];
    self.isSelectde = [AppHelper getIntFromDictionary:dict key:@"isSelectde"];
     self.isCare = [AppHelper getIntFromDictionary:dict key:@"follow"];
    self.show_time = [AppHelper getStringFromDictionary:dict key:@"show_time"];
    
	return self;
}
@end
