//
//  PayViewController.h
//  MenYa
//
//  Created by 李冬强 on 15/10/31.
//  Copyright © 2015年 ldq. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"
@interface PayViewController : BaseViewController
STRONG_NONATOMIC_PROPERTY AddressModel *addressMd;
STRONG_NONATOMIC_PROPERTY NSString *allMoney;
STRONG_NONATOMIC_PROPERTY NSMutableArray *tableViewMutAry;
@property (weak, nonatomic) IBOutlet UILabel *buyWayLab;
- (IBAction)selectWay:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *zfbBtn;

@end
