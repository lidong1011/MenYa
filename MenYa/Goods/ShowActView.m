//
//  ShowActView.m
//  MenYa
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import "ShowActView.h"
#import "ShowItemBtn.h"

#define ITEM_W 40
#define ITEM_H 40
@interface ShowActView ()
STRONG_NONATOMIC_PROPERTY NSMutableArray *items;


@end

@implementation ShowActView

- (instancetype)init
{
    self = [super init];
    if (self) { [self initData]; }
    return self;
}

/**
 *  storyboard、xib加载playerView会调用此方法
 */
- (void)awakeFromNib
{
    [self initData];
}

/**
 *  初始化数据
 */
- (void)initData
{
    _items = [NSMutableArray array];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initData];
    }
    return self;
}

- (void)setDatas:(NSArray *)datas
{
    _datas = datas;
    NSInteger count = datas.count;
    CGFloat itemH = self.height/count;
    //背景
    UIImageView *background = [[UIImageView alloc]initWithFrame:self.bounds];
    background.image = [UIImage imageNamed:@"icon-more-bg.png"];
    [self addSubview:background];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    scrollView.scrollEnabled = NO;
    [self addSubview:scrollView];
    for (NSInteger i = 0; i < count; i++) {
        NSDictionary *dic = datas[i];
        ShowItemBtn *btn = [[ShowItemBtn alloc]initWithFrame:CGRectMake(0, i*itemH, self.width, itemH)];
//        btn.backgroundColor = [UIColor redColor];
        btn.tag = i+1;
        [btn setItemWithImage:dic[@"icon"] num:[dic[@"num"] integerValue]];
//        btn.frame = CGRectMake(0, i*itemH, ITEM_W, itemH);
        [btn addTarget:self action:@selector(didTouch:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        [_items addObject:btn];
    }
}

- (void)didTouch:(UIButton *)sender
{
    MyLog(@"%ld",sender.tag);
    self.hidden = YES;
    if (_didClick) {
        _didClick(self,sender.tag);
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
