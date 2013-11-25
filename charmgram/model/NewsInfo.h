//
//  NewsInfo.h
//  charmgram
//
//  Created by martin on 13-8-23.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsInfo : NSObject
@property (nonatomic, assign)int UserId;
@property (nonatomic, assign)BOOL isFollow;
@property (nonatomic, assign)BOOL isFan;
@property (nonatomic, retain)NSString* UserName;
@property (nonatomic, retain)NSString* AvatarURL;
@property (nonatomic, retain)NSString *Content;
@property(nonatomic,assign)int SendId;
@property (nonatomic, retain)NSString *SendName;
@property (nonatomic, retain)NSString *SendHeadimg;
@property(nonatomic,retain)NSString *pic;
@property (nonatomic, assign)int typeMes;
@property (nonatomic, assign)int info_sid;
-(id)init;
-(id)initWithDict:(NSDictionary*)dict;
@end