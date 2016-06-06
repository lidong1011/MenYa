//
//  ShowItemBtn.m
//  MenYa
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import "ShowItemBtn.h"
#define ITEM_W 40
#define ITEM_H 40

@implementation ShowItemBtn
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //
        UIView *centerView = [[UIView alloc]init];
        _image = [[UIImageView alloc]init];
        _numLab = [UILabel new];
        _numLab.backgroundColor = KLColor(247, 107, 230);
        _numLab.textAlignment = NSTextAlignmentCenter;
        _numLab.clipsToBounds = YES;
        _numLab.textColor = [UIColor whiteColor];
        _numLab.layer.cornerRadius = 15/2;
        _numLab.font = [UIFont systemFontOfSize:10];
        centerView.userInteractionEnabled = NO;
        [self addSubview:centerView];
        [centerView addSubview:_image];
        [centerView addSubview:_numLab];
        
        [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@(ITEM_W));
            make.height.equalTo(@(ITEM_H));
        }];
        
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(centerView);
            make.size.equalTo(centerView);
        }];
        
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(centerView.mas_top).offset(3);
            make.right.equalTo(centerView.mas_right);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
        }];
    }
    return self;
}

- (void)setItemWithImage:(NSString *)imageName num:(NSInteger)num
{
    _image.image = [UIImage imageNamed:imageName];
    if (num) {
        _numLab.hidden = NO;
        _numLab.text = [NSString stringWithFormat:@"%ld",num];
    }
    else
    {
        _numLab.hidden = YES;
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end