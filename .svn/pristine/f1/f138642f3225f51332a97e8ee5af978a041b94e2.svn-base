//
//  PayInfo.h
//  charmgram
//
//  Created by Rui Wei on 13-5-12.
//  Copyright (c) 2013年 Flashfresh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayInfo : NSObject
{
    int         _nPayId;
    NSString*   _strPayName;
    NSString*   _strText;
    NSString*   _strMoney;
    NSString*   _strUrl;
	
}

@property (nonatomic,assign) int _nPayId;
@property (nonatomic,retain) NSString*  _strMoney;
@property (nonatomic,retain) NSString * _strPayName;
@property (nonatomic,retain) NSString * _strText;
@property (nonatomic,retain) NSString * _strUrl;
@property (nonatomic,retain) NSString * _strPicUrl;

-(id)init;
-(id)initWithDictionary:(NSDictionary*)dict;
-(void)AliPay:(int)tradeNo;
@end
