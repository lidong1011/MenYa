//
//  GoodsListViewController.m
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsCollectCell.h"
#import "ShoppingCartViewController.h"
#import "GoodsDetailViewController.h"
#import "GoodsModel.h"
#import "MJRefresh.h"
@interface GoodsListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionMutArys;

@end
static NSString *reuseIdCell = @"GoodsCollectCell";
@implementation GoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initData];
    [self initSubview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_collectionMutArys removeAllObjects];
    [self getGoodsRequest];
}

#pragma mark - 获取商品列表
- (void)getGoodsRequest
{
    [SVProgressHUD showWithStatus:kLoadingData];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    if (_flag==0) {
//        [parameter setObject:@1 forKey:@"is_hot"];
//    }
//    else if(_flag==1) {
//        [parameter setObject:@4 forKey:@"product_category"];
//    }
//    else
//    {
//        [parameter setObject:@1 forKey:@"product_category"];
//    }
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"shjid"];
    if (userId == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"还未选择收货机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [parameter setObject:userId forKey:@"userid"];
    __weak typeof(self) weakSelf = self;
    [NetworkDataClient postDataWithUrl:kBaseUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        [self getGoodssuccess:JSON];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];

}

#pragma mark - 请求返回数据
- (void)getGoodssuccess:(id)response
{
    //    [SVProgressHUD dismiss];
    [_collectionView.header endRefreshing];
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    if ([dic[@"code"] intValue]==1)
    {
        [SVProgressHUD dismiss];
        for (NSDictionary *dicItem in dic[@"product"])
        {
            [_collectionMutArys addObject:[GoodsModel messageWithDict:dicItem]];
        }
        if (_collectionMutArys.count==0)
        {
            [SVProgressHUD showInfoWithStatus:@"当前分类还没有产品"];
        }
        [_collectionView reloadData];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:dic[@"message"]];
    }
    
}

- (void)initData
{
    _collectionMutArys = [NSMutableArray array];
}

- (void)initSubview
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-40-60-64) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:reuseIdCell bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdCell];
    self.collectionView.backgroundColor = KLColor(246, 246, 246);
    //    [_collectionView registerClass:[PicturesCollectionViewCell class] forCellWithReuseIdentifier:reuseIdPicCell];
    [self.view addSubview:_collectionView];
    [_collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
}

- (void)refreshData
{
    [_collectionMutArys removeAllObjects];
    [_collectionView reloadData];
    [self getGoodsRequest];
}

//#pragma mark - 商品详情
//- (void)getGoodsMessageRequest
//{
//    [SVProgressHUD showWithStatus:kLoadingData];
//    
//    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    [parameter setObject:_typeId forKey:@"typeid"];
//    [parameter setObject:_sontypeId forKey:@"sontypeid"];
//    [parameter setObject:@"0" forKeyedSubscript:@"istj"];
//    [parameter setObject:@0 forKeyedSubscript:@"pagenumber"];
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
//    __weak typeof(self) weakSelf = self;
//    [manager GET:kgetshopsearchUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [weakSelf getGoodsMesssuccess:responseObject];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        MyLog(@"%@",error);
//        
//    }];
//}
//
//#pragma mark - 请求返回数据
//- (void)getGoodsMesssuccess:(id)response
//{
//    //    [SVProgressHUD dismiss];
//    NSDictionary *dic = (NSDictionary *)response;
//    MyLog(@"%@",dic);
//    if ([dic[@"code"] intValue]==1)
//    {
//        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:kGetDataSuccess];
//        for (NSDictionary *dicItem in dic[@"goods"])
//        {
//            [_collectionMutArys addObject:[HomeCellModel messageWithDict:dicItem]];
//        }
//        [_collectionView reloadData];
//    }
//    else
//    {
//        [SVProgressHUD showInfoWithStatus:dic[@"message"] maskType:SVProgressHUDMaskTypeGradient];
//    }
//}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _collectionMutArys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdCell forIndexPath:indexPath];
    GoodsModel *goodsModel = _collectionMutArys[indexPath.row];
    cell.nameLab.text = goodsModel.product_name;
    cell.priceLab.text = [NSString stringWithFormat:@"￥%.2f",[goodsModel.sale_price floatValue]];
    NSString *logoPath = [kPicUrl stringByAppendingString:goodsModel.spic];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:logoPath] placeholderImage:[UIImage imageNamed:kDefaultImg_Z]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
// 定义每个Item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kWidth-4*10)/3 , (kWidth-4*10)/3+50);
}

// 定义每个UICollectionView的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(9, 9, 9, 9);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"\nitem:%ld\nsection:%ld\nrow:%ld", indexPath.item, indexPath.section, indexPath.row);
    GoodsModel *goodsModel = _collectionMutArys[indexPath.row];
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc]init];
    vc.goodsModel = goodsModel;
//    vc.goodsName = goodsModel.goodsname;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnAction:(UIButton *)sender
{
    if (sender.tag)
    {
        NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:kuserId];
        if (!userid)
        {
            LoginViewController *vc = [[LoginViewController alloc]init];
            CustNavigationViewController *nvc = [[CustNavigationViewController alloc]initWithRootViewController:vc];
            [self presentViewController:nvc animated:YES completion:nil];
            return;
        }
        ShoppingCartViewController *vc = [[ShoppingCartViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        
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
