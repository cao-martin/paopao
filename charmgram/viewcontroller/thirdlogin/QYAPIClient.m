//
//  QYAPIClient.m
//  JinNangFrameApp
//
//  Created by lide on 12-10-11.
//
//

#import "QYAPIClient.h"
#import "ASIFormDataRequest.h"
#import "NSObject+SBJson.h"
#import "ASIDataDecompressor.h"
#import "Reachability.h"
#import "SBJson.h"

#define Net_NotAvilable 100000000

@interface QYAPIClient ()
- (void)sendRequestPath:(NSString *)path
                 params:(NSDictionary *)params
                 method:(NSString *)method
                success:(QYAPISuccessBlock)successBlock
                failure:(QYAPIFailureBlock)failureBlock;

- (NSString *)stringFromBaseURL:(NSString *)baseURL withParams:(NSDictionary *)dictionary;
- (id)responseJSON:(NSData *)data;

@end

@implementation QYAPIClient

#pragma mark - private

- (id)responseJSON:(NSData *)data
{
    if(data == nil)
    {
        return nil;
    }
//    NSError *error = nil;
    NSString* strJson=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
     
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *jsonObject = [parser objectWithString:strJson];
    
//    if(error)
//    {
//        return nil;
//    }
    
    
    return jsonObject;
}

- (void)sendRequestPath:(NSString *)path
                 params:(NSDictionary *)params
                 method:(NSString *)method
                success:(QYAPISuccessBlock)successBlock
                failure:(QYAPIFailureBlock)failureBlock;
{
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"貌似网络有点不好，检查一下吧..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        
        NSError *error = [NSError errorWithDomain:@"qyer_guide net Not avilable" code:Net_NotAvilable userInfo:nil];
        failureBlock(error);
        
        return;
    }
    
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_access_token"];
    if(access_token && [access_token length] > 0)
    {
        [_headDictionary setObject:access_token forKey:@"oauth_token"];
    }
    if([method isEqualToString:@"GET"])
    {
        NSString *urlStr = [kTGBaseURLString stringByAppendingFormat:@"%@", path];
        
        urlStr = [self stringFromBaseURL:urlStr withParams:params];
      
        
        ASIHTTPRequest *myRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        __weak ASIHTTPRequest *wrequest=myRequest;
        myRequest.delegate=self;
        
        [myRequest setCompletionBlock:^{
            
            NSData *data = [wrequest responseData];
            
            NSDictionary *dictionary = (NSDictionary *)[self responseJSON:data];
            

            
            if([dictionary objectForKey:@"status"])
            {
                NSInteger status = [[dictionary objectForKey:@"status"] intValue];
                
                if(status == 1)
                {
                    successBlock(data);
                }
                else
                {
                    NSString *info = [dictionary objectForKey:@"info"];
                    
                    NSError *error = [NSError errorWithDomain:@"qyer_travel" code:status userInfo:[NSDictionary dictionaryWithObject:info forKey:NSLocalizedDescriptionKey]];
                    failureBlock(error);
                }
            }
            else {
                
            }
        }];
        
        //        [myRequest setFailedBlock:failureBlock];
        [myRequest setFailedBlock:^{
            
            [wrequest clearDelegatesAndCancel];
            
            NSError *error = [NSError errorWithDomain:@"qyer_guide net Not avilable" code:Net_NotAvilable userInfo:nil];
            failureBlock(error);
        }];
        
        
        

        [myRequest startAsynchronous];
    }
    else if([method isEqualToString:@"POST"])
    {
        NSString *urlStr = [kTGBaseURLString stringByAppendingFormat:@"%@", path];
        
        ASIFormDataRequest *myRequest  = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        __weak ASIFormDataRequest *wrequest=myRequest;

        myRequest.shouldRedirect = YES; //网页自动跳转[例:从'go2eu'跳转到'qyer']!!
        myRequest.delegate=self;
        
        [_headDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [myRequest addPostValue:obj forKey:key];
        }];
        
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            if([obj isKindOfClass:[UIImage class]])
            {
                [myRequest addData:UIImageJPEGRepresentation(obj, 1.0) forKey:key];
            }
            else if([obj isKindOfClass:[NSData class]])
            {
                [myRequest addData:obj forKey:key];
            }
            else
            {
                [myRequest addPostValue:obj forKey:key];
            }
        }];
        
        [myRequest setCompletionBlock:^{
            
            NSData *data = [wrequest responseData];
           

            NSDictionary *dictionary = (NSDictionary *)[self responseJSON:data];
            if([dictionary objectForKey:@"status"])
            {
                NSInteger status = [[dictionary objectForKey:@"status"] intValue];
                
                if(status == 1)
                {
                    successBlock(data);
                }
                else
                {
                    NSString *info = [dictionary objectForKey:@"info"];
                    
                    NSError *error = [NSError errorWithDomain:@"qyer_Guide" code:status userInfo:[NSDictionary dictionaryWithObject:info forKey:NSLocalizedDescriptionKey]];
                    failureBlock(error);
                }
            }
            else {
                
            }
        }];
        
        //        [myRequest setFailedBlock:failureBlock];
        [myRequest setFailedBlock:^{
            
            [wrequest clearDelegatesAndCancel];
            
            NSError *error = [NSError errorWithDomain:@"qyer_guide net Not avilable" code:Net_NotAvilable userInfo:nil];
            failureBlock(error);
        }];
        //        [myRequest setDidStartSelector:@selector(dataLoadSarted:)];
        //        [myRequest setDidFinishSelector:@selector(dataLoadFinished:)];
        //        [myRequest setDidFailSelector:@selector(dataLoadFailored:)];
        [myRequest startAsynchronous];
    }
    else 
    {
        //TODO Lide need to handle other HTTP method
    }
}

- (NSString *)stringFromBaseURL:(NSString *)baseURL withParams:(NSDictionary *)dictionary
{
    NSString *fullString = [NSString stringWithString:[baseURL stringByAppendingFormat:@"?"]];
    
    for(id key in [_headDictionary allKeys])
    {
        fullString = [fullString stringByAppendingFormat:@"%@=%@&", key, [_headDictionary objectForKey:key]];
    }
    
    for(id key in [dictionary allKeys])
    {
        fullString = [fullString stringByAppendingFormat:@"%@=%@&", key, [dictionary objectForKey:key]];
    }
    
    fullString = [fullString substringToIndex:([fullString length] - 1)];
    
    return fullString;
}

#pragma mark - public
static id APIClient = nil;
+ (id)sharedAPIClient
{
    
    @synchronized(APIClient){
        if(APIClient == nil)
        {
            APIClient = [[self alloc] init];
        }
    }
    
    return APIClient;
}

- (BOOL)isAuthenticated
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"qyerlogin"] boolValue])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)removeAuthentication
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"qyerlogin"];
}

- (void)addObject:(id)object forHeadDictionaryKey:(NSString *)key
{
    if(_headDictionary != nil)
    {
        [_headDictionary setObject:object forKey:key];
    }
}

- (void)removeObjectForHeadDictionaryKey:(NSString *)key
{
    if([_headDictionary objectForKey:key])
    {
        [_headDictionary removeObjectForKey:key];
    }
}

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _headDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        NSString *client_id = @"kClientId";
        NSString *client_secret = @"kClientSecret";
        NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
        
        [_headDictionary setObject:client_id forKey:@"client_id"];
        [_headDictionary setObject:client_secret forKey:@"client_secret"];
        
        if(access_token && [access_token length] > 0)
        {
            [_headDictionary setObject:access_token forKey:@"oauth_token"];
        }
    }
    return self;
}

- (void)queryOpenIdFromTencent:(NSString *)accessToken{
    NSString *url_str = [NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/me?access_token=%@",accessToken];
    NSURL *url = [NSURL URLWithString:url_str];
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    [self.connection start];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *r = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    if([r rangeOfString:@"error"].length){
        
    }else{
        int begin = [r rangeOfString:@":" options:NSBackwardsSearch].location+2;
        int end = [r rangeOfString:@"}" options:NSBackwardsSearch].location-1;
        NSString *openid = [r substringWithRange:NSMakeRange(begin, end-begin)];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:openid forKey:@"openid"];
        [userDefaults synchronize];
    }
    
}

- (void)thirdLoginWithMethod:(NSString *)method
                        type:(NSString *)type
                         uid:(NSUInteger)uid
                         key:(NSString *)key
                     success:(QYAPISuccessBlock)successBlock
                     failure:(QYAPIFailureBlock)failureBlock
{

}

- (void)thirdRegisterWithMethod:(NSString *)method
                           type:(NSString *)type
                          email:(NSString *)email
                       username:(NSString *)username
                            uid:(NSUInteger)uid
                        headpic:(NSString *)headpic
                        success:(QYAPISuccessBlock)successBlock
                        failure:(QYAPIFailureBlock)failureBlock
{
    
}

- (void)loginWithSina
{
    NSString *urlStr = @"https://api.weibo.com/2/users/show.json";
    
    NSDictionary *params = @{@"source":@"419321585",@"access_tpken":[[NSUserDefaults standardUserDefaults] objectForKey:@"sina_access_token"],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    urlStr = [self stringFromBaseURL:urlStr withParams:params];
    
    ASIHTTPRequest *myRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
      __weak ASIFormDataRequest *wrequest=myRequest;
    [myRequest setRequestMethod:@"GET"];
    
//    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        
//        if([obj isKindOfClass:[UIImage class]])
//        {
//            [myRequest addData:UIImageJPEGRepresentation(obj, 1.0) forKey:key];
//        }
//        else if([obj isKindOfClass:[NSData class]])
//        {
//            [myRequest addData:obj forKey:key];
//        }
//        else
//        {
//            [myRequest addPostValue:obj forKey:key];
//        }
//    }];
    
    [myRequest setCompletionBlock:^{
        
        NSData *data = [wrequest responseData];
        
        NSDictionary *dictionary = (NSDictionary *)[[QYAPIClient sharedAPIClient] responseJSON:data];
        
        NSLog(@"%@", dictionary);
    }];
    
    [myRequest startAsynchronous];
}

@end
