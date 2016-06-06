//
//  PayViewController.m
//  MenYa
//
//  Created by 李冬强 on 15/10/31.
//  Copyright © 2015年 ldq. All rights reserved.
//

#import "PayViewController.h"
#import "MyAddressViewController.h"
#import "GDOrderListCell.h"
#import "GoodsCartModel.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "XiaDangViewController.h"

//APP端签名相关头文件
#import "payRequsestHandler.h"

//服务端签名只需要用到下面一个头文件
#import "ApiXml.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <QuartzCore/QuartzCore.h>
@interface PayViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,WXApiDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
STRONG_NONATOMIC_PROPERTY NSDictionary *dic;
STRONG_NONATOMIC_PROPERTY UIButton *selectPayBtn;
ASSIGN_NONATOMIC_PROPERTY NSInteger payWay;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.navigationItem.title = @"确认订单";
    _priceLab.text = _allMoney;
    _dic = [NSDictionary dictionary];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afterWXpay:) name:@"KWXPAY" object:nil];
    [self getDefaultAddressRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_addressMd) {
        _name.text = _addressMd.receiver;
        _phone.text = _addressMd.tel;
        _address.text = _addressMd.address;
    }
}

#pragma mark - 我的地址
- (void)getDefaultAddressRequest
{
    [SVProgressHUD showWithStatus:kLoadingData];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:kuserId];
    [parameter setObject:userid forKey:@"userid"];
    __weak typeof(self) weakSelf = self;
    [NetworkDataClient postDataWithUrl:ksmsUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        //
//        [self success:JSON];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
}

#pragma mark - 请求返回数据
- (void)getDefaultAddresssuccess:(id)response
{
    //    [SVProgressHUD dismiss];
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    if ([dic[@"code"] intValue]==1)
    {
        kSVPDismiss;
        _addressMd = [AddressModel messageWithDict:dic[@"default_address"]];
        _name.text = _addressMd.receiver;
        _phone.text = _addressMd.tel;
        _address.text = _addressMd.address;
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:dic[@"message"]];
    }
}

- (void)initData
{
    _selectPayBtn = _zfbBtn;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//    _tableViewMutAry = [NSMutableArray array];
}

- (IBAction)btnAction:(UIButton *)sender
{
    if (sender.tag == 0 ) {
        MyAddressViewController *vc = [[MyAddressViewController alloc]init];
        vc.payVc = self;
        vc.flag = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        //支付
        if (_addressMd == nil&&[_buyWayLab.text isEqualToString:@"送货上门"]) {
            kSVPShowInfoText(@"请选择地址");
            return;
        }
        [self jieSuanRequest];
    }
}

- (void)jieSuanRequest
{
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:kuserId];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:_addressMd.dataDic[@"id"] forKey:@"addressid"];
    [parameter setObject:_buyWayLab.text forKey:@"buytype"];
    [parameter setObject:userid forKey:@"takecode"];
    NSMutableArray *selects = [NSMutableArray array];
    for (int i=0;i<_tableViewMutAry.count;i++)
    {
        GoodsCartModel *model = _tableViewMutAry[i];
        [selects addObject:model.dataDic[@"id"]];
    }
    [parameter setObject:selects forKey:@"shoppingid"];
    if(selects.count == 0)
    {
        kSVPShowInfoText(@"未选择商品");
        return;
    }
    [SVProgressHUD showWithStatus:kLoadingData];
    __weak typeof(self) weakSelf = self;
    [NetworkDataClient postDataWithUrl:ksmsUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        //
        [self jieSuansuccess:JSON];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
}

- (void)jieSuansuccess:(id)response
{
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    if ([dic[@"code"] intValue]==1)
    {
//        [SVProgressHUD dismiss];
        kSVPShowInfoText(@"下单成功");
        _dic = dic;
        if (_payWay == 0)
        {
            [self alipayWithDic:dic];
        }
        else
        {
            [self wxPayWithDic:dic];
        }
        //            OrderViewController *vc = [[OrderViewController alloc]init];
        //            [weakSelf.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"结算失败"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 6;
    return _tableViewMutAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    GDOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GDOrderListCell" owner:self options:nil][0];
    }
    GoodsCartModel *model = _tableViewMutAry[indexPath.row];
    cell.nameLab.text = model.product_name;
    cell.numLab.text = model.amount;
    cell.priceLab.text = [NSString stringWithFormat:@"￥%.f",[model.amount integerValue]*[model.sale_price floatValue]];
    NSString *logoPath = [kPicUrl stringByAppendingString:model.spic];
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:logoPath] placeholderImage:[UIImage imageNamed:kDefaultImg_Z]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}

//微信支付
- (void)wxPayWithDic:(NSDictionary *)dic
{
    //从服务器获取支付参数，服务端自定义处理逻辑和格式
    //订单标题
    NSString *ORDER_NAME    = dic[@"order"][@"order_name"];
    //订单金额，单位（元）
    NSString *ORDER_PRICE   = dic[@"order"][@"totalprice"];
    
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPayWithPrice:ORDER_PRICE orderName:ORDER_NAME];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}

- (void)afterWXpay:(NSNotification *)sender
{
    BaseResp *resp = sender.object;
    NSString *strTitle;
//    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                kSVPShowWithText(@"支付成功");
                
                //改变订单状态
                [self changeOrderStateRequest];
                break;
            }
            default:
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"支付失败,返回首页" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
        }
    }
}
                                           
#pragma mark 支付宝支付
- (void)alipayWithDic:(NSDictionary *)dic
{
    
//    NSString *partner = @"2088711676501503";
//    NSString *seller = @"1370173785@qq.com";
//    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALE2oW1ADflYIEDGhdwP97K3OlUrddfV2vwdoWCvlWZCdL9NG7RmQIUWfge3iwjFt6mhAa6VRoHIIEYAGAM18lFlZY8YLKwGnknPtihxvz1ehyn1dK0XmBWigzkL3sElkBOsg0mXQfKULG4jM8OnWbgnq5EErzNccFkxYvpjaynrAgMBAAECgYEAgKsJyikX/FLgGCgMSRvO3RPsZqqHhY7g0O0ynuDduMHHwp5Z30He1sLd/vxlFpl4INGmRvxblR+ZTzoCNVKV/Q4n+Hvjeg/dyUXYI8x8OIH81ygeGo95oA4DyaqrppAvRFJiRL7LytktX7dtAbYnzHvWMvePO1WU8guY/nJ2wwECQQDY8zrWnwiTnPvM/vhNmNCmq2Nvf8AkLnWwnQe3F3A5DN2HIWvPC1CaRja/VVxkC4mzT8OSTk8AK/Usuq3OieJHAkEA0Rxi3mld9xg9HpkCJmNXjWSBohOOMMPAnS0qthsQjxXHyI2kco/CULWIn4oVIE5W5GtjqtWvp2m1RjDEV6ZJPQJBANZLk3/yAQfGFdcMt3n2i4tGWecF+mYC2k+FHNzWsww3UA6tjY8q7wgkeOmPyL4tw2uyS00WOuTBhuES2KHeAvsCQHkr0b6/n8uHKCOK1kwYVKuCCfw5CLQJOpvZiF5t4HKJVHNKYHhiBV9vUfPgt804l/FUqTRdDqQcBQbfS2be3KECQHt/UJYWmRmxWoUhj461X7h02nmBGEMFij2iuPWsw4wB1tgaF9k1PzeGU7IeVDIPcve1j7QCyvQDH8vJcuD9rgo=";
    
    NSString *partner = @"2088911300996361";
    NSString *seller = @"chuishouxz@163.com";
    NSString *privateKey = @"MIICXQIBAAKBgQDVeJV0DA485jN3rzKJqA+jk99EgqjUhI3tBDORQoaV3dXlNPW69Be1D69iVj0y6OsmgCvX6vxawcxiak73HvckboVqnELXy1KZpfXs/PebUQsVyGBk2rYjjlbjesBMH94pHuBP6z3HlNfLV6QuJNu0uK826Z1voju1s77pW9ji7wIDAQABAoGAUb2txNUE8q7XUGIGwQ1Yh7OMz8gUa+QiEHsGX/4QWPyr9euUmLT1CwDpkIcjQgZMXN7Baxlw7jO9VoYMnLX/vgDXLekXsk4HAkjMg9HEqg6vsoD0aqoW+00Hju8nqTVhrCj7Sh5CTYTmXBl+oH9CzyKsvKX5qOtUNLdwyLnmRykCQQD/Pyq9sbPFBmd08Euivd3M1It1b2UPkKwgDgK4rMcZc+uFs817Mm1lkIm7dAV+RGNcznKaE7AknLEK2hXZZzJ9AkEA1hnbM2olxZaHfwXOvru/IodNM6UTRdHfpYFiCpIC4JRwBs1M5V/pn0doyMpsBVZH6FmtxNbEtr8uptFhhjAa2wJAPuc7Skp76idc4bXCfhXajnsm70cHmeFmefPZ+dcirgQiW+3myuCvkyMevmKmY+rIrft2xL/rXep7uxfp4I0NJQJBAIPXVkF5+xqKkJOq2t5fNNspYGQOIikbjVIYs2v47+al4bp+j/yrrGyWB7Ol2xEKSauOFdChxG8YmbzGMPz2AIMCQQDdp4dMxHA/CZq1CMJLMqSCEjw/2OnH1VvP8+0ofQgCaNqRW2qJqcRaXPydK2RGVPrJ8h10EgAFAWmSIYCvLBUj";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = dic[@"orderid"]; //订单ID（由商家自行制定）
    order.productName = dic[@"order"][@"order_name"]; //商品标题
    order.productDescription = @"产品描叙"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[dic[@"order"][@"totalprice"] floatValue]]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"csxzxiaofei";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            MyLog(@"reslut = %@",resultDic);
            if([resultDic[@"resultStatus"] integerValue]==9000)
            {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"支付成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
                kSVPShowWithText(@"支付成功");
            
                //改变订单状态
                [self changeOrderStateRequest];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"支付失败,返回首页" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

//改变订单状态
- (void)changeOrderStateRequest
{
    
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:kuserId];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:_dic[@"orderid"] forKey:@"id"];
    [parameter setObject:@"已支付" forKey:@"state"];
    [SVProgressHUD showWithStatus:kLoadingData];
    [NetworkDataClient postDataWithUrl:ksmsUrl parameters:parameter success:^(NSURLSessionDataTask *task, id JSON) {
        //
        [self changeOrderStatesuccess:JSON];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
}

- (void)changeOrderStatesuccess:(id)response
{
    NSDictionary *dic = (NSDictionary *)response;
    MyLog(@"%@",dic);
    if ([dic[@"code"] intValue]==1)
    {
        [SVProgressHUD dismiss];
        XiaDangViewController *vc = [[XiaDangViewController alloc]init];
        vc.flag = 1;
        vc.orderId = _dic[@"orderid"];
        vc.state = @"已支付";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:dic[@"message"]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
- (IBAction)payWay:(UIButton *)sender
{
    sender.selected = YES;
    _payWay = sender.tag;
    _selectPayBtn.selected = NO;
    _selectPayBtn = sender;
}

- (IBAction)selectWay:(UIButton *)sender
{
    sender.selected = !sender.selected;
    //送货方式
    if (sender.selected) {
        _buyWayLab.text = @"提取码";
    }
    else
    {
        _buyWayLab.text = @"送货上门";
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
