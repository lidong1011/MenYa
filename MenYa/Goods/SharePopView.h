//
//  SharePopView.h
//  MenYa
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharePopView : UIView
COPY_NONATOMIC_PROPERTY void(^didClick)(SharePopView *,NSInteger);
- (IBAction)btnAction:(UIButton *)sender;
+ (instancetype)createView;
@end
