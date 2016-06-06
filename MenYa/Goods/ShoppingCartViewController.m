//
//  ShoppingCartViewController.m
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "GoodsCartCell.h"
#import "GoodsCartModel.h"
#import "PayViewController.h"
#import "MJRefresh.h"
@interface ShoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
STRONG_NONATOMIC_PROPERTY UITableView *tableView;
STRONG_NONATOMIC_PROPERTY NSMutableArray *tableMutAry;
ASSIGN_NONATOMIC_PROPERTY BOOL isSeleAll;
@property (weak, nonatomic) IBOutlet UILabel *heJiLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *jieSuanLab;
STRONG_NONATOMIC_PROPERTY NSMutableArray *selectMutArray;
ASSIGN_NONATOMIC_PROPERTY NSInteger flag;
ASSIGN_NONATOMIC_PROPERTY float allMonye;
STRONG_NONATOMIC_PROPERTY NSString *goodsid;
STRONG_NONATOMIC_PROPERTY NSMutableArray *selectGoods;
@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购物车";
    self.view.backgroundColor = KLColor(237, 239, 241);
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    [self initData];
    [self addView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self getGoodsCartRequest];
}

- (void)edit
{
    
}

- (void)initData
{
    _selectMutArray = [NSMutableArray array];
    _tableMutAry = [NSMutableArray array];
    _selectGoods = [NSMutableArray array];
}

- (IBAction)bottomBtnAction:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        //全选操作
        sender.selected = !sender.selected;
        _isSeleAll = sender.selected;
        [_selectMutArray removeAllObjects];
        if (sender.selected) {
            for(int i=0;i<_tableMutAry.count;i++)
            {
                [_selectMutArray addObject:@"1"];//0为未选，@“1”为选中；
            }
        }
        else
        {
            for(int i=0;i<_tableMutAry.count;i++)
            {
                [_selectMutArray addObject:@"0"];//0为未选，@“1”为选中；
            }
        }
        [self calculate];
        [self.tableView reloadData];
    }
    else
    {
        //结算
//        NSString *goodsIds = nil;
        for (int i=0;i<_selectMutArray.count;i++)
        {
            if ([_selectMutArray[i] isEqualToString:@"1"])
            {
                GoodsCartModel *datamodel = _tableMutAry[i];
                [_selectGoods addObject:datamodel];
//                if (goodsIds == nil) {
//                    goodsIds = datamodel.goodsid;
//                }
//                else
//                {
//                    goodsIds = [NSString stringWithFormat:@"%@,%@", _goodsids,datamodel.goodsid];
//                }
            }
        }
//        _goodsids = goodsIds;
        if (_selectGoods.count == 0) {
            [SVProgressHUD showImage:[UIImage imageWithName:kLogo] status:@"未选中任何商品"];
            return;
        }
        else
        {
            PayViewController *vc = [[PayViewController alloc]init];
            vc.tableViewMutAry = _selectGoods;
            vc.allMoney = _heJiLab.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
//        [self jieSuanRequest];
    }
}

#pragma mark - 购物车列表
- (void)getGoodsCartRequest
{
    [SVProgressHUD showWithStatus:kLoadingData];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:kuserId];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:userid forKey:@"buyerid"];
    [NetworkDataClient postDataWithUrl:kBaseUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        //
        [self getGoodsCartsuccess:JSON];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
}

#pragma mark - 请求返回数据
- (void)getGoodsCartsuccess:(id)response
{
    //    [SVProgressHUD dismiss];
    [_tableView.header endRefreshing];
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    if ([dic[@"code"] intValue]==1)
    {
        [SVProgressHUD dismiss];
        [_tableMutAry removeAllObjects];
        for (NSDictionary *dicItem in dic[@"shopping_cart"])
        {
            [_tableMutAry addObject:[GoodsCartModel messageWithDict:dicItem]];
        }
        [_selectMutArray removeAllObjects];
        for(int i=0;i<_tableMutAry.count;i++)
        {
            if (_isSeleAll==NO) {
                [_selectMutArray addObject:@"0"];//0为未选，@“1”为选中；
            }
            else
            {
                [_selectMutArray addObject:@"1"];//0为未选，@“1”为选中；
            }
        }
        [_tableView reloadData];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:dic[@"message"]];
    }
    
}

- (void)jieSuanRequest
{
    [SVProgressHUD showWithStatus:kLoadingData];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:kuserId];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:@5 forKey:@"addressid"];
    NSMutableArray *selects = [NSMutableArray array];
    for (int i=0;i<_selectMutArray.count;i++)
    {
        if ([_selectMutArray[i] isEqualToString:@"1"])
        {
            GoodsCartModel *model = _tableMutAry[i];
            [selects addObject:model.dataDic[@"id"]];
        }
    }
    [parameter setObject:selects forKey:@"shoppingid"];
    if(selects.count == 0)
    {
        kSVPShowInfoText(@"未选择商品");
        return;
    }
    __weak typeof(self) weakSelf = self;
//    [NetworkDataClient postDataWithUrl:ksettle_shopping_cartUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self jieSuansuccess:responseObject];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //
//    }];
}

- (void)jieSuansuccess:(id)response
{
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    if ([dic[@"code"] intValue]==1)
    {
        [SVProgressHUD dismiss];
        //            OrderViewController *vc = [[OrderViewController alloc]init];
        //            [weakSelf.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"结算失败"];
    }
}

- (void)addView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-60-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
}

- (void)refreshData
{
    [_tableMutAry removeAllObjects];
    [_tableView reloadData];
    [self getGoodsCartRequest];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableMutAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    GoodsCartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsCartCell" owner:self options:nil][0];
    }
    GoodsCartModel *model = _tableMutAry[indexPath.row];
    cell.numLab.text = [NSString stringWithFormat:@"X%@",model.amount];
    cell.priceLab.text = [NSString stringWithFormat:@"￥%.2f",[model.amount integerValue]*[model.sale_price floatValue]];
    NSString *logoPath = [kPicUrl stringByAppendingString:model.spic];
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:logoPath] placeholderImage:[UIImage imageNamed:kDefaultImg_Z]];
    cell.titleLab.text = model.product_name;
    cell.buyWay.text = [model.create_time substringWithRange:NSMakeRange(5, 11)];
    [cell.fuXunBtn addTarget:self action:@selector(singleSeleBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    cell.fuXunBtn.tag = indexPath.row;
    if ([_selectMutArray[indexPath.row] isEqualToString:@"1"])
    {
        cell.deletBtn.hidden = NO;
        cell.fuXunBtn.selected = YES;
        [cell.deletBtn addTarget:self action:@selector(deleteBtnAct:) forControlEvents:UIControlEventTouchUpInside];
        cell.deletBtn.tag = indexPath.row;
    }
    else
    {
        cell.deletBtn.hidden = YES;
    }
    return cell;
}

- (void)singleSeleBtnAct:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        //
        [_selectMutArray replaceObjectAtIndex:sender.tag withObject:@"1"];
    }
    else
    {
        [_selectMutArray replaceObjectAtIndex:sender.tag withObject:@"0"];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    _selectBtn.selected = NO;
    [self calculate];
    MyLog(@"%ld",sender.tag);
}

#pragma mark -计算合计
- (void)calculate
{
    _allMonye = 0.0;
    for (int i = 0; i < _selectMutArray.count; i++) {
        GoodsCartModel *model = _tableMutAry[i];
        if ([_selectMutArray[i]isEqualToString:@"1"]) {
            _allMonye += [model.amount integerValue]*[model.sale_price floatValue];
        }
    }
    _heJiLab.text = [NSString stringWithFormat:@"￥%.2f",_allMonye];
}

- (void)deleteBtnAct:(UIButton *)sender
{
    _flag = sender.tag;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除所选商品" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self deleteGoods];
    }
}

#pragma mark - 删除商品
- (void)deleteGoods
{
    NSString *custId = [[NSUserDefaults standardUserDefaults]stringForKey:kuserId];
    [SVProgressHUD showWithStatus:@"删除中..."];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:custId forKey:@"buyerid"];
    
    GoodsCartModel *model = _tableMutAry[_flag];
    [parameter setObject:@[model.dataDic[@"id"]] forKey:@"ids"];
    
    [NetworkDataClient postDataWithUrl:kBaseUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        NSDictionary *dic = (NSDictionary *)JSON;
        if ([dic[@"code"] intValue]==1)
        {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            //            _messagePageNo = 1;
            //            [self getListRequestWithPageNo:1 andPageSize:@"10"];
//            for (int i=0; i<_selectMutArray.count; i++)
            {
//                if ([_selectMutArray[i] isEqualToString:@"1"])
                {
                    [self.tableMutAry removeObjectAtIndex:_flag];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_flag inSection:0];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"删除不成功"];
        }
    }  failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 124;
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
