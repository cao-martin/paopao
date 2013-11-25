//
//  PaymentViewController.h
//  charmgram
//
//  Created by Rui Wei on 13-5-12.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayInfo.h"
#import "MBProgressHUD.h"
#import "WebViewController.h"
#import"MyStoreObserver.h"
@interface PaymentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSString*       _strNo;
    NSString*       _strMoney;
    NSString*       _strDay;
    NSString*       _strNongli;
    NSString*       _strAddress;
    NSString*       _strPayName;
	
    UIButton*       _btnAliPay;
    UIButton*       _btnOtherPay;
    
    UIImageView*    _imgAlipay;
    UIImageView*    _imgOtherPay;
    NSMutableArray* _arrZhiFu;
    
    NSMutableArray* arrPayType;
    NSMutableArray* arrPayInfo;
    UIView* viewPayBg;
    int selectedIndex;
    UITableView* tbContent;
    
    NSMutableArray *arrProducts;
} 
@property (nonatomic,retain) SKProduct*       sProduct;
@property (nonatomic,retain) NSString*       _strMoney;
@property (nonatomic,retain) NSString*       _strDay;
@property (nonatomic,retain) NSString*       _strNongli;
@property (nonatomic,retain) NSString*       _strAddress;
@property (nonatomic,retain) NSString*       _strPayName;
@property (nonatomic,assign) BOOL            isInspirer;
 
@end
