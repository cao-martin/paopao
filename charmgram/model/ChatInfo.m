//
//  ChatInfo.m
//  charmgram
//
//  Created by Rain on 13-6-17.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "ChatInfo.h"
 

@implementation ChatInfo
@synthesize IsMyTalk,PeerId,ChatID,Text,NickName,AvatarUrl;
-(id)init{
    self=[super init];
    self.IsMyTalk=NO;
    self.Text=@"";
    self.NickName=@"";
    self.AvatarUrl=@"";
    self.ChatID=0;
    self.PeerId=0;
    return self;
}

-(id)initWithDict:(NSDictionary*)dict{
	self=[self init];
 	self.Text=[AppHelper getStringFromDictionary:dict key:@"content"];
 	self.AvatarUrl=[AppHelper getStringFromDictionary:dict key:@"headimage"];
	self.ChatID=[AppHelper getIntFromDictionary:dict key:@"id"];
	int sendid=[AppHelper getIntFromDictionary:dict key:@"senderid"];
	if (sendid==[AppHelper getIntConfig:confUserId]) {
		self.IsMyTalk=YES;
		self.PeerId=[AppHelper getIntFromDictionary:dict key:@"accepterid"];
	}
	else{
		self.IsMyTalk=NO;
		self.PeerId=sendid;
	}
	return self;
}

-(void)sendMessage {
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]]; 
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90; 
	[asirequest setPostValue:METHOD_SENDMESSAGE forKey:@"method"]; 
	[asirequest setPostValue:[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] forKey:@"userid"];
	[asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	[asirequest setPostValue:self.Text forKey:@"content"];
	[asirequest setPostValue:[NSString stringWithFormat:@"%d",self.PeerId] forKey:@"accepterid"];

    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        NSLog(@"JSON===%@",JSON);
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) {
			
        }
		else{
			DLog(@"%@",msg);
		}
    }];
    [asirequest setFailedBlock:^{
		DLog(@"sendMessage - failure");
    }];
    [asirequest startAsynchronous];
}
@end
