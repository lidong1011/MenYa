//
//  XiaDangViewController.h
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "BaseViewController.h"
#import "MyOrderModel.h"
@interface XiaDangViewController : BaseViewController
ASSIGN_NONATOMIC_PROPERTY NSInteger flag;
STRONG_NONATOMIC_PROPERTY NSString *orderId;
STRONG_NONATOMIC_PROPERTY NSString *state;
STRONG_NONATOMIC_PROPERTY MyOrderModel *model;
@end
