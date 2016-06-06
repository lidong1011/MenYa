//
//  ShowItemBtn.h
//  MenYa
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowItemBtn : UIButton
@property (strong, nonatomic) UILabel *numLab;
@property (strong, nonatomic) UIImageView *image;
- (void)setItemWithImage:(NSString *)imageName num:(NSInteger)num;
@end
