//
//  GuZhangViewController.m
//  MenYa
//
//  Created by 李冬强 on 15/11/14.
//  Copyright © 2015年 ldq. All rights reserved.
//

#import "GuZhangViewController.h"
#import "UIViewController+MMDrawerController.h"
@interface GuZhangViewController ()<UIAlertViewDelegate>

@end

@implementation GuZhangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"故障反馈";
}

- (IBAction)btnAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"拨打客服电话 4000449867" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4000449867"]];
    }
}

- (void)back
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
