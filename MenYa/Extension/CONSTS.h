//
//  CONSTS.h
//  艺甲名妆
//
//  Created by 李冬强 on 15-3-10.
//  Copyright (c) 2014年 ldq. All rights reserved.
//

#ifndef _____CONSTS_h
#define _____CONSTS_h

#ifdef DEBUG

#define MyLog(...) NSLog(__VA_ARGS__)

#else

#define MyLog(...)

#endif

#define kWidth ([UIScreen mainScreen].bounds.size.width)
#define kHeight ([UIScreen mainScreen].bounds.size.height)
//#define kNavigtBarH ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?64:44)
#define kNavigtBarH (self.navigationController.navigationBar.bottom)
#define kHScare(x) (([UIScreen mainScreen].bounds.size.height*(x))/568)
#define kWScare(x) (([UIScreen mainScreen].bounds.size.width*(x))/320)

#import "UIImage+WB.h"
#import "UIBarButtonItem+WB.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "NetworkDataClient.h"
#import "UIViewExt.h"


// 判断是否为ios7
#define ios7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define kVersion [[[UIDevice currentDevice] systemVersion] floatValue]

// 获得RGB颜色
#define KLColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 是否是4寸iPhone
// 是否是4寸iPhone
#define is4Inch ([UIScreen mainScreen].bounds.size.height == 568)
#define isOver3_5Inch ([UIScreen mainScreen].bounds.size.height > 480)
#define WS(weakSelf)  __weak __typeof(&*self) weakSelf = self;

#define kUserDefaultGet(key) [[NSUserDefaults standardUserDefaults]objectForKey:key]

#define gApp ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define kSVPShowWithText(obj) {[SVProgressHUD showInfoWithStatus:obj];}
#define kSVPShowInfoText(obj) [SVProgressHUD showInfoWithStatus:obj]
#define kSVPDismiss  [SVProgressHUD dismiss]

#define kDEFAULT_DATE_TIME_FORMAT @"yyyy-MM-dd HH:mm:ss"
#define kDATE_TIME_FORMAT_SSS @"yyyy-MM-dd HH:mm:ss.s"
#define kYYYY_MM_DD @"yyyy-MM-dd"
#define ANIMATE_DURATION 0.35

#define GET_DATA            @"GET"
#define POST_DATA           @"POST"
#define PUT_DATA            @"PUT"
#define DELETE_DATA         @"DELETE"
#define TIMEOUT_SECONDS      30

#define ObjIsNotNull(a)                 a != nil && a != [NSNull null]
#define NullObjToString(a)              ObjIsNotNull(a) ? a : @""

#define COPY_NONATOMIC_PROPERTY @property (nonatomic, copy)
#define STRONG_NONATOMIC_PROPERTY @property (nonatomic, strong)
#define ASSIGN_NONATOMIC_PROPERTY @property (nonatomic, assign)
#define WEAK_NONATOMIC_PROPERTY   @property (nonatomic, weak)

#define alertContent(content,btn,btn1) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" \
message:content \
delegate:self   \
cancelButtonTitle:btn \
otherButtonTitles:btn1,nil];  \
[alert show];

#define alertContentWithTag(content,btn,btn1,tag) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" \
message:content \
delegate:self   \
cancelButtonTitle:btn \
otherButtonTitles:btn1,nil];  \
alert.tag = tag; \
[alert show];

#define kUserMsg @"userMsg"
#define kuserId @"userid"

#define kDownloadUrl @"download"
#define kJson_Status @"Status"
#define kJson_Information @"Information"
#define kJson_Data @"Data"
#define kLogo @""
#define kLoadingData @"努力加载中..."
#define kGetDataSuccess @"数据获取成功"   //数据获取成功
#define ksubmitDataing @"数据提交中..."   //数据提交中
#define ksubmitMsgSuccess @"信息提交成功" //信息提交成功
#define kCheckNet @"请检查网络是否正常" //
#define kUMengAppKey @"54c0f334fd98c51ef50002db"

#define kZhuTiColor KLColor(250, 143, 11)
#define kBgColor KLColor(233, 155, 63)

#define kDefaultImg_C @"topImg_my.png"
#define kDefaultImg_Z @"topImg_my.png"
//////接口//////

//测试
#define kUrl @"http://app.menyaer.com/index.php/"

//生产
//#define kUrl  @"csxz.jrcad.com:8080/phpmyadmin/"


#define kBaseUrl  [kUrl stringByAppendingString:@"Api/"]

//获取图片
#define kPicUrl  [kUrl stringByAppendingString:@"admin/data/upload/"]


////////////个人中心/////////////////
//注册 User/register
#define kRegisterUrl  @"User/register"

//登录 User/login
#define kloginUrl  @"User/login"

//获取验证码 Sms/sendVerifyCode
#define ksendVerifyCode  @"Sms/sendVerifyCode"

//验证验证码 Api/Sms/checkVerifyCode
#define kcheckVerifyCode  @"Sms/checkVerifyCode"

//获取图形验证码 User/getImgCode
#define kgetImgCode  @"User/getImgCode"

//验证图形验证码 User/checkImgCode
#define kcheckImgCode  @"User/checkImgCode "

//退出登录 User/logout
#define kuserLogout  @"User/logout"

//快捷登录 User/loginQuick
#define kloginQuick  @"User/loginQuick"


//首页视频列表 Video/getList
//#define kVideogetList  @"Video/getList"

#endif
