//
//  QYAPIClient.h
//  JinNangFrameApp
//
//  Created by lide on 12-10-11.
//
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"


#define kTGBaseURLString @" http://paopaobeauty.com/photoshare/webService.php"
//#define kTGBaseURLString @"http://t.m.qyer.com/"

typedef void (^QYAPISuccessBlock)(NSData *data);
typedef void (^QYAPIFailureBlock)(NSError *error);

@interface QYAPIClient : NSObject
{
    NSMutableDictionary         *_headDictionary;
}

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *receivedData;

+ (id)sharedAPIClient;

- (BOOL)isAuthenticated;
- (void)removeAuthentication;

- (void)addObject:(id)object forHeadDictionaryKey:(NSString *)key;
- (void)removeObjectForHeadDictionaryKey:(NSString *)key;

- (id)responseJSON:(NSData *)data;

- (void)queryOpenIdFromTencent:(NSString *)accessToken;

- (void)thirdLoginWithMethod:(NSString *)method
                        type:(NSString *)type
                         uid:(NSUInteger)uid
                         key:(NSString *)key
                     success:(QYAPISuccessBlock)successBlock
                     failure:(QYAPIFailureBlock)failureBlock;

- (void)thirdRegisterWithMethod:(NSString *)method
                           type:(NSString *)type
                          email:(NSString *)email
                       username:(NSString *)username
                            uid:(NSUInteger)uid
                        headpic:(NSString *)headpic
                        success:(QYAPISuccessBlock)successBlock
                        failure:(QYAPIFailureBlock)failureBlock;

- (void)loginWithSina;

@end
