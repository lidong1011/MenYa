//
//  HomePlayerCell.m
//  MenYa
//
//  Created by apple on 16/5/28.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import "HomePlayerCell.h"

@implementation HomePlayerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarImageView.tag = 101;
    
    // 代码添加playerBtn到imageView上
//    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)play:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}

@end
