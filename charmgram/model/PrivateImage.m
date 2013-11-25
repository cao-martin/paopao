//
//  PrivateImage.m
//  charmgram
//
//  Created by Rui Wei on 13-5-10.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "PrivateImage.h"
 

@implementation PrivateImage
@synthesize RowIndex,ColIndex,State,ThumbUrl,ImageUrl,Second,UserId,AvatarUrl,UserName,CreatedDate,ViewCount,
				Distance,arrGift,arrLike,LikeCount,CommentCount,ImageId,GiftCount,issee;

-(id)init{
	self=[super init];
    self.UserId=0;
	self.ImageId=0;
	self.RowIndex=0;
	self.ColIndex=0;
	self.Second=0;
    self.ViewCount=0;
	self.LikeCount=0;
	self.Distance=0;
	self.CommentCount=0;
    self.GiftCount=0;
    self.issee = 0;
	self.State=PrivateImageStateNormal;
	self.ThumbUrl=@"";
	self.ImageUrl=@"";
	self.UserName=@"";
	self.AvatarUrl=@"";
    self.CreatedDate=@"";
    self.WatchDate = @"";
    self.arrLike=[[NSMutableArray alloc] initWithCapacity:0];
    self.arrGift=[[NSMutableArray alloc] initWithCapacity:0];
    self.info_sid = 0;
	return self;
}

-(id)initWithDict:(NSDictionary*)dict{
    
	self=[self init];
    NSLog(@"dict=====%@",dict);
	self.State=PrivateImageStateNormal;
	self.Second=[AppHelper getIntFromDictionary:dict key:@"seconds"];//10;//arc4random()%8+2;
	self.UserId=[AppHelper getIntFromDictionary:dict key:@"userid"];
	self.ImageId=[AppHelper getIntFromDictionary:dict key:@"sid"];
	self.ViewCount=[AppHelper getIntFromDictionary:dict key:@"watchTimes"];
	self.GiftCount=[AppHelper getIntFromDictionary:dict key:@"giftcount"];
	self.LikeCount=[AppHelper getIntFromDictionary:dict key:@"zancount"];
	self.CreatedDate=[AppHelper getStringFromDictionary:dict key:@"addtime"];
    self.WatchDate = [AppHelper getStringFromDictionary:dict key:@"watchtime"];
	self.UserName=[AppHelper getStringFromDictionary:dict key:@"username"];
	self.AvatarUrl=[AppHelper getStringFromDictionary:dict key:@"headimage"];
	self.ImageUrl=[AppHelper getStringFromDictionary:dict key:@"photopath"];
	self.ThumbUrl=[AppHelper getStringFromDictionary:dict key:@"photopath_small"];
	self.isLiked=([AppHelper getIntFromDictionary:dict key:@"islike"]==1);
    self.Distance = [AppHelper getDoubleFromDictionary:dict key:@"juli"];
    self.issee = [AppHelper getIntFromDictionary:dict  key:@"issee"];
    self.info_sid = [AppHelper getIntFromDictionary:dict  key:@"info_sid"];
    id zan=[dict objectForKey:@"zan"];
    if ([zan isKindOfClass:[NSArray class]]) {
        [self.arrLike addObjectsFromArray:zan];
    }
    id giftlist=[dict objectForKey:@"giftlist"];
    if ([giftlist isKindOfClass:[NSArray class]]) {
        [self.arrGift addObjectsFromArray:giftlist];
    }
    
	return self;
}

-(void)likeMe{
    ASIFormDataRequest* asirequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:UrlBase]]; 
    __weak ASIFormDataRequest *wrequest=asirequest;
    asirequest.timeOutSeconds=90;
    //    DLog(@"%@",dictInput);
	if (self.isLiked) {
		[asirequest setPostValue:METHOD_LIKE forKey:@"method"];
	}
	else{
	 	[asirequest setPostValue:METHOD_UNLIKE forKey:@"method"];
	}
	 NSString *userid=[NSString stringWithFormat:@"%d", [AppHelper getIntConfig:confUserId]] ;
	 [asirequest setPostValue:userid forKey:@"userid"];
	 [asirequest setPostValue:[AppHelper getStringConfig:confUserToken] forKey:@"token"];
	 [asirequest setPostValue:[NSString stringWithFormat:@"%d",self.ImageId] forKey:@"sid"]; 
      
    [asirequest setCompletionBlock:^{
        NSString* respString=[wrequest responseString];
        id JSON=[respString objectFromJSONString];
        int code=[AppHelper getIntFromDictionary:JSON key:@"code"];
        NSString* msg=[AppHelper getStringFromDictionary:JSON key:@"message"];
        if (code==REQUEST_CODE_SUCCESS) { 
			 
        }
        else{
            NSLog(@"msg====%@",msg);
            //[AppHelper showAlertMessage:msg];
        }  
    }];
    [asirequest setFailedBlock:^{ 
    }];
    [asirequest startAsynchronous];

}
@end
