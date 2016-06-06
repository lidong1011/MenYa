//
//  AddAddressViewController.m
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *address;

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新增地址";
    if (_flag==1) {
        self.navigationItem.title = @"修改地址";
        _name.text = _model.receiver;
        _phone.text = _model.tel;
        _address.text = _model.address;
    }
}

- (IBAction)btnAction:(id)sender
{
    if (![self isValidatePhone:_phone.text])
    {
        kSVPShowInfoText(@"手机号不对");
        return;
    }
    if (_name.text.length<2) {
        kSVPShowInfoText(@"请输入正确的姓名");
        return;
    }
    if (_address.text.length<2) {
        kSVPShowInfoText(@"请输入地址");
        return;
    }
    [self postAddressRequest];
}

-(BOOL)isValidatePhone:(NSString *)phone {
    
    NSString *phoneRegex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

#pragma mark - 我的地址
- (void)postAddressRequest
{
    [SVProgressHUD showWithStatus:kLoadingData];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:kuserId];
    NSString *url = nil;
    if (_flag == 0)
    {
        url = kBaseUrl;
    }
    else
    {
        url = kBaseUrl;
        [parameter setObject:_model.dataDic[@"id"] forKey:@"id"];
        if([_name.text isEqualToString:_model.receiver]&&[_phone.text isEqualToString:_model.tel]&&[_address.text isEqualToString:_model.address])
        {
            return;
            kSVPShowInfoText(@"未修改任何信息！");
        }
    }
    [parameter setObject:userid forKey:@"userid"];
    [parameter setObject:_name.text forKey:@"receiver"];
    [parameter setObject:_phone.text forKey:@"tel"];
    [parameter setObject:_address.text forKey:@"address"];
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
    if ([dic[@"code"] intValue]==1)
    {
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
