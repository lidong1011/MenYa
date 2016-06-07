//
//  AppDelegate.h
//  垂手小站
//
//  Created by 李冬强 on 15/7/19.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#include "HomeViewController.h"
#import "MMDrawerController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HomeViewController *centerVC;
@property (strong, nonatomic) MMDrawerController * drawerController;
- (void)backToHome;
@end

