//
//  ViewController.m
//  MenYa
//
//  Created by 李冬强 on 15/11/3.
//  Copyright © 2015年 ldq. All rights reserved.
//

#import "ViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import <MediaPlayer/MediaPlayer.h>
#import "UMSocial.h"
#import "UIColor+ColorWithHex.h"
@interface ViewController ()
//STRONG_NONATOMIC_PROPERTY VLCMediaPlayer *mediaplayer;
STRONG_NONATOMIC_PROPERTY MPMoviePlayerViewController *movieView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[[UIColor orangeColor]colorWithAlphaComponent:0]] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    UIView *drawable = [UIView new];
    drawable.frame = CGRectMake(0, 0, 320, 568);
    drawable.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:drawable];
//    _mediaplayer = [[VLCMediaPlayer alloc] init];
//    _mediaplayer.delegate = self;
//    _mediaplayer.drawable = drawable;
//    
//    [_mediaplayer setVideoAspectRatio:"2"];
//    _mediaplayer.scaleFactor = 9/16.0;
    //    _mediaplayer.adjustFilterEnabled = YES;
    /* create a media object and give it to the player */
    //http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4
    //rtmp://live.hkstv.hk.lxdns.com/live/hks
//    _mediaplayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:@"http://www.menyaer.com/data/image/video/video.mp4"]];
    UIButton *play = [UIButton buttonWithType:UIButtonTypeCustom];
    play.frame = CGRectMake(100, 468-40, 100, 40);
    play.backgroundColor = [UIColor colorWithHexString:@"#ffeeff"];
    [play setTitle:@"play" forState:UIControlStateNormal];
    [play addTarget:self action:@selector(act) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:play];
    
    self.movieView = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:@"http://www.menyaer.com/data/image/video/video.mp4"]];
//    self.movieView.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
//    self.movieView.moviePlayer.backgroundView.backgroundColor = [UIColor redColor];
    [self.movieView.moviePlayer setScalingMode:(MPMovieScalingModeFill)];
//    [self.movieView.moviePlayer setControlStyle:(MPMovieControlStyleNone)];
//    [self.view addSubview:self.movieView.view];
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (void)act{
//    if (_mediaplayer.isPlaying)
//    {
//        [_mediaplayer pause];
//    }
//    else
//    {
//        [_mediaplayer play];
//    }

//    if ([_movieView.moviePlayer isPreparedToPlay]) {
//        [_movieView.moviePlayer stop];
//    } else {
//        [_movieView.moviePlayer play];
//    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    
    return UIInterfaceOrientationPortrait;
}

- (void)setAnim:(UIButton *)sender{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (sender.selected) {
        [self reAnimateForView:keyWindow];
    }
    else
    {
        [self animateForView:keyWindow];
    }
    sender.selected = !sender.selected;
}

- (void)animateForView:(UIView *)view
{
//    [self.view addSubview:maskView];
//    CGRect frame = [tarBarView frame];
//    frame.origin.y = screenHeight - 340;
    [UIView animateWithDuration:0.2f animations:^{
        [view.layer setTransform:[self firstTransform]];
        UIButton *redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        redBtn.frame = CGRectMake(0, 100, 100, 100);
        redBtn.backgroundColor = [UIColor redColor];
        [redBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        [[[UIApplication sharedApplication].windows lastObject] addSubview:redBtn];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2f animations:^{
            [view.layer setTransform:[self secondTransformWithView:view]];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.2 animations:^{
//                [maskView setAlpha:0.5f];
//                [tarBarView setFrame:frame];
            }];
        }];
    }];
}

- (void)reAnimateForView:(UIView *)view
{
//    CGRect frame = [tarBarView frame];
//    frame.origin.y += 340;
    [UIView animateWithDuration:0.2f animations:^{
//        [maskView setAlpha:0.f];
//        [tarBarView setFrame:frame];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2f animations:^{
//            [maskView removeFromSuperview];
            [view.layer setTransform:[self firstTransform]];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.2f animations:^{
                [view.layer setTransform:CATransform3DIdentity];
            }];
        }];
    }];
}

-(CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    return t1;
}

-(CATransform3D)secondTransformWithView:(UIView*)view{
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    t2 = CATransform3DTranslate(t2, 0, view.frame.size.height*-0.08, 0);
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    return t2;
}

//分享
- (void)share
{
    
    [self.navigationController pushViewController:[[ViewController alloc]init] animated:YES];
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:kuserId];
//    if (userId == nil) {
//        kSVPShowInfoText(@"还未登录");
//        return;
//    }
    NSString *title = @"分享";
    NSString *url = [NSString stringWithFormat:@"%@?id=%@",kUrl,userId];
    //微信和朋友圈
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    //    [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:@"%@  分享",title];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    
    [UMSocialData defaultData].extConfig.qqData.title = title;
    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    [UMSocialData defaultData].extConfig.qzoneData.url = url;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUMengAppKey
                                      shareText:[NSString stringWithFormat:@"%@",@"用心创造服务!首次充500送100，充1000送300"]
                                     shareImage:[UIImage imageNamed:@"diankeicon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToQQ,UMShareToSms,UMShareToQzone,UMShareToSina,UMShareToTencent,UMShareToWechatTimeline,UMShareToEmail,nil]
                                       delegate:self];
}

//弹出列表方法presentSnsIconSheetView需要设置delegate为self
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

#pragma mark 支付
- (void)pay
{
    
    //    NSString *partner = @"2088711676501503";
    //    NSString *seller = @"1370173785@qq.com";
    //    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALE2oW1ADflYIEDGhdwP97K3OlUrddfV2vwdoWCvlWZCdL9NG7RmQIUWfge3iwjFt6mhAa6VRoHIIEYAGAM18lFlZY8YLKwGnknPtihxvz1ehyn1dK0XmBWigzkL3sElkBOsg0mXQfKULG4jM8OnWbgnq5EErzNccFkxYvpjaynrAgMBAAECgYEAgKsJyikX/FLgGCgMSRvO3RPsZqqHhY7g0O0ynuDduMHHwp5Z30He1sLd/vxlFpl4INGmRvxblR+ZTzoCNVKV/Q4n+Hvjeg/dyUXYI8x8OIH81ygeGo95oA4DyaqrppAvRFJiRL7LytktX7dtAbYnzHvWMvePO1WU8guY/nJ2wwECQQDY8zrWnwiTnPvM/vhNmNCmq2Nvf8AkLnWwnQe3F3A5DN2HIWvPC1CaRja/VVxkC4mzT8OSTk8AK/Usuq3OieJHAkEA0Rxi3mld9xg9HpkCJmNXjWSBohOOMMPAnS0qthsQjxXHyI2kco/CULWIn4oVIE5W5GtjqtWvp2m1RjDEV6ZJPQJBANZLk3/yAQfGFdcMt3n2i4tGWecF+mYC2k+FHNzWsww3UA6tjY8q7wgkeOmPyL4tw2uyS00WOuTBhuES2KHeAvsCQHkr0b6/n8uHKCOK1kwYVKuCCfw5CLQJOpvZiF5t4HKJVHNKYHhiBV9vUfPgt804l/FUqTRdDqQcBQbfS2be3KECQHt/UJYWmRmxWoUhj461X7h02nmBGEMFij2iuPWsw4wB1tgaF9k1PzeGU7IeVDIPcve1j7QCyvQDH8vJcuD9rgo=";
    
    NSString *partner = @"2088911300996361";
    NSString *seller = @"chuishouxz@163.com";
    NSString *privateKey = @"MIICXQIBAAKBgQDVeJV0DA485jN3rzKJqA+jk99EgqjUhI3tBDORQoaV3dXlNPW69Be1D69iVj0y6OsmgCvX6vxawcxiak73HvckboVqnELXy1KZpfXs/PebUQsVyGBk2rYjjlbjesBMH94pHuBP6z3HlNfLV6QuJNu0uK826Z1voju1s77pW9ji7wIDAQABAoGAUb2txNUE8q7XUGIGwQ1Yh7OMz8gUa+QiEHsGX/4QWPyr9euUmLT1CwDpkIcjQgZMXN7Baxlw7jO9VoYMnLX/vgDXLekXsk4HAkjMg9HEqg6vsoD0aqoW+00Hju8nqTVhrCj7Sh5CTYTmXBl+oH9CzyKsvKX5qOtUNLdwyLnmRykCQQD/Pyq9sbPFBmd08Euivd3M1It1b2UPkKwgDgK4rMcZc+uFs817Mm1lkIm7dAV+RGNcznKaE7AknLEK2hXZZzJ9AkEA1hnbM2olxZaHfwXOvru/IodNM6UTRdHfpYFiCpIC4JRwBs1M5V/pn0doyMpsBVZH6FmtxNbEtr8uptFhhjAa2wJAPuc7Skp76idc4bXCfhXajnsm70cHmeFmefPZ+dcirgQiW+3myuCvkyMevmKmY+rIrft2xL/rXep7uxfp4I0NJQJBAIPXVkF5+xqKkJOq2t5fNNspYGQOIikbjVIYs2v47+al4bp+j/yrrGyWB7Ol2xEKSauOFdChxG8YmbzGMPz2AIMCQQDdp4dMxHA/CZq1CMJLMqSCEjw/2OnH1VvP8+0ofQgCaNqRW2qJqcRaXPydK2RGVPrJ8h10EgAFAWmSIYCvLBUj";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //    NSArray *array = [[UIApplication sharedApplication] windows];
    //    UIWindow* win=[array objectAtIndex:0];
    //    [win setHidden:NO];
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = @"1232323231"; //订单ID（由商家自行制定）
    order.productName = @"fdfsf"; //商品标题
    order.productDescription = @"产品描叙"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"csxzxiaofei";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if([resultDic[@"resultStatus"] integerValue]==9000)
            {
                //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"支付成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                [alert show];
                //                kSVPShowWithText(@"支付成功");
                //
                //                //改变订单状态
                //                [self changeOrderStateRequest];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"支付失败,返回首页" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            //            NSArray *array = [[UIApplication sharedApplication] windows];
            //            UIWindow* win=[array objectAtIndex:0];
            //            [win setHidden:YES];
        }];
        
        //        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
