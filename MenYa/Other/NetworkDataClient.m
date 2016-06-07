//
//  NetworkDataClient.m
//  MenYa
//
//  Created by 李冬强 on 15/05/7.
//  Copyright © 2015年 ldq. All rights reserved.
//

#import "NetworkDataClient.h"
#import "AFNetAPIClient.h"
@implementation NetworkDataClient
+ (NSURLSessionDataTask *)getDataWithUrl:(NSString *)urlString parameters:(NSMutableDictionary *)requestParameters success:(FinishBlock)success failure:(ErrorBlock)failure
{
//    [SVProgressHUD showWithStatus:kLoadingData];
    return [[AFNetAPIClient sharedClient] GET:urlString parameters:requestParameters progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
//        NSError *err;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject
//                                                            options:NSJSONReadingMutableContainers
//                                                              error:&err];
        success(task,JSON);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        NSString* errorString;
        MyLog(@"%@",error);
        if (error.code == NSURLErrorTimedOut)
        {
            errorString = (@"请求数据超时!");
        }
        else if (error.code == NSURLErrorNotConnectedToInternet ||
                 error.code == NSURLErrorCannotFindHost ||
                 error.code == NSURLErrorCannotConnectToHost )
        {
            errorString = (@"网络连接失败!");
        }
        else
        {
            errorString = (@"请求数据失败!");
        }
        kSVPShowWithText(errorString);
        failure(task,error);
    }];
//    
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = TIMEOUT_SECONDS;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
//    [manager GET:urlString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSError *err;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject
//                                                            options:NSJSONReadingMutableContainers
//                                                              error:&err];
//        success(operation,dic);
//        
////        success(operation,responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSString* errorString;
//        MyLog(@"%@",error);
//        if (error.code == NSURLErrorTimedOut)
//        {
//            errorString = (@"请求数据超时!");
//        }
//        else if (error.code == NSURLErrorNotConnectedToInternet ||
//                 error.code == NSURLErrorCannotFindHost ||
//                 error.code == NSURLErrorCannotConnectToHost )
//        {
//            errorString = (@"网络连接失败!");
//        }
//        else
//        {
//            errorString = (@"请求数据失败!");
//        }
//        kSVPShowWithText(errorString);
//        failure(operation,error);
//    }];
}

+ (NSURLSessionDataTask *)postDataWithUrl:(NSString *)urlString parameters:(NSMutableDictionary *)requestParameters success:(FinishBlock)success failure:(ErrorBlock)failure
{
//    [SVProgressHUD showWithStatus:kLoadingData];
    return [[AFNetAPIClient sharedClient] POST:urlString parameters:requestParameters progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        //        NSError *err;
        //        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject
        //                                                            options:NSJSONReadingMutableContainers
        //                                                              error:&err];
        success(task,JSON);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        NSString* errorString;
        MyLog(@"%@",error);
        if (error.code == NSURLErrorTimedOut)
        {
            errorString = (@"请求数据超时!");
        }
        else if (error.code == NSURLErrorNotConnectedToInternet ||
                 error.code == NSURLErrorCannotFindHost ||
                 error.code == NSURLErrorCannotConnectToHost )
        {
            errorString = (@"网络连接失败!");
        }
        else
        {
            errorString = (@"请求数据失败!");
        }
        kSVPShowWithText(errorString);
        failure(task,error);
    }];
}



@end
