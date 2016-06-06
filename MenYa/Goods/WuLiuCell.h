//
//  WuLiuCell.h
//  垂手 商家
//
//  Created by 李冬强 on 15/9/17.
//  Copyright (c) 2015年 ldq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WuLiuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *start;
@property (weak, nonatomic) IBOutlet UILabel *destant;
@property (weak, nonatomic) IBOutlet UILabel *yunFeiLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
