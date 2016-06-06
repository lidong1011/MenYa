//
//  AFNetAPIClient.m
//  MenYa
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import "AFNetAPIClient.h"

@implementation AFNetAPIClient
+ (instancetype)sharedClient {
    static AFNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [_sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _sharedClient.requestSerializer.timeoutInterval = TIMEOUT_SECONDS;
        [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer new];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    });
    
    return _sharedClient;
}

@end
