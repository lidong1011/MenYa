//
//  OrderGoodsModel.h
//  MenYa
//
//  Created by 李冬强 on 15/10/31.
//  Copyright © 2015年 ldq. All rights reserved.
//
/*order_product	list	销售商品信息
 下面是一条销售商品信息
 id	int	订单商品id
 buytype	string	购买方式
 takecode	string	提取码
 productid	int	商品id
 orderid	int	订单id
 amount	int	购买数量
 product_name	string	商品名称
 product_category	int	商品类型
 vendor_price	double	采购价格
 sale_price	double	销售价格
 brand	string	品牌
 product_code	string	商品编码
 spic	string	商品图片
 scolor	string	商品颜色
 smodel	string	商品规格
 intruduction	string	商品介绍
 machine_name	string	售卖机名称
 machine_code	string	售卖机编码
*/
#import "BaseModel.h"

@interface OrderGoodsModel : BaseModel
STRONG_NONATOMIC_PROPERTY NSString *orderid;
STRONG_NONATOMIC_PROPERTY NSString *productid;
STRONG_NONATOMIC_PROPERTY NSString *buytype;
STRONG_NONATOMIC_PROPERTY NSString *product_name;
STRONG_NONATOMIC_PROPERTY NSString *amount;
STRONG_NONATOMIC_PROPERTY NSString *spic;
STRONG_NONATOMIC_PROPERTY NSString *vendor_price;
@end
