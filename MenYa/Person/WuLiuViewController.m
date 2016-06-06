//
//  XiaDangViewController.m
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "WuLiuViewController.h"
#import "PayViewController.h"
#import "WuLiuCell.h"
#import "WuLiuModel.h"
@interface WuLiuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

STRONG_NONATOMIC_PROPERTY NSMutableArray *tableViewMutAry;
@end

@implementation WuLiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"物流信息";
    [self initData];
    [self addView];
    [self getOrderDetailRequest];
}

- (void)initData
{
    _tableViewMutAry = [NSMutableArray array];
}

#pragma mark - getOrderDetail
- (void)getOrderDetailRequest
{
    [SVProgressHUD showWithStatus:kLoadingData];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:kuserId];
    [parameter setObject:_orderId forKey:@"orderid"];
    __weak typeof(self) weakSelf = self;
    [NetworkDataClient postDataWithUrl:ksmsUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
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
        
        [_tableViewMutAry removeAllObjects];
        for (NSDictionary *dicItem in dic[@"logistics"])
        {
            [_tableViewMutAry addObject:[WuLiuModel messageWithDict:dicItem]];
        }
        if (_tableViewMutAry.count==0) {
            kSVPShowWithText(@"暂无物流信息");
        }
        else
        {
            [SVProgressHUD dismiss];
        }
        [_tableView reloadData];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:dic[@"message"]];
    }
}

- (void)addView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableViewMutAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    WuLiuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"WuLiuCell" owner:self options:nil][0];
    }
    WuLiuModel *model = _tableViewMutAry[indexPath.row];
    cell.productName.text = model.order_name;
    cell.start.text = model.start;
    cell.timeLab.text = [model.addtime substringToIndex:15];
    cell.destant.text = model.destination;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}

- (IBAction)buyAct:(id)sender
{
    //    PayViewController *vc = [[PayViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
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
