//
//  EntryViewController.h
//  charmgram
//
//  Created by Rui Wei on 13-4-1.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@interface EntryViewController : UIViewController<UIActionSheetDelegate,TencentSessionDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate>
@property(nonatomic, retain) TencentOAuth *tencentOAuth;
@end
