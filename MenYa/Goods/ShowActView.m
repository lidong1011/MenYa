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
#define ANIMATEDURI 0.033
@interface ShowActView ()
STRONG_NONATOMIC_PROPERTY UIImageView *backgroundImg;
STRONG_NONATOMIC_PROPERTY NSMutableArray *items;
STRONG_NONATOMIC_PROPERTY NSMutableArray *outImgs;
STRONG_NONATOMIC_PROPERTY NSMutableArray *inImgs;

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
    _outImgs = [NSMutableArray array];
    _inImgs = [NSMutableArray array];
    for (NSInteger i = 0; i < 81; i++) {
        NSString *imgName = [NSString stringWithFormat:@"homePop_0%02ld.png",i];
        if (i<60) {
            [_outImgs addObject:[UIImage imageNamed:imgName]];
        }else{
            [_inImgs addObject:[UIImage imageNamed:imgName]];
        }
    }
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
    NSArray *subViews = self.subviews;
    for (UIView *subView in subViews) {
        [subView removeFromSuperview];
    }
    _datas = datas;
    NSInteger count = datas.count;
    CGFloat itemH = (self.height-150)/count;
    //背景
    _backgroundImg = [[UIImageView alloc]init];
    _backgroundImg.frame = CGRectMake(0, 0, self.width, self.height);
    _backgroundImg.image = [UIImage imageNamed:@"homePop_059.png"];
    [self showOrHiddenWithAnim];
    
    [self addSubview:_backgroundImg];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    scrollView.scrollEnabled = NO;
    [self addSubview:scrollView];
    
    for (NSInteger i = 0; i < count; i++) {
        NSDictionary *dic = datas[i];
        ShowItemBtn *btn = [[ShowItemBtn alloc]initWithFrame:CGRectMake(0, self.height, self.width, itemH)];
//        btn.backgroundColor = [UIColor redColor];
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            btn.frame = CGRectMake(0, 109+i*itemH, self.width, itemH);
        } completion:^(BOOL finished) {
            //
        }];
        btn.tag = i+1;
        [btn setItemWithImage:dic[@"icon"] num:[dic[@"num"] integerValue]];
//        btn.frame = CGRectMake(0, i*itemH, ITEM_W, itemH);
        [btn addTarget:self action:@selector(didTouch:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        [_items addObject:btn];
    }
}

- (void)showOrHiddenWithAnim
{
    if (self.hidden) {
        self.hidden = NO;
        _backgroundImg.animationImages = _outImgs;
        _backgroundImg.animationDuration = _outImgs.count*ANIMATEDURI;
        _backgroundImg.animationRepeatCount = 1;
        [_backgroundImg startAnimating];
    }
    else
    {
        _backgroundImg.animationImages = _inImgs;
        _backgroundImg.animationDuration = _inImgs.count*ANIMATEDURI;
        _backgroundImg.animationRepeatCount = 1;
        _backgroundImg.image = [UIImage imageNamed:@"homePop_080.png"];
        [_backgroundImg startAnimating];
        [self performSelector:@selector(itemAnimHidden) withObject:nil afterDelay:13*ANIMATEDURI];
        [self performSelector:@selector(hiddenBackImag) withObject:nil afterDelay:_backgroundImg.animationDuration];
    }
}

- (void)itemAnimHidden
{
    for (NSInteger i = 0; i < _items.count; i++) {
        ShowItemBtn *btn = _items[i];
        //        btn.backgroundColor = [UIColor redColor];
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            btn.frame = CGRectMake(0, self.height, self.width, 30);
        } completion:^(BOOL finished) {
            //
        }];
    }
}

- (void)hiddenBackImag
{
    self.hidden = YES;
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
