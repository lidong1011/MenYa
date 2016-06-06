//
//  ShouHuoModel.h
//  MenYa
//
//  Created by 李冬强 on 15/10/9.
//  Copyright © 2015年 ldq. All rights reserved.
//

/*address = "";
 area = "\U6c5f\U5e72";
 "case_amount" = 10;
 city = "\U676d\U5dde";
 "counter_name" = "\U67dc\U957f1";
 id = 1;
 mcode = "shj-0001";
 model = "";
 name = "\U4e0b\U6c99\U8def\U4e00\U53f7";
 provinces = "\U6d59\U6c5f";
 userid = 3;
 */
#import "BaseModel.h"

@interface ShouHuoModel : BaseModel
STRONG_NONATOMIC_PROPERTY NSString *district;
STRONG_NONATOMIC_PROPERTY NSString *city;
STRONG_NONATOMIC_PROPERTY NSString *mcode;
STRONG_NONATOMIC_PROPERTY NSString *name;
STRONG_NONATOMIC_PROPERTY NSString *province;
STRONG_NONATOMIC_PROPERTY NSString *userid;
STRONG_NONATOMIC_PROPERTY NSNumber *latitude;
STRONG_NONATOMIC_PROPERTY NSNumber *longitude;
@end
