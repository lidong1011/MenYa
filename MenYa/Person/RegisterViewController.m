//
//  RegisterViewController.m
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "RegisterViewController.h"
#import "User.h"
#import "AccountManager.h"
#import "UMSocial.h"
@interface RegisterViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSString *yanZhengMa;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timeInt;
@property (nonatomic, assign) int type;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户注册";
    UIImage *image = imimageFromColor([[UIColor clearColor]colorWithAlphaComponent:0]);
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    [_phoneTF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_paswordTF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_yanZhengMTF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (IBAction)yanZhengMaAction:(UIButton *)sender
{
    if (![self isValidatePhone:_phoneTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"手机号码不对"];
        return;
    }
    
    sender.enabled = NO;
    _timeInt = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(returnYanCode) userInfo:nil repeats:YES];
    kSVPShowInfoText(@"获取验证码中");
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:_phoneTF.text forKey:@"phone"];
    [parameter setObject:@"register" forKey:@"sign"];
    [NetworkDataClient getDataWithUrl:ksendVerifyCode parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        //
        MyLog(@"%@",JSON);
        NSDictionary *dic = (NSDictionary *)JSON;
        kSVPShowInfoText(dic[@"Information"]);
        if ([dic[@"Status"] intValue]==1) {
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        
    }];
}

#pragma mark 倒计时
- (void)returnYanCode
{
    _timeInt--;
    if (_timeInt==0) {
        //        self.registerView.verficationBtn.selected = NO;
        self.yanZhengBtn.enabled = YES;
        [_timer invalidate];
    }
    NSString *string = [NSString stringWithFormat:@"重新发送(%d)",_timeInt];
    [self.yanZhengBtn setTitle:string forState:UIControlStateDisabled];
}

- (IBAction)registerAction:(id)sender
{
    if (![self isValidatePhone:_phoneTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"手机号码不对"];
        return;
    }
//    if (![_yanZhengMa isEqualToString:_yanZhengMTF.text])
//    {
//        [SVProgressHUD showInfoWithStatus:@"验证码输入有误"];
//        return;
//    }
    
//    if (![_paswordTF.text isEqualToString:_comfirePwdTF.text])
//    {
//        [SVProgressHUD showInfoWithStatus:@"密码输入有误"];
//        return;
//    }
    
    [self registerRequest];
}

#pragma mark - 注册请求
- (void)registerRequest
{
    [SVProgressHUD showWithStatus:@"注册中..."];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:_phoneTF.text forKey:@"phone"];
    [parameter setObject:_paswordTF.text forKey:@"password"];
    [parameter setObject:_yanZhengMTF.text forKey:@"code"];
    [parameter setObject:@"0" forKey:@"siteId"];
    [parameter setObject:@"0" forKey:@"channelId"];
    [NetworkDataClient postDataWithUrl:kRegisterUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        //
        [self success:JSON];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
}

#pragma mark - 注册请求返回数据
- (void)success:(id)response
{
    //    [SVProgressHUD dismiss];
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    if ([dic[@"Status"] intValue]==1)
    {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"注册成功"];
        User *user = [[User alloc]init];
        user.username = _phoneTF.text;
        user.password = _paswordTF.text;
        [AccountManager shareManager].user = user;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:dic[@"message"]];
    }
}

#pragma mark - textfeild delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==_phoneTF)
    {
        if (range.location>=11) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return NO;
}

-(BOOL)isValidatePhone:(NSString *)phone {
    
    NSString *phoneRegex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

- (IBAction)btnAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            //显示密码
            _paswordTF.secureTextEntry = NO;
        }
        case 5:
        {
            //微信
            _type = 2;
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                    
                    NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                    [self loginRequest:snsAccount.usid];
                }
                
            });
            break;
        }
        case 4:
        {//QQ
            _type= 1;
            BOOL isOauth = [UMSocialAccountManager isOauthWithPlatform:UMShareToQQ];
            if (!isOauth)
            {
                [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ completion:^(UMSocialResponseEntity *response)
                 {
                     if (response.responseCode == UMSResponseCodeSuccess)
                     {
                         NSLog(@"%@",response);
                         UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                         
                         NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                         [self loginRequest:snsAccount.usid];
                     }
                     else
                     {
                         UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
                         snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                                       {
                                                           if (response.responseCode == UMSResponseCodeSuccess)
                                                           {
                                                               [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ completion:^(UMSocialResponseEntity *response)
                                                                {
                                                                    if (response.responseCode == UMSResponseCodeSuccess)
                                                                    {
                                                                        //                                                                        [self doQQLogin:response];
                                                                    }
                                                                    else
                                                                    {
                                                                        
                                                                    }
                                                                }];
                                                           }
                                                       });
                     }
                 }];
            }
            else
            {
                UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
                snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                              {
                                                  if (response.responseCode == UMSResponseCodeSuccess)
                                                  {
                                                      [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ completion:^(UMSocialResponseEntity *response)
                                                       {
                                                           if (response.responseCode == UMSResponseCodeSuccess)
                                                           {
                                                               NSLog(@"---%@---",response);
                                                               UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                                                               
                                                               NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                                                               //                                                               [self doQQLogin:response];
                                                           }
                                                           else
                                                           {
                                                               
                                                           }
                                                       }];
                                                  }
                                              });
            }
            //            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
            //
            //            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            //
            //                //          获取微博用户名、uid、token等
            //
            //                if (response.responseCode == UMSResponseCodeSuccess) {
            //
            //                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            //
            //                    NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            //
            //                }});
            //
            
            break;
        }
        case 3:
        {
            //sina
            //            BOOL isOauth = [UMSocialAccountManager isOauthWithPlatform:UMShareToSina];
            //            if (isOauth)
            //            {
            //                [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina completion:^(UMSocialResponseEntity *response)
            //                 {
            //                     if (response.responseCode == UMSResponseCodeSuccess)
            //                     {
            //                         NSLog(@"---%@---",response);
            ////                         [self doSinaLogin:response];
            //                     }
            //                     else
            //                     {
            //                         UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            //                         snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
            //                                                       {
            //                                                           if (response.responseCode == UMSResponseCodeSuccess)
            //                                                           {
            //                                                               [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina completion:^(UMSocialResponseEntity *response)
            //                                                                {
            //                                                                    if (response.responseCode == UMSResponseCodeSuccess)
            //                                                                    {
            //                                                                        NSLog(@"---%@---",response);
            ////                                                                        [self doSinaLogin:response];
            //                                                                    }
            //                                                                    else
            //                                                                    {
            //
            //                                                                    }
            //                                                                }];
            //                                                           }
            //                                                       });
            //                     }
            //                 }];
            //            }
            //            else
            //            {
            //
            //                UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            //                snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
            //                                              {
            //                                                  if (response.responseCode == UMSResponseCodeSuccess)
            //                                                  {
            //                                                      [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina completion:^(UMSocialResponseEntity *response)
            //                                                       {
            //                                                           if (response.responseCode == UMSResponseCodeSuccess)
            //                                                           {
            ////                                                               [self doSinaLogin:response];
            //                                                           }
            //                                                           else
            //                                                           {
            //
            //                                                           }
            //                                                       }];
            //                                                  }
            //                                              });
            //            }
            _type = 3;
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //          获取微博用户名、uid、token等
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                    
                    NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                    [self loginRequest:snsAccount.usid];
                }});
            break;
        }
        default:
            break;
    }
}

#pragma mark - 登陆
- (void)loginRequest:(NSString *)openId
{
    [SVProgressHUD showWithStatus:@"登录中..."];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:openId forKey:@"openid"];
    //密码加密 MD5
    //    NSString *md5String = [NSString md5_base64:_password.text];
    [parameter setObject:@(_type) forKey:@"type"];
    [NetworkDataClient postDataWithUrl:kBaseUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        [self loginThreesuccess:JSON];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - 请求返回数据
- (void)loginThreesuccess:(id)response
{
    //    [SVProgressHUD dismiss];
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:dic[@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [alert show];
    
    if ([dic[@"code"] intValue]==1)
    {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"登录成功"];
        [[NSUserDefaults standardUserDefaults]setObject:dic[@"userid"] forKey:kuserId];
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:kUserMsg];
        {
            //            NSArray *array = self.navigationController.viewControllers;
            //            [self.navigationController popToViewController:array[array.count-3] animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            //            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:dic[@"message"] maskType:SVProgressHUDMaskTypeGradient];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
