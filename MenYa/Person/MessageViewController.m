//
//  MessageViewController.m
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageDetViewController.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "MJRefresh.h"
@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

STRONG_NONATOMIC_PROPERTY NSMutableArray *tableViewMutAry;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的消息";
    [self initData];
    [self addView];
    [self getMyMessageRequest];
}

- (void)initData
{
    _tableViewMutAry = [NSMutableArray array];
}

#pragma mark - 我的消息
- (void)getMyMessageRequest
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
    }];}

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
        for (NSDictionary *dicItem in dic[@""])
        {
            [_tableViewMutAry addObject:[MessageModel messageWithDict:dicItem]];
        }
        if (_tableViewMutAry.count==0) {
            kSVPShowWithText(@"暂无消息");
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
    [self getMyMessageRequest];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableViewMutAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil][0];
    }
    MessageModel *model = _tableViewMutAry[indexPath.row];
    cell.timeLab.text = model.send_time;
    cell.titleLab.text = model.title;
    cell.contentLab.text = model.content;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageDetViewController *vc = [[MessageDetViewController alloc]init];
    vc.model = _tableViewMutAry[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
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
