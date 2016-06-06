//
//  VideoCommentView.m
//  MenYa
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import "VideoCommentView.h"
#import "VideoCommentCell.h"
#import "VideoCommentInputTip.h"
#define leftSpace 20

@interface VideoCommentView ()<UITableViewDelegate,UITableViewDataSource,HPGrowingTextViewDelegate>
STRONG_NONATOMIC_PROPERTY HPGrowingTextView *textView;
STRONG_NONATOMIC_PROPERTY VideoCommentInputTip *tip;
STRONG_NONATOMIC_PROPERTY NSMutableArray *dataSource;
ASSIGN_NONATOMIC_PROPERTY NSInteger flag;
@end

@implementation VideoCommentView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //
        _dataSource = [NSMutableArray array];
        
        //关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"icon-close.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeAct) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];

        //我要评论
        UILabel *lab = [[UILabel alloc]init];
        lab.text  = @"我要评论";
        lab.textColor = [UIColor whiteColor];
        [self addSubview:lab];
        
        _tip = [VideoCommentInputTip createView];
        [self addSubview:_tip];
        
        _textView = [[HPGrowingTextView alloc]init];
        _textView.isScrollable = NO;
        _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        _textView.minNumberOfLines = 1;
        _textView.maxNumberOfLines = 6;
        // you can also set the maximum height in points with maxHeight
        // textView.maxHeight = 200.0f;
        _textView.returnKeyType = UIReturnKeySend; //just as an example
        _textView.font = [UIFont systemFontOfSize:15.0f];
        _textView.delegate = self;
        _textView.textColor = [UIColor whiteColor];
        _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        _textView.backgroundColor = [UIColor clearColor];
//        _textView.placeholder = @"赶紧评论!";
        [self addSubview: _textView];
        
        //横线
        UILabel *line = [[UILabel alloc]init];
        line.backgroundColor = [UIColor whiteColor];
        [self addSubview:line];
        
        //tableView
        UITableView *tableView  = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
        
        //添加约束
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.mas_equalTo(20);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(leftSpace);
            make.top.equalTo(closeBtn.mas_bottom).offset(10);
            make.right.equalTo(self.mas_right).offset(-leftSpace);
            make.height.equalTo(@30);
        }];
        
        [_tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lab.mas_bottom);
            make.centerX.equalTo(self);
            make.width.equalTo(@142);
            make.height.equalTo(@40);
        }];
        
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(lab);
            make.top.equalTo(lab.mas_bottom);
            make.height.equalTo(@40);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(lab);
            make.top.equalTo(_textView.mas_bottom);
            make.height.equalTo(@.5);
        }];
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(line.mas_bottom).offset(1);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    VideoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"VideoCommentCell" owner:self options:nil][0];
    }
//    GoodsCartModel *model = _tableMutAry[indexPath.row];
//    cell.numLab.text = [NSString stringWithFormat:@"X%@",model.amount];
//    cell.priceLab.text = [NSString stringWithFormat:@"￥%.2f",[model.amount integerValue]*[model.sale_price floatValue]];
//    NSString *logoPath = [kPicUrl stringByAppendingString:model.spic];
//    [cell.icon sd_setImageWithURL:[NSURL URLWithString:logoPath] placeholderImage:[UIImage imageNamed:kDefaultImg_Z]];
//    cell.titleLab.text = model.product_name;
//    cell.buyWay.text = [model.create_time substringWithRange:NSMakeRange(5, 11)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87+21;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    CGRect rect = _tip.frame;
    rect.origin.x = -rect.size.width;
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        _tip.frame = rect;
    } completion:^(BOOL finished) {
        //
        _textView.placeholder = @"赶紧评论吧！";
        _tip.hidden = YES;
    }];
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    
    return YES;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
//    float diff = (_textView.frame.size.height - height);
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
        //
        make.height.equalTo(@(height));
    }];
//    CGRect r = containerView.frame;
//    r.size.height -= diff;
//    r.origin.y += diff;
//    containerView.frame = r;
}

- (void)closeAct
{
    //关闭
    if (_closeView) {
        _closeView(self);
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
