//
//  AddressModel.h
//  MenYa
//
//  Created by 李冬强 on 15/10/9.
//  Copyright © 2015年 ldq. All rights reserved.
//

#import "BaseModel.h"

@interface AddressModel : BaseModel
STRONG_NONATOMIC_PROPERTY NSString *userid;
STRONG_NONATOMIC_PROPERTY NSString *receiver;
STRONG_NONATOMIC_PROPERTY NSString *address;
STRONG_NONATOMIC_PROPERTY NSString *tel;
STRONG_NONATOMIC_PROPERTY NSString *is_default;
@end
