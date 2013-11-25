//
//  ImageInfo.m
//  charmgram
//
//  Created by Rui Wei on 13-3-25.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "ImageInfo.h"

@implementation ImageInfo
@synthesize ImageID,LikeCount,CommentCount,URL,Distance,AvatarURL,isLiked,UserName,AddTime,arrLike,arrComment;

-(id)init{
    self=[super init];
    self.ImageID=0;
	self.LikeCount=0;
	self.Distance=0;
	self.CommentCount=0;
    self.isLiked=NO;
    self.URL=@"";
	self.AvatarURL=@"";
    self.UserName=@"";
    self.AddTime=@"";
    self.arrLike=[[NSMutableArray alloc] initWithCapacity:0];
    self.arrComment=[[NSMutableArray alloc] initWithCapacity:0];
    return self;
}
@end
