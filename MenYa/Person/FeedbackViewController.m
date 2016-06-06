//
//  FeedbackViewController.m
//  后顾无忧
//
//  Created by 李冬强 on 15/8/13.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户反馈";
}

- (IBAction)submit:(id)sender
{
    if(_textView.text.length>0)
    {
//        [self feedbackRequest];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"请输入反馈内容"];
        return;
    }
}

//#pragma mark - 提交反馈信息
//- (void)feedbackRequest
//{
//    [SVProgressHUD showWithStatus:ksubmitDataing];
//    
//    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:kuserId];
//    [parameter setObject:userId forKey:@"userid"];
//    [parameter setObject:_textView.text forKey:@"content"];
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
//    __weak typeof(self) weakSelf = self;
//    [manager POST:kpostupfeedbackinfoUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else
//    {
//        [SVProgressHUD showInfoWithStatus:dic[@"message"] maskType:SVProgressHUDMaskTypeGradient];
//    }
//}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [_tipLab removeFromSuperview];
    return YES;
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
