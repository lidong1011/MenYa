//
//  WuLiuModel.h
//  MenYa
//
//  Created by 李冬强 on 15/11/4.
//  Copyright © 2015年 ldq. All rights reserved.
/*logistics	list	销售订单物流信息
 下面是一条物流信息
 id	int
 orderid	int	订单id
 order_name	string	订单名称（货物）
 code	string	订单编号
 addtime	date	创建时间
 start	string	起始地
 destination	string	目的地
 info	string	物流信息
 express	string	物流公司
 courier	string	快递员
 waybill_code	string	快递单号
*/

#import "BaseModel.h"

@interface WuLiuModel : BaseModel
STRONG_NONATOMIC_PROPERTY NSString *orderid;
STRONG_NONATOMIC_PROPERTY NSString *addtime;
STRONG_NONATOMIC_PROPERTY NSString *start;
STRONG_NONATOMIC_PROPERTY NSString *destination;
STRONG_NONATOMIC_PROPERTY NSString *order_name;
STRONG_NONATOMIC_PROPERTY NSString *spic;
STRONG_NONATOMIC_PROPERTY NSString *vendor_price;
@end
