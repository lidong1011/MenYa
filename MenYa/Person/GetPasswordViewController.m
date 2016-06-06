//
//  GetPasswordViewController.m
//  垂手 供应
//
//  Created by 李冬强 on 15/9/21.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "GetPasswordViewController.h"
#import "User.h"
#import "AccountManager.h"
@interface GetPasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSString *yanZhengMa;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timeInt;
ASSIGN_NONATOMIC_PROPERTY NSInteger step;
@end

@implementation GetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"找回密码";
}

- (IBAction)yanZhengMaAction:(UIButton *)sender
{
    if (![self isValidatePhone:_phoneTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不对"];
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
    NSString *string = [NSString stringWithFormat:@"%d秒后重发",_timeInt];
    [self.yanZhengBtn setTitle:string forState:UIControlStateDisabled];
}

- (IBAction)getPswAction:(id)sender
{
    if (_step == 0) {
        if (![self isValidatePhone:_phoneTF.text]) {
            [SVProgressHUD showErrorWithStatus:@"手机号码不对"];
            return;
        }
        if (![_yanZhengMa isEqualToString:_yanZhengMTF.text])
        {
            [SVProgressHUD showInfoWithStatus:@"验证码输入有误"];
            return;
        }
        [self setStep:_step++];
        return;
    }
    else if (_step == 1)
    {
        if (![_paswordTF.text isEqualToString:_comfirePwdTF.text])
        {
            [SVProgressHUD showInfoWithStatus:@"两次密码输入不一致"];
            return;
        }
        [self getPsdRequest];
        return;
    }
}

#pragma mark - 请求
- (void)getPsdRequest
{
    [SVProgressHUD showWithStatus:@"正在找回..."];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:_phoneTF.text forKey:@"tel"];
    [parameter setObject:_paswordTF.text forKey:@"password"];
    [parameter setObject:_comfirePwdTF.text forKey:@"confirm_password"];
    [parameter setObject:@(1) forKey:@"usertype"]; //1消费 2柜长 3供应
    [NetworkDataClient postDataWithUrl:kBaseUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        [self success:JSON];
        MyLog(@"%@",JSON);
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
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"成功找回"];
        User *user = [[User alloc]init];
        user.username = _phoneTF.text;
        user.password = _paswordTF.text;
        [AccountManager shareManager].user = user;
        [self setStep:_step++];
//        [self.navigationController popViewControllerAnimated:YES];
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

- (void)setStep:(NSInteger)step
{
    _step = step;
    if (_step == 1) {
        _view1.hidden = YES;
        _view2.hidden = NO;
        _img2.hidden = NO;
        [_nextBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    }
    else
    {
        _view2.hidden = YES;
        _img3.hidden = NO;
        _tipLab.hidden = NO;
        _nextBtn.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
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
