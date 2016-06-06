//
//  NetworkDataClient.h
//  MenYa
//
//  Created by 李冬强 on 14/05/7.
//  Copyright © 2015年 ldq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FinishBlock) (NSURLSessionDataTask * __unused task, id JSON);
typedef void(^ErrorBlock) (NSURLSessionDataTask *__unused task, NSError *error);

@interface NetworkDataClient : NSObject
+ (NSURLSessionDataTask *)getDataWithUrl:(NSString *)urlString parameters:(NSMutableDictionary *)requestParameters success:(FinishBlock)success failure:(ErrorBlock)failure;
+ (NSURLSessionDataTask *)postDataWithUrl:(NSString *)urlString parameters:(NSMutableDictionary *)requestParameters success:(FinishBlock)success failure:(ErrorBlock)failure;
@end
