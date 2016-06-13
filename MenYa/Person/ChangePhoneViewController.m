//
//  ChangePhoneViewController.m
//  MenYa
//
//  Created by 李冬强 on 15/11/14.
//  Copyright © 2015年 ldq. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "User.h"
#import "AccountManager.h"
@interface ChangePhoneViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic, strong) NSString *yanZhengMa;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timeInt;
@property (nonatomic, assign) NSInteger flag;
@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改绑定手机号码";
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
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:_phoneTF.text forKey:@"to"];
    [NetworkDataClient postDataWithUrl:kBaseUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        NSDictionary *dic = (NSDictionary *)JSON;
        if ([dic[@"code"] integerValue]==1) {
            [SVProgressHUD showSuccessWithStatus:@"发送请求成功"];
            _yanZhengMa = dic[@"sms_code"];
        }
        else
        {
            [SVProgressHUD dismiss];
        }
        MyLog(@"%@",JSON);
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

#pragma mark - 请求
- (void)changeTelRequest
{
    [SVProgressHUD showWithStatus:@"修改中..."];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:kuserId];
    [parameter setObject:_phoneTF.text forKey:@"tel"];
    [parameter setObject:userId forKey:@"uid"];
    [NetworkDataClient postDataWithUrl:kBaseUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        
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
    if ([dic[@"code"] intValue]==1)
    {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"成功变更手机号码"];
        User *user = [[User alloc]init];
        user.username = _phoneTF.text;
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

- (IBAction)nextAction:(UIButton *)sender
{
    if (![self isValidatePhone:_phoneTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"手机号码不对"];
        return;
    }
    if (![_yanZhengMa isEqualToString:_yanZhengMTF.text])
    {
        [SVProgressHUD showInfoWithStatus:@"验证码输入有误"];
        return;
    }
    if (_flag == 1) {
        [self changeTelRequest];
        return;
    }
    else
    {
        _flag = 1;
        _phoneTF.placeholder = @"请输入新手机号码";
        _yanZhengMTF.text = @"";
        _phoneTF.text = @"";
        _yanZhengMa = nil;
        self.yanZhengBtn.enabled = YES;
        [_timer invalidate];
        [_nextBtn setTitle:@"确定" forState:UIControlStateNormal];
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
