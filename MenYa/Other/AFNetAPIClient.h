//
//  AFNetAPIClient.h
//  MenYa
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class
@interface AFNetAPIClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
@end
