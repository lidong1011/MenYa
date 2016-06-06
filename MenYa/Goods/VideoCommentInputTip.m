//
//  ViewCommentInputTip.m
//  MenYa
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import "VideoCommentInputTip.h"

@implementation VideoCommentInputTip

+ (instancetype)createView
{
    return [[NSBundle mainBundle]loadNibNamed:@"VideoCommentInputTip" owner:self options:nil].lastObject;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
