//
//  AppDelegate.m
//  垂手小站
//
//  Created by 李冬强 on 15/7/19.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "AppDelegate.h"
#import "CustNavigationViewController.h"

#import "IQKeyboardManager.h"
#import "HomeViewController.h"
#import "ShoppingCartViewController.h"
#import "Person/LeftViewController.h"
#import "LoginViewController.h"
#import "ViewController.h"
#import <AlipaySDK/AlipaySDK.h>
//APP端签名相关头文件
#import "payRequsestHandler.h"

//服务端签名只需要用到下面一个头文件
//#import "ApiXml.h"
#import <QuartzCore/QuartzCore.h>

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialSnsService.h"
#import "UMSocialConfig.h"

@interface AppDelegate ()
@property (nonatomic, strong) UITabBarController *tabBarCtr;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self keyboardSet];
    [self setYouMeng];
    
    //监听返回首页
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kuserId];
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:kuserId] == nil)
//    {
//        WecomeViewController *vc = [[WecomeViewController alloc]init];
//        //        CustNavigationViewController *nvc = [[CustNavigationViewController alloc]initWithRootViewController:vc];
//        self.window.rootViewController = vc;
//    }
//    else
    {
//        ViewController *goodsVC = [[ViewController alloc]init];
        _centerVC = [[HomeViewController alloc]init];
        CustNavigationViewController *homeNVC = [[CustNavigationViewController alloc]initWithRootViewController:_centerVC];
        homeNVC.navigationBarHidden = YES;
        
        LeftViewController *leftVC = [[LeftViewController alloc]init];
        //    CustNavigationViewController *leftDrawer = [[CustNavigationViewController alloc]initWithRootViewController:leftVC];
        
        ShoppingCartViewController *shoppingCart = [[ShoppingCartViewController alloc]init];
        CustNavigationViewController *shoppingCartNVC = [[CustNavigationViewController alloc]initWithRootViewController:shoppingCart];
        
        
        _drawerController = [[MMDrawerController alloc]
                                                 initWithCenterViewController:homeNVC
                                                 leftDrawerViewController:leftVC
                                                 rightDrawerViewController:shoppingCartNVC];
        [_drawerController setRestorationIdentifier:@"MMDrawer"];
        [_drawerController setMaximumLeftDrawerWidth:(kWidth-60)];
        [_drawerController setMaximumRightDrawerWidth:(kWidth-60)];
        [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        self.window.rootViewController = _drawerController;
    }
    //向微信注册
    [WXApi registerApp:APP_ID withDescription:@"demo 2.0"];
    return YES;
}

- (void)backToHome
{
    [self.drawerController setCenterViewController:_centerVC];
}

- (void)keyboardSet
{
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    IQKeyboardManager * manager = [IQKeyboardManager sharedManager];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:10];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
}

- (void)setYouMeng
{
    [UMSocialData setAppKey:kUMengAppKey];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxfcf5d93e67705541" appSecret:@"d08f2810cf6053090fc00d8b75111be2" url:@"http://www.baidu.com"];
    
    //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
    //    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.xr58.com"];
    [UMSocialQQHandler setQQWithAppId:@"1104917651" appKey:@"CUCOCTDgVIgHXytN" url:@"http://www.baidu.com"];
    //打开新浪微博的SSO开关
    //    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //打开腾讯微博SSO开关，设置回调地址，只支持32位
    //    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
    
    //打开人人网SSO开关，只支持32位
    //    [UMSocialRenrenHandler openSSO];
    //    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KWXPAY" object:resp];
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
    return  [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
