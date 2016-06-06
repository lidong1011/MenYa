//
//  GDOrderListCell.h
//  垂手小站
//
//  Created by 李冬强 on 15/9/14.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDOrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *fuXuanBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@end
