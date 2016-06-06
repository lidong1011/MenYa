//
//  ChangePasswordViewController.m
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "User.h"
#import "AccountManager.h"
@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passWord_new;
@property (weak, nonatomic) IBOutlet UITextField *passWord_old;
@property (weak, nonatomic) IBOutlet UITextField *passWord_newComfim;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
}

- (IBAction)changePsd:(UIButton *)sender
{
    User *user = [AccountManager shareManager].user;
    if (![_passWord_old.text isEqualToString:user.password]) {
        kSVPShowInfoText(@"旧密码输入错误");
        return;
    }
    if (![_passWord_new.text isEqualToString:_passWord_newComfim.text]) {
        kSVPShowInfoText(@"新密码输入不一致");
        return;
    }
    [self changePsdRequest];
}

#pragma mark - 注册请求
- (void)changePsdRequest
{
    [SVProgressHUD showWithStatus:@"修改中..."];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:kuserId];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:userId forKey:@"id"];
    [parameter setObject:_passWord_newComfim.text forKey:@"password"];
    [parameter setObject:@(1) forKey:@"usertype"]; //1消费 2柜长 3供应
    
}

#pragma mark - 注册请求返回数据
- (void)success:(id)response
{
    //    [SVProgressHUD dismiss];
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    if ([dic[@"code"] intValue]==1)
    {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"修改成功"];
        User *user = [[User alloc]init];
        user.password = _passWord_newComfim.text;
        [AccountManager shareManager].user = user;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:dic[@"message"]];
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
