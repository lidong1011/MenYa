//
//  ChooseSpecificationsView.m
//  MenYa
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import "ChooseSpecificationsView.h"
@interface ChooseSpecificationsView ()
STRONG_NONATOMIC_PROPERTY NSMutableArray *specifications;
STRONG_NONATOMIC_PROPERTY UILabel *price;
STRONG_NONATOMIC_PROPERTY UILabel *detail;
STRONG_NONATOMIC_PROPERTY UIImageView *icon;
STRONG_NONATOMIC_PROPERTY UILabel *num;
@end

@implementation ChooseSpecificationsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _specifications  = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    CGFloat space = 10;
    _icon = [UIImageView new];
    _icon.layer.cornerRadius = space;
    _icon.clipsToBounds = YES;
    [self addSubview: _icon];
    
    //关闭ann
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"icon-close-black.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAct) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    _price = [UILabel new];
    _price.font = [UIFont fontWithName:@"bold" size:17];
    [self addSubview:_price];
    
    _detail = [UILabel new];
    _detail.font = [UIFont fontWithName:@"bold" size:14];
    _detail.textColor = [UIColor grayColor];
    _detail.numberOfLines = 2;
    [self addSubview:_detail];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(space);
        make.top.equalTo(self).offset(space);
        make.width.height.equalTo(@100);
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.height.width.equalTo(@40);
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_icon);
        make.right.equalTo(self.mas_right).offset(-space);
        make.left.equalTo(_icon.mas_right).offset(space);
        make.height.equalTo(@40);
    }];
    
    [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_icon.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-space);
        make.left.equalTo(_icon.mas_right).offset(space);
        make.height.equalTo(@60);
    }];
    
    NSArray *specification  = @[@"草莓味",@"草莓味",@"草莓味",@"草莓味"];
    NSInteger row = 3;
    CGFloat btnH = 35;
    CGFloat btnW = (self.width-space*(row + 1))/row;
    for (int i = 0; i < specification.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:specification[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectSpeci:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor orangeColor]];
        btn.frame = CGRectMake(space+(space+btnW)*(i%row), 100 + 2*space+(space+btnH)*(i/row), btnW, btnH);
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        btn.tag = i;
        [self addSubview:btn];
    }
    
    UIView *bottomView = [UIView new];
//    bottomView.backgroundColor = [UIColor grayColor];
    [self addSubview:bottomView];
    
    //确定按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setTitle:@"确定" forState:UIControlStateNormal];
    addBtn.tag = 0;
    [addBtn addTarget:self action:@selector(didTouch:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"btn-yes-bg.png"] forState:UIControlStateNormal];
    [bottomView addSubview:addBtn];
    
    UIButton *addNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addNumBtn.tag = 1;
    [addNumBtn addTarget:self action:@selector(didTouch:) forControlEvents:UIControlEventTouchUpInside];
    [addNumBtn setBackgroundImage:[UIImage imageNamed:@"icon-add.png"] forState:UIControlStateNormal];
    [bottomView addSubview:addNumBtn];
    
    UIButton *minusNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minusNumBtn.tag = 2;
    [minusNumBtn addTarget:self action:@selector(didTouch:) forControlEvents:UIControlEventTouchUpInside];
    [minusNumBtn setBackgroundImage:[UIImage imageNamed:@"icon-minus.png"] forState:UIControlStateNormal];
    [bottomView addSubview:minusNumBtn];
    
    _num = [UILabel new];
    _num.text = @"1";
    _num.textAlignment = NSTextAlignmentCenter;
    _num.font = [UIFont fontWithName:@"bold" size:30];
    [bottomView addSubview:_num];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
        make.height.equalTo(@130);
        make.width.equalTo(@200);
        make.centerX.equalTo(self);
    }];
    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(bottomView);
        make.height.equalTo(@47);
        make.width.equalTo(bottomView);
    }];
    
    [minusNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView);
        make.bottom.equalTo(addBtn.mas_top).offset(-space);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    [addNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView);
        make.height.width.bottom.equalTo(minusNumBtn);
    }];
    
    [_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(minusNumBtn);
        make.right.equalTo(bottomView);
        make.height.equalTo(addNumBtn);
    }];
    
    //添加数据
    _icon.image = [UIImage imageNamed:@"img-1.png"];
    _price.text = @"￥9.9";
    _detail.text = @"Logo tee Logo tee Logo tee";
    
}

- (void)closeAct
{
    //
    CGRect rect = self.frame;
    rect.origin.y = kHeight;
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        //
    }];
    if (_closeView) {
        _closeView(self);
    }
}

- (void)selectSpeci:(UIButton *)sender
{
    MyLog(@"%ld",sender.tag);
    
}

- (void)didTouch:(UIButton *)sender
{
    MyLog(@"%ld",sender.tag);
    if (sender.tag == 0) {
        //确定添加购物车
        
    }else if (sender.tag == 1){
        //数量减少
        
    }else{
        //数量增加
        
    }
}

- (void)setSuperVC:(UIViewController *)superVC
{
    [superVC.view addSubview:self];
    CGRect rect = self.frame;
    rect.origin.y = kHeight-self.height;
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        //
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
