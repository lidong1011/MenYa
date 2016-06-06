//
//  GoodsCartModel.h
//  MenYa
//
//  Created by 李冬强 on 15/10/31.
//  Copyright © 2015年 ldq. All rights reserved.
//
/*shopping_cart	list	购物车商品列表
 下面是一条购物车商品属性
 id	int
 goodsid	int	商品id
 amount	int	购买数量
 buytype	string	购买方式
 buyerid	int	买家
 sellerid	int	卖家
 product_name	string	商品名称
 product_category	int	商品分类
 sale_price	double	商品单价
 brand	string	品牌
 spic	string	商品首图
 scolor	string	商品颜色
 smodel	string	商品规格
 intruduction	string	商品介绍
 create_time	date	加入购物车时间
 */

#import "BaseModel.h"

@interface GoodsCartModel : BaseModel
STRONG_NONATOMIC_PROPERTY NSString *goodsid;
STRONG_NONATOMIC_PROPERTY NSString *amount;
STRONG_NONATOMIC_PROPERTY NSString *product_name;
STRONG_NONATOMIC_PROPERTY NSString *spic;
STRONG_NONATOMIC_PROPERTY NSNumber *sale_price;
STRONG_NONATOMIC_PROPERTY NSString *create_time;

@end
