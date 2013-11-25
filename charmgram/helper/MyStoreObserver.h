//
//  MyStoreObserver.h
//  PhotoSharing
//
//  Created by administrator on 12-6-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>
#import "JSON.h"
#import "GTMBase64.h"
//#import "Base64Transcoder.h"


@protocol PayDelegate;

@interface MyStoreObserver : NSObject <SKPaymentTransactionObserver>{

}

@property (nonatomic,assign) id <PayDelegate> dele;
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions;
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions; 
- (void)PurchasedTransaction: (SKPaymentTransaction *)transaction; 
- (void)completeTransaction: (SKPaymentTransaction *)transaction; 
- (void)failedTransaction: (SKPaymentTransaction *)transaction;
- (void)paymentQueueRestoreCompletedTransactionFinished: (SKPaymentTransaction *)transaction;
- (void)paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionFailedWithError:(NSError *)error; 

/*
-(void)getProduct:(NSString *)product;
-(void)setDownloadBooks:(NSString *)bookid;
-(void)restoreTransaction: (SKPaymentTransaction *)transaction;
-(void)provideContent:(NSString *)product;
-(void)recordTransaction:(NSString *)product;
 */
- (void)checkReceipt:(SKPaymentTransaction *)transaction;//验证收据

- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length;//对收据进行64编码

@end

@protocol PayDelegate <NSObject>

@optional

- (void)observerPayComplete:(MyStoreObserver *)_observer transation:(SKPaymentTransaction *)_transation;
- (void)observerPayFailed:(MyStoreObserver *)_observer transation:(SKPaymentTransaction *)_transation; 

@end

