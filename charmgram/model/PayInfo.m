//
//  PayInfo.m
//  charmgram
//
//  Created by Rui Wei on 13-5-12.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import "PayInfo.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "DataSigner.h"

@implementation PayInfo
@synthesize _nPayId, _strPayName,_strText,_strMoney,_strUrl,_strPicUrl;

-(id)init{
    self=[super init];
    self._nPayId       = -1;
    self._strPayName   = @"";
    self._strText       = @"";
    self._strMoney = @"";
    self._strPicUrl=@"";
    return self;
}

-(id)initWithDictionary:(NSDictionary*)dict
{
    self=[super init];
    self._nPayId = [AppHelper getIntFromDictionary:dict key:@"id"];
    self._strMoney = [AppHelper getStringFromDictionary:dict key:@"sum"];
    self._strPayName=[AppHelper getStringFromDictionary:dict key:@"name"];
    self._strText = [AppHelper getStringFromDictionary:dict key:@"text"];
    self._strUrl = [AppHelper getStringFromDictionary:dict key:@"url"];
    self._strPicUrl = [AppHelper getStringFromDictionary:dict key:@"pic"];
	
    return self;
}


-(void) AliPay:(int)tradeNo
{
	/*
	 *商户的唯一的parnter和seller。
	 *本demo将parnter和seller信息存于（AlixPayDemo-Info.plist）中,外部商户可以考虑存于服务端或本地其他地方。
	 *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
	 */
	//如果partner和seller数据存于其他位置,请改写下面两行代码
	NSString *partner = [NSString stringWithFormat:@"%@", ALIPAYPARTNER];
    NSString *seller = [NSString stringWithFormat:@"%@", ALIPAYSELLER];
	
	/*
	 *生成订单信息及签名
	 *由于demo的局限性，本demo中的公私钥存放在AlixPayDemo-Info.plist中,外部商户可以存放在服务端或本地其他地方。
	 */
	//将商品信息赋予AlixPayOrder的成员变量
    
    
	AlixPayOrder *order = [[AlixPayOrder alloc] init];
	order.partner = partner;
	order.seller = seller;
	order.tradeNO = [NSString stringWithFormat:@"%d",tradeNo ]; //订单ID（由商家自行制定）
	order.productName = self._strPayName; //商品标题
	order.productDescription = self._strPayName; //商品描述
	order.amount = self._strMoney; //[NSString stringWithFormat:@"%.2f",product.price]; //商品价格
	order.notifyURL = UrlAliCallBack; //回调URL
	
	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
	NSString *appScheme = @"AlixPay";
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner(ALIPAYPRIVATEKEY);
	NSString *signedString = [signer signString:orderSpec];
	
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil || 1==1) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        //获取安全支付单例并调用安全支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        
        if (ret == kSPErrorAlipayClientNotInstalled) {
            [AppHelper showAlertMessage:@"您还没有安装支付宝，请先安装。"
                                  title:@"提示"
                              lbtnTitle:@"取消"
                              lbtnBlock:nil
                              rbtnTitle:@"去下载"
                              rbtnBlock:^{
                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ZhifubaoUrl]];
                              }];
//			[AppHelper showAlertMessage:@"您还没有安装支付宝，请先安装。" title:@"提示"];
        }
        else if (ret == kSPErrorSignError) {
            NSLog(@"签名错误！");
        }
        
	}
    
} 


@end
