//
//  LoginViewController.m
//  垂手 供应
//
//  Created by 李冬强 on 15/9/21.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "GetPasswordViewController.h"
#import "AccountManager.h"
#import "NSString+DES.h"
#import "KeychainItemWrapper.h"
#import "UIViewController+MMDrawerController.h"
#import "UMSocial.h"
#import "Utils.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
ASSIGN_NONATOMIC_PROPERTY int type;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [_userName setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_password setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //用户名
    self.userName.text = [AccountManager shareManager].user.username;
//    self.password.secureTextEntry = YES;
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:kIsRemembPsd]) {
//        self.isRemembBtn.selected = YES;
//        _isRememb = YES;
//        self.password.text = [AccountManager shareManager].user.password;
//    }
//    //    self.tabBarController.tabBar.hidden = NO;
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isNullOfInput
{
    if (![self isValidatePhone:_userName.text]) {
        [SVProgressHUD showInfoWithStatus:@"手机号码有误！"];
        return YES;
    }
    if (_password.text.length < 6) {
        [SVProgressHUD showInfoWithStatus:@"密码不能小于6位"];
        return YES;
    }
    return NO;
}

#pragma mark - 登陆
- (void)loginRequest
{
    [SVProgressHUD showWithStatus:@"登录中..."];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:_userName.text forKey:@"login_name"];
    //密码加密 MD5
    //    NSString *md5String = [NSString md5_base64:_password.text];
    [parameter setObject:_password.text forKey:@"password"];
    [parameter setObject:@(1) forKey:@"usertype"]; //1消费 2柜长 3供应
    [NetworkDataClient postDataWithUrl:kBaseUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        //
        [self success:JSON];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
}

#pragma mark - 请求返回数据
- (void)success:(id)response
{
    //    [SVProgressHUD dismiss];
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:dic[@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [alert show];
    
    if ([dic[@"code"] intValue]==1)
    {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"登录成功"];
        User *user = [[User alloc]init];
        user.username = _userName.text;
        user.password = _password.text;
        [AccountManager shareManager].user = user;
//        [[NSUserDefaults standardUserDefaults]setBool:_isRememb forKey:kIsRemembPsd];
        [[NSUserDefaults standardUserDefaults]setObject:dic[@"uid"] forKey:kuserId];
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:kUserMsg];
        {
            //            NSArray *array = self.navigationController.viewControllers;
            //            [self.navigationController popToViewController:array[array.count-3] animated:YES];
            [self back:nil];
            //            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"用户名或密码错误" maskType:SVProgressHUDMaskTypeGradient];
    }
}

#pragma mark - textfeild delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==_userName)
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

- (void)registerAct
{
    RegisterViewController *vc = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController: vc animated:YES];
}

- (IBAction)btnAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            if (![self isNullOfInput]) {
                [self loginRequest];
            }
            else
            {
                return;
            }
            break;
        }
        case 1:
        {
            GetPasswordViewController *vc = [[GetPasswordViewController alloc]init];
            [self.navigationController pushViewController: vc animated:YES];
            break;
        }
        case 2:
        {
            //注册
            [self registerAct];
            break;
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

@end
