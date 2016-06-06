//
//  MessageModel.h
//  MenYa
//
//  Created by 李冬强 on 15/10/9.
//  Copyright © 2015年 ldq. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel
STRONG_NONATOMIC_PROPERTY NSString *title;
STRONG_NONATOMIC_PROPERTY NSString *content;
STRONG_NONATOMIC_PROPERTY NSString *send_time;
@end
