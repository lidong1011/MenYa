//
//  MyOrderModel.h
//  MenYa
//
//  Created by 李冬强 on 15/10/9.
//  Copyright © 2015年 ldq. All rights reserved.
//
/*orders	list	销售订单信息
 下面是一条销售订单属性
 id	int	销售订单id
 order_name	string	订单名称
 order_img	string	订单图片链接
 type	string	销售订单类型
 userid	int	买家id
 counterid	int	卖家id
 machineid	int	售卖机id
 totalprice	double	订单商品总价
 amount	int	订单商品数量
 state	string	订单状态
 sale_date	date	出售日期
 addtime	date	下单时间
 paytime	date	支付时间
 deliverytime	date	发货时间
 receipttime	date	收货时间
 returnedtime	date	退货时间
 closetime	date	完成时间
 code	string	订单号
*/
#import "BaseModel.h"

@interface MyOrderModel : BaseModel
STRONG_NONATOMIC_PROPERTY NSString *orderid;
STRONG_NONATOMIC_PROPERTY NSString *order_name;
STRONG_NONATOMIC_PROPERTY NSString *order_img;
STRONG_NONATOMIC_PROPERTY NSString *totalprice;
STRONG_NONATOMIC_PROPERTY NSString *amount;
STRONG_NONATOMIC_PROPERTY NSString *addtime;
STRONG_NONATOMIC_PROPERTY NSString *state;
STRONG_NONATOMIC_PROPERTY NSString *buytype;
STRONG_NONATOMIC_PROPERTY NSString *takecode;
STRONG_NONATOMIC_PROPERTY NSString *code;
STRONG_NONATOMIC_PROPERTY NSString *express_company;
STRONG_NONATOMIC_PROPERTY NSString *freight;
STRONG_NONATOMIC_PROPERTY NSString *waybill_code;
@end
