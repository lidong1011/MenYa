//
//  SharePopView.m
//  MenYa
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import "SharePopView.h"

@implementation SharePopView
- (IBAction)btnAction:(UIButton *)sender
{
    if (_didClick) {
        _didClick(self,sender.tag);
    }
}

+ (instancetype)createView
{
    return [[NSBundle mainBundle]loadNibNamed:@"SharePopView" owner:self options:nil].lastObject;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
