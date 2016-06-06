//
//  GoodsCartCell.h
//  MenYa
//
//  Created by 李冬强 on 15/10/31.
//  Copyright © 2015年 ldq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *fuXunBtn;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *buyWay;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *deletBtn;

@end
