//
//  HomePlayerCell.h
//  MenYa
//
//  Created by apple on 16/5/28.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PlayBtnCallBackBlock)(UIButton *);
@interface HomePlayerCell : UITableViewCell
@property (weak, nonatomic  ) IBOutlet UIImageView          *avatarImageView;
@property (weak, nonatomic  ) IBOutlet UILabel              *titleLabel;
@property (nonatomic, strong) IBOutlet UIButton             *playBtn;
/** model */
//@property (nonatomic, strong) ZFPlayerModel        *model;
/** 播放按钮block */
@property (nonatomic, copy  ) PlayBtnCallBackBlock playBlock;
@end
