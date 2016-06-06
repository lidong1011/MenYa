//
//  ShowActView.h
//  MenYa
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowActView : UIView
COPY_NONATOMIC_PROPERTY NSArray *datas;
COPY_NONATOMIC_PROPERTY void (^didClick)(ShowActView *,NSInteger);
@end
