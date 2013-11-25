//
//  WebViewController.h
//  woqifu
//
//  Created by Rain on 13-3-16.
//  Copyright (c) 2013年 woqifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface WebViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *webView;
    MBProgressHUD *hud;
    UILabel*    _lblName;
} 
@property (nonatomic,assign)BOOL isModalView;
-(void)loadURL:(NSString*)strUrl;
-(void)loadHtml:(NSString *)html;
@end
