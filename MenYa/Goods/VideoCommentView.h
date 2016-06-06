//
//  VideoCommentView.h
//  MenYa
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 ldq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
@interface VideoCommentView : UIView
COPY_NONATOMIC_PROPERTY void(^closeView)(VideoCommentView *);
@end
