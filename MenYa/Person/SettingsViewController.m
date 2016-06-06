//
//  SettingsViewController.m
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "SettingsViewController.h"
#import "ChangePasswordViewController.h"
#import "ChangePhoneViewController.h"
#import "AboutCompanyViewController.h"
#import "ContactUsViewController.h"
#import "FeedbackViewController.h"
#import "UIViewController+MMDrawerController.h"
@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *titles;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    [self initData];
    [self addView];
}

- (void)initData
{
    _titles = @[@"修改绑定手机",@"修改密码",@"去App Store打分",@"不给力，给点建议",@"联系我们",@"关于"];
}

- (void)back
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
//    HomeViewController *vc = [[HomeViewController alloc]init];
//    CustNavigationViewController *nvc = [[CustNavigationViewController alloc]initWithRootViewController:vc];
//    [self.mm_drawerController setCenterViewController:nvc];
}

- (void)addView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            ChangePhoneViewController *vc = [[ChangePhoneViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            ChangePasswordViewController *vc = [[ChangePasswordViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            FeedbackViewController *vc = [[FeedbackViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:
        {
            AboutCompanyViewController *vc = [[AboutCompanyViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            ContactUsViewController *vc = [[ContactUsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
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
