//
//  LeftViewController.m
//  垂手小站
//
//  Created by 李冬强 on 15/9/13.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "LeftViewController.h"
#import "SettingsViewController.h"
#import "MyMsgViewController.h"
#import "GuZhangViewController.h"
#import "GoodsViewController.h"
#import "CustNavigationViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
@interface LeftViewController ()


@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kZhuTiColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.mm_drawerController setMaximumLeftDrawerWidth:180];
    self.navigationController.navigationBarHidden = YES;
    NSDictionary *messagedic = [[NSUserDefaults standardUserDefaults]objectForKey:kUserMsg];
    if (messagedic[@"avatar"])
    {
        NSString *logoPath = [kUrl stringByAppendingString:messagedic[@"avatar"]];
    }
//    [self getMyMessageRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.mm_drawerController setMaximumLeftDrawerWidth:kWidth+10];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -
- (void)getMyMessageRequest
{
    [SVProgressHUD showWithStatus:kLoadingData];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:kuserId];
    if (!userid)
    {
        LoginViewController *vc = [[LoginViewController alloc]init];
        CustNavigationViewController *nvc = [[CustNavigationViewController alloc]initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
        return;
    }
    [parameter setObject:userid forKey:@"id"];
    __weak typeof(self) weakSelf = self;
    [NetworkDataClient postDataWithUrl:kBaseUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        //
        [weakSelf success:JSON];
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
        [SVProgressHUD dismiss];
        [[NSUserDefaults standardUserDefaults]setObject:dic[@"user"] forKey:kUserMsg];
        {
            
        }
        
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:dic[@"message"]];
    }
}

- (IBAction)btnAct:(UIButton *)sender
{
    UIViewController *vc = nil;
    switch (sender.tag) {
        case 0:
        {
            HomeViewController *home = [[HomeViewController alloc]init];
//            NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"shjid"];
//            gvc.machineid = userid;
            vc = home;
            [self.mm_drawerController setCenterViewController:vc];
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
                //        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
            }];
            return;
            break;
        }
        case 1:
        {
            if (![[NSUserDefaults standardUserDefaults]objectForKey:kuserId])
            {
                vc = [[LoginViewController alloc]init];
                CustNavigationViewController *nvc = [[CustNavigationViewController alloc]initWithRootViewController:vc];
                [self presentViewController:nvc animated:YES completion:nil];
                return;
            }
//            vc = [[MyMsgViewController alloc]init];
//            [self.mm_drawerController.centerViewController presentViewController:nvc animated:YES completion:nil];
//            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//            return;
//            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            vc = [[SettingsViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 3:
        {
            vc = [[GuZhangViewController alloc]init];
            //            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        default:
            break;
    }
    CustNavigationViewController *nvc = [[CustNavigationViewController alloc]initWithRootViewController:vc];
    [self.mm_drawerController setCenterViewController:nvc];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
//        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    }];
    
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
