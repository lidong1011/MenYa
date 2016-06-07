//
//  OrderViewController.m
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "OrderViewController.h"
#import "DOPDropDownMenu.h"
#import "OrderCell.h"
#import "MyOrderModel.h"
#import "XiaDangViewController.h"
#import "MJRefresh.h"
#import "WuLiuWebViewController.h"
@interface OrderViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *states;
@property (nonatomic, strong) NSMutableArray *times;
STRONG_NONATOMIC_PROPERTY NSMutableArray *tableViewMutAry;
ASSIGN_NONATOMIC_PROPERTY NSInteger stateFlag;
ASSIGN_NONATOMIC_PROPERTY NSInteger timeFlag;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"我的订单";
    
    [self initData];
    [self addView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMyOrderRequestWithState:_stateFlag time:_timeFlag];
}

- (void)initData
{
    // 数据
    self.states = @[@"订单状态",@"未支付",@"已支付"];
    _tableViewMutAry = [NSMutableArray array];
    _times = [NSMutableArray arrayWithObject:@"订单时间"];
    for (int i = 0; i<5; i++)
    {
        NSDate *afterDay = [NSDate dateWithTimeIntervalSinceNow:-24*3600*i];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [formatter stringFromDate:afterDay];
        [_times addObject:dateStr];
    }
}

#pragma mark - 我的订单
- (void)getMyOrderRequestWithState:(NSInteger)state time:(NSInteger)time
{
    [SVProgressHUD showWithStatus:kLoadingData];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:kuserId];
    if (state) {
        [parameter setObject:_states[state] forKey:@"state"];
    }
    if (time) {
        [parameter setObject:_times[time] forKey:@"startTime"];
        [parameter setObject:_times[time] forKey:@"endTime"];
    }
    [parameter setObject:userid forKey:@"uid"];
    __weak typeof(self) weakSelf = self;
    [NetworkDataClient postDataWithUrl:ksendVerifyCode parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
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
    [_tableView.header endRefreshing];
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    if ([dic[@"code"] intValue]==1)
    {
        
        [_tableViewMutAry removeAllObjects];
        for (NSDictionary *dicItem in dic[@"orders"])
        {
            [_tableViewMutAry addObject:[MyOrderModel messageWithDict:dicItem]];
        }
        if (_tableViewMutAry.count==0) {
            kSVPShowWithText(@"暂无订单");
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
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, menu.bottom, kWidth, kHeight-menu.bottom-64) style:UITableViewStylePlain];
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
    [self getMyOrderRequestWithState:_stateFlag time:_timeFlag];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableViewMutAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:self options:nil][0];
    }
    MyOrderModel *model = _tableViewMutAry[indexPath.row];
    cell.timeLab.text = model.addtime;
    cell.priceLab.text = [NSString stringWithFormat:@"￥%.2f",[model.totalprice floatValue]];
    cell.titleLab.text = model.code;
    if ([model.buytype isEqualToString:@"送货上门"]) {
        cell.wayLab.text = [NSString stringWithFormat:@"购买方式:%@",model.buytype];
    }
    else
    {
        cell.wayLab.text = [NSString stringWithFormat:@"提取码:%@",model.takecode];
    }
    cell.statusLab.text = model.state;
    NSString *logoPath = [kPicUrl stringByAppendingString:model.order_img];
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:logoPath] placeholderImage:[UIImage imageNamed:kDefaultImg_Z]];
    cell.statusBtn.tag = indexPath.row;
    [cell.statusBtn addTarget:self action:@selector(goTo:) forControlEvents:UIControlEventTouchUpInside];
    if([model.state isEqualToString:@"未支付"])
    {
        [cell.statusBtn setTitle:@"去付款" forState:UIControlStateNormal];
    }
    else if([model.state isEqualToString:@"已支付"])
    {
        [cell.statusBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    }
    return cell;
}

- (void)goTo:(UIButton *)sender
{
    MyOrderModel *model = _tableViewMutAry[sender.tag];
    if([model.state isEqualToString:@"未支付"])
    {
        XiaDangViewController *vc =[[XiaDangViewController alloc]init];
        vc.model = model;
        vc.orderId = model.dataDic[@"id"];
        vc.state = model.state;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([model.state isEqualToString:@"已支付"])
    {
        WuLiuWebViewController *vc =[[WuLiuWebViewController alloc]init];
        vc.express_company = model.express_company;
        vc.waybill_code = model.waybill_code;
        //    PayViewController *vc = [[PayViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyOrderModel *model = _tableViewMutAry[indexPath.row];
    XiaDangViewController *vc =[[XiaDangViewController alloc]init];
    vc.model = model;
    vc.orderId = model.dataDic[@"id"];
    vc.state = model.state;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114;
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 2;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.states.count;
    }else {
        return self.times.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.states[indexPath.row];
    }
    else
    {
        return self.times[indexPath.row];
    }
}

//- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
//{
//    if (column == 0) {
//        if (row == 0) {
//            return self.cates.count;
//        } else if (row == 2){
//            return self.movices.count;
//        } else if (row == 3){
//            return self.hostels.count;
//        }
//    }
//    return 0;
//}
//
//- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
//{
//    if (indexPath.column == 0) {
//        if (indexPath.row == 0) {
//            return self.cates[indexPath.item];
//        } else if (indexPath.row == 2){
//            return self.movices[indexPath.item];
//        } else if (indexPath.row == 3){
//            return self.hostels[indexPath.item];
//        }
//    }
//    return nil;
//}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
        if (indexPath.column == 0) {
            _stateFlag = indexPath.row;
        }
        else
        {
            _timeFlag = indexPath.row;
        }
    }
    [self getMyOrderRequestWithState:_stateFlag time:_timeFlag];
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
