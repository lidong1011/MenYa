//
//  AddAddressViewController.h
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"
#import "PayViewController.h"
@interface AddAddressViewController : BaseViewController
ASSIGN_NONATOMIC_PROPERTY NSInteger flag; //为1时 修改
STRONG_NONATOMIC_PROPERTY AddressModel *model;

@end
