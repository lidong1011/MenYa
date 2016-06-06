//
//  ContactUsViewController.m
//  后顾无忧
//
//  Created by 李冬强 on 15/8/13.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "AboutCompanyViewController.h"

@interface AboutCompanyViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AboutCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
//    [self aboutRequest];
}


#pragma mark - 关于我们的信息
//- (void)aboutRequest
//{
//    [SVProgressHUD showWithStatus:ksubmitDataing];
//    
//    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
//    __weak typeof(self) weakSelf = self;
//    [manager GET:kgetaboutmeUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
//        _textView.text = dic[@"content"];
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
