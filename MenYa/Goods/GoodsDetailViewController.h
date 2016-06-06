//
//  GoodsDetailViewController.h
//  垂手小站
//
//  Created by 李冬强 on 15/9/15.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodsModel.h"
@interface GoodsDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *price;
STRONG_NONATOMIC_PROPERTY GoodsModel *goodsModel;
@property (weak, nonatomic) IBOutlet UITextView *introl;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
- (IBAction)btnActoin:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *topImg;
@end
