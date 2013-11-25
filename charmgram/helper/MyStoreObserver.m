//
//  MyStoreObserver.m
//  PhotoSharing
//
//  Created by administrator on 12-6-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MyStoreObserver.h"



@implementation MyStoreObserver 
@synthesize dele;

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions{
	//移除
	
}


//函数用来更新transaction的状态
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
			case SKPaymentTransactionStatePurchasing:
				NSLog(@"SKPaymentTransactionStatePurchasing");
				break;
            case SKPaymentTransactionStatePurchased:
				NSLog(@"SKPaymentTransactionStatePurchased");
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
				NSLog(@"SKPaymentTransactionStateFailed");
            
				[self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
				NSLog(@"SKPaymentTransactionStateRestored");
				[self paymentQueue:queue restoreCompletedTransactionFailedWithError:nil];
            default:
				NSLog(@"unknown transactionState: %d", transaction.transactionState);
                break;
        }
    }
	
}



- (void)PurchasedTransaction: (SKPaymentTransaction *)transaction{
	
	NSLog(@"PurchasedTransaction======");
	
	NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
	[self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
	[transactions release];
	
}


//- (void)completeTransaction:(SKPaymentTransaction *)transaction {
//    // truely purchase IAP product for user
//    NSString* jsonObjectString = [self encode:(uint8_t *)transaction.transactionReceipt.bytes
//                                       length:transaction.transactionReceipt.length];
//    NSString* varStr = [[NSString alloc] initWithFormat:
//                        @"your_url?receipt=%@",
//                        jsonObjectString];
//    VMRequest* request = [[VMRequest alloc] initWithVariableStr:varStr
//                                                    requestType:PURCHASED_IAP_PRODUCT
//                                                       delegate:self];
//    [[VMRequestQueue sharedQueue] addRequest:request
//                                     toQueue:[VMRequestQueue sharedQueue].requestSetInfoQueue];
//    [mIAPRequestDict setObject:request forKey:transaction.transactionIdentifier];
//    [varStr release];
//    [request release];
//}


- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

- (void)completeTransaction: (SKPaymentTransaction *)transaction{
	
	NSLog(@"complete Transaction");
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"completeTransaction" object:nil];
	if (dele) {
		[dele observerPayComplete:self transation:transaction];
	}
	//------检查收据--------
	
	//
	//[self checkReceipt:transaction];
		
}

//-(BOOL)putStringToItunes:(NSData*)iapData{//用户购成功的transactionReceipt
//	NSString*encodingStr = [iapData base64EncodedString];
//	NSString *URL=@"https://sandbox.itunes.apple.com/verifyReceipt";
//	//https://buy.itunes.apple.com/verifyReceipt
//	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];// autorelease];
//	[request setURL:[NSURL URLWithString:URL]];
//	[request setHTTPMethod:@"POST"];
//	//设置contentType
//	[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//	//设置Content-Length
//	[request setValue:[NSString stringWithFormat:@"%d", [encodingStr length]] forHTTPHeaderField:@"Content-Length"];  
//
//	NSDictionary* body = [NSDictionary dictionaryWithObjectsAndKeys:encodingStr, @"receipt-data", nil];
//	SBJsonWriter *writer = [SBJsonWriter new];
//	[request setHTTPBody:[[writer stringWithObject:body] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
//	NSHTTPURLResponse *urlResponse=nil;
//	NSError *errorr=nil;
//	NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
//												 returningResponse:&urlResponse
//															 error:&errorr];
//	 
//	//解析
//	NSString *results=[[NSString alloc]initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
//	CCLOG(@"-Himi-  %@",results);
//	NSDictionary*dic = [results JSONValue];
//	if([[dic objectForKey:@"status"] intValue]==0){//注意，status=@"0" 是验证收据成功
//		return true;
//	}
//	return false;
//	
//}


- (void)checkReceipt:(SKPaymentTransaction *)transaction{
	
	NSString *json = [NSString stringWithFormat:@"receipt-data\":\"%@\"}",[self encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length]];
	
	/*
	“receipt-data” : “(编码后的数据)”
	 */
	
	//测试还是真实
	NSString *urlstring = @"https://sandbox.itunes.apple.com/verifyReceipt";
	//NSString *urlstring = @"https://buy.itunes.apple.com/verifyReceipt";
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
	
	[urlRequest setHTTPMethod:@"POST"];
	
	[urlRequest setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSError *error;
	NSURLResponse *response;
	
	NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest 
										   returningResponse:&response 
													   error:&error];
	
	NSString *resultString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
	
	NSLog(@"resultString======%@",resultString);	
	
	[resultString release];
	
	
}

- (void)failedTransaction: (SKPaymentTransaction *)transaction{
	
	//判断失败的原因
	NSString *strError = @"SKErrorUnknown";
	
	if([transaction.error code] == SKErrorPaymentCancelled || [transaction.error code] == SKErrorUnknown)  
    {  
		strError = @"SKErrorPaymentCancelled";
		NSLog(@"SKErrorPaymentCancelled(code:2)----or----SKErrorUnknown(code:0)");
    }  
    else 
    {  
		//strError = @"SKErrorOther";
		switch ([transaction.error code]) {
			case SKErrorClientInvalid:
				NSLog(@"SKErrorClientInvalid");
				strError = @"client is not allowed to issue the request, etc.";
				break;
			case SKErrorPaymentInvalid:
				NSLog(@"SKErrorPaymentInvalid");
				strError = @"purchase identifier was invalid, etc.";
				break;
			case SKErrorPaymentNotAllowed:
				NSLog(@"SKErrorPaymentNotAllowed");
				strError = @"this device is not allowed to make the payment";
				break;
			default:
				break;
		}	
    }  
	
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"faliedTransaction" object:strError];

	//if (dele) {
//		[dele observerPayFailed:self transation:transaction];
//	}
	
}
- (void)paymentQueueRestoreCompletedTransactionFinished: (SKPaymentTransaction *)transaction{
	NSLog(@"paymentQueueRestoreCompletedTransactionFinished======");

	
}
- (void)paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionFailedWithError:(NSError *)error{
	NSLog(@"paymentQueueRestoreCompletedTransactionFinished======");

} 

#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSLog(@"connectionconnectionconnectionconnection%@",  [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	//[self.receivedData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	switch([(NSHTTPURLResponse *)response statusCode]) {
		case 200:
		case 206:
			break;
		case 304:
			
			break;
		case 400:
			
			break;
			
			
		case 404:
			break;
		case 416:
			break;
		case 403:
			break;
		case 401:
		case 500:
			break;
		default:
			break;
	}	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	
}

@end
