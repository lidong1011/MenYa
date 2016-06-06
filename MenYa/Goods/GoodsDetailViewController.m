//
//  GoodsDetailViewController.m
//  垂手小站
//
//  Created by 李冬强 on 15/9/15.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "CustNavigationViewController.h"
#import "LoginViewController.h"
@interface GoodsDetailViewController ()
STRONG_NONATOMIC_PROPERTY NSDictionary *dic;
ASSIGN_NONATOMIC_PROPERTY NSInteger num;
@end

@implementation GoodsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _goodsModel.product_name;
    _introl.text = _goodsModel.intruduction;
    _dic = [NSDictionary dictionary];
    _num = 1;
    [self getGoodsDetailRequest];
}

#pragma mark - 获取商品详情
- (void)getGoodsDetailRequest
{
    [SVProgressHUD showWithStatus:kLoadingData];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:_goodsModel.dataDic[@"id"] forKey:@"productid"];
    __weak typeof(self) weakSelf = self;
    [NetworkDataClient postDataWithUrl:kBaseUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        //
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
}

#pragma mark - 请求返回数据
- (void)getGoodsDetailsuccess:(id)response
{
    //    [SVProgressHUD dismiss];
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    if ([dic[@"code"] intValue]==1)
    {
        /*sname	string	产品名称
         cid	int	柜子编号
         price	double	供货价格
         sale_price	double	零售价格
         brand	string	品牌
         scode	string	产品编号
         spic	string	产品首图地址
         scolor	string	产品颜色
         smodel	string	产品型号
         s_state	string	产品状态
         intruduction	string	产品介绍
         cname	string	产品分类名称
         pictures	list	产品图片数组
         pictures属性
         image	string	产品图片地址
         id	int	
         productid	int	产品id
*/
        [SVProgressHUD dismiss];
        _dic = dic[@"product"];
        _nameLab.text = dic[@"product"][@"sname"];
        _introl.text = dic[@"product"][@"intruduction"];
        _price.text = [NSString stringWithFormat:@"￥%.2f",[dic[@"product"][@"sale_price"] floatValue]];
        NSArray *array = dic[@"product"][@"pictures"];
        if (array.count) {
            NSString *logoPath = [kPicUrl stringByAppendingString:array[0][@"image"]];
            [_topImg sd_setImageWithURL:[NSURL URLWithString:logoPath] placeholderImage:[UIImage imageNamed:kDefaultImg_Z]];
        }
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:dic[@"message"]];
    }
}

- (void)addToGoodsCart
{
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:kuserId];
    if (!userid)
    {
        LoginViewController *vc = [[LoginViewController alloc]init];
        CustNavigationViewController *nvc = [[CustNavigationViewController alloc]initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
        return;
    }
    [SVProgressHUD showWithStatus:kLoadingData];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:@(_num) forKey:@"amount"];
    [parameter setObject:_dic[@"id"] forKey:@"goodsid"];
    [parameter setObject:userid forKey:@"buyerid"];
    __weak typeof(self) weakSelf = self;
    [NetworkDataClient postDataWithUrl:kBaseUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        [self addToGoodsCartsuccess:JSON];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];

}

#pragma mark - 请求返回数据
- (void)addToGoodsCartsuccess:(id)response
{
    //    [SVProgressHUD dismiss];
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    if ([dic[@"code"] intValue]==1)
    {
        /*
         */
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"加入成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:dic[@"message"]];
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

- (IBAction)btnActoin:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
        {
            //数量加
            _num++;
            _numLab.text = [NSString stringWithFormat:@"%ld",_num];
            
            break;
        }
        case 1:
        {
            //数量减
            if (_num == 1) {
                return;
            }
            _num--;
            _numLab.text = [NSString stringWithFormat:@"%ld",_num];
            break;
        }
        case 2:
        {
            
            break;
        }
        case 3:
        {
            //放入购物车
            [self addToGoodsCart];
            break;
        }
        default:
            break;
    }
}
@end
