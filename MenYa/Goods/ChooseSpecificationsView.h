//
//  ChooseSpecificationsView.h
//  MenYa
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseSpecificationsView : UIView
STRONG_NONATOMIC_PROPERTY NSDictionary *dataDic;
STRONG_NONATOMIC_PROPERTY UIViewController *superVC;
COPY_NONATOMIC_PROPERTY void (^closeView)(ChooseSpecificationsView *);
@end
