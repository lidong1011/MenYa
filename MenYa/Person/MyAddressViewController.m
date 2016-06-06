//
//  MyAddressViewController.m
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "MyAddressViewController.h"
#import "AddressCell.h"
#import "AddAddressViewController.h"
#import "AddressModel.h"
#import "MJRefresh.h"
@interface MyAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
STRONG_NONATOMIC_PROPERTY NSMutableArray *tableViewMutAry;
@end

@implementation MyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收货地址管理";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"jia.png"] style:UIBarButtonItemStyleDone target:self action:@selector(addAddress)];
    [self initData];
    [self addView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMyAddressRequest];
}

- (void)initData
{
    _tableViewMutAry = [NSMutableArray array];
}

#pragma mark - 我的地址
- (void)getMyAddressRequest
{
    [SVProgressHUD showWithStatus:kLoadingData];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:kuserId];
    [parameter setObject:userid forKey:@"uid"];
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
    [_tableView.header endRefreshing];
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    if ([dic[@"code"] intValue]==1)
    {
        
        [_tableViewMutAry removeAllObjects];
        for (NSDictionary *dicItem in dic[@"address"])
        {
            [_tableViewMutAry addObject:[AddressModel messageWithDict:dicItem]];
        }
        if (_tableViewMutAry.count==0) {
            kSVPShowWithText(@"暂无地址");
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

- (void)addAddress
{
    AddAddressViewController *vc = [[AddAddressViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
}

- (void)refreshData
{
    [_tableViewMutAry removeAllObjects];
    [_tableView reloadData];
    [self getMyAddressRequest];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableViewMutAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil][0];
    }
    AddressModel *model = _tableViewMutAry[indexPath.row];
    cell.nameLab.text = model.receiver;
    cell.addressLab.text = model.address;
    cell.phoneLba.text = model.tel;
    cell.changeBtn.tag = indexPath.row;
    [cell.changeBtn addTarget:self action:@selector(changeBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    if ([model.is_default isEqualToString:@"1"]) {
        [cell.setDefaultBtn setTitle:@"默认地址" forState:UIControlStateNormal];
    }
    else
    {
        cell.setDefaultBtn.tag = indexPath.row;
        [cell.setDefaultBtn addTarget:self action:@selector(setDefaultAddress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)setDefaultAddress:(UIButton *)sender
{
    AddressModel *model = _tableViewMutAry[sender.tag];
    [self setDefaultAddressRequest:model.dataDic[@"id"]];
}

#pragma mark - 设置地址
- (void)setDefaultAddressRequest:(NSString *)addressId
{
    [SVProgressHUD showWithStatus:kLoadingData];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:kuserId];
    [parameter setObject:userid forKey:@"userid"];
    [parameter setObject:addressId forKey:@"id"];
    __weak typeof(self) weakSelf = self;
    [NetworkDataClient postDataWithUrl:kBaseUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        //
        [weakSelf setDefaultAddresssuccess:JSON];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
}

#pragma mark - 请求返回数据
- (void)setDefaultAddresssuccess:(id)response
{
    //    [SVProgressHUD dismiss];
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    if ([dic[@"code"] intValue]==1)
    {
        kSVPShowInfoText(@"设置成功");
        [self getMyAddressRequest];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:dic[@"message"]];
    }
}

- (void)changeBtnAct:(UIButton *)sender
{
    AddAddressViewController *vc = [[AddAddressViewController alloc]init];
    vc.flag = 1;
    vc.model = _tableViewMutAry[sender.tag];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_flag ==1) {
        AddressModel *model = _tableViewMutAry[indexPath.row];
        _payVc.addressMd = model;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
