//
//  CommentInfo.h
//  charmgram
//
//  Created by Rain on 13-4-16.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInfo : NSObject
@property (nonatomic, assign)int CommentID;  
@property (nonatomic, retain)NSString* UserName;
@property (nonatomic, retain)NSString* AvatarURL;
@property (nonatomic, retain)NSString* Text;
@property (nonatomic, retain)NSString* AddTime;
@property (nonatomic, retain)NSString* GiftUrl;
@property (nonatomic, retain)NSString* GiftName;
-(id)init;
@end
