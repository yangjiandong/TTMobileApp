//
//  AFHTTPRequestOperationManager+Util.m
//  iosapp
//
//  Created by AeternChan on 6/18/15.
//  Copyright (c) 2015 oschina. All rights reserved.
//

#import "AFHTTPRequestOperationManager+Util.h"

#import <AFOnoResponseSerializer.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@implementation AFHTTPRequestOperationManager (Util)

+ (instancetype)ClientManager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    //manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:[self generateUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    return manager;
}

+ (NSString *)generateUserAgent
{
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString *IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    return [NSString stringWithFormat:@"TTMobileApp/%@/%@/%@/%@/%@", appVersion,
            [UIDevice currentDevice].systemName,
            [UIDevice currentDevice].systemVersion,
            [UIDevice currentDevice].model,
            IDFV];
}

//同步
- (NSDictionary *)getJsonData
{
    NSString *url = [NSString stringWithFormat:@"请求的url字符串"];

    /* 请求参数字典 */
    NSMutableDictionary *requestParms = [[NSMutableDictionary alloc] init];
    [requestParms setObject:@"value" forKey:@"key"];

    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:url parameters:requestParms error:nil];

    /* 最终继承自 NSOperation，看到这个，大家可能就知道了怎么实现同步的了，也就是利用 NSOperation 来做的同步请求 */
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];

    [requestOperation setResponseSerializer:responseSerializer];

    [requestOperation start];

    [requestOperation waitUntilFinished];

    /* 请求结果 */
    NSDictionary *result = (NSDictionary *)[requestOperation responseObject];

    if (result != nil) {

        return result;
    }
    return nil;
}

//方法2
- (void)getWeatherData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        NSCondition *condition = [[NSCondition alloc] init];

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer     = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

        __block BOOL isSuccess           = NO;
        __block NSDictionary *json       = nil;

        [manager GET:@"http://www.weather.com.cn/data/sk/101010100.html"
          parameters:nil
             success:^(NSURLSessionDataTask *task, id responseObject)
             {
                 NSLog(@"加载成功 %@",responseObject);

                 isSuccess = YES;

                 if ([responseObject isKindOfClass:[NSDictionary class]]) {
                     json = responseObject;
                 }

                 [condition lock];
                 [condition signal];
                 [condition unlock];

             } failure:^(NSURLSessionDataTask *task, NSError *error) {

                    NSLog(@"加载失败 %@",error);

                    isSuccess = NO;

                    [condition lock];
                    [condition signal];
                    [condition unlock];
                }];

        [condition lock];
        [condition wait];
        [condition unlock];

        dispatch_async(dispatch_get_main_queue(), ^{

            /* 回到主线程做进一步处理 */

            if(isSuccess) {

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求成功" message:[NSString stringWithFormat:@"%@",json] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    });
}
@end
