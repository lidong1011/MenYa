//
//  MyAddressViewController.h
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "BaseViewController.h"
#import "PayViewController.h"
@interface MyAddressViewController : BaseViewController
ASSIGN_NONATOMIC_PROPERTY NSInteger flag;
STRONG_NONATOMIC_PROPERTY PayViewController *payVc;
@end
