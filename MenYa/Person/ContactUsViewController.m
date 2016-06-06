//
//  AboutUsViewController.m
//  后顾无忧
//
//  Created by 李冬强 on 15/8/13.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "ContactUsViewController.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"联系我们";
//    [self contactRequest];
}

//#pragma mark - 联系我们的信息
//- (void)contactRequest
//{
//    [SVProgressHUD showWithStatus:ksubmitDataing];
//    
//    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
//    __weak typeof(self) weakSelf = self;
//    [manager GET:kgetlinkmeUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [weakSelf feedbacksuccess:responseObject];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        MyLog(@"%@",error);
//        
//    }];
//}
//
//#pragma mark - 请求返回数据
//- (void)feedbacksuccess:(id)response
//{
//    //    [SVProgressHUD dismiss];
//    NSDictionary *dic = (NSDictionary *)response;
//    MyLog(@"%@",dic);
//    if ([dic[@"code"] intValue]==1)
//    {
//        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:ksubmitMsgSuccess];
////        _textView.text = dic[@"content"];
//    }
//    else
//    {
//        [SVProgressHUD showInfoWithStatus:dic[@"message"] maskType:SVProgressHUDMaskTypeGradient];
//    }
//}

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
