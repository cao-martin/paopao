//
//  ThirdLoginViewController.h
//  charmgram
//
//  Created by lide on 13-7-6.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SINA    = 0,
    TENCENT = 1
}OAUTH_TYPE;

@interface ThirdLoginViewController : UIViewController <UIWebViewDelegate>
{
    UIView          *_headView;
    UIButton        *_closeButton;
    
    NSString        *_url;
    OAUTH_TYPE      _oauthType;
}

@property(nonatomic, retain) NSString *url;
@property(nonatomic, assign) OAUTH_TYPE oauthType;


@end
