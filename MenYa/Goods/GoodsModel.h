//
//  GoodsModel.h
//  MenYa
//
//  Created by 李冬强 on 15/10/9.
//  Copyright © 2015年 ldq. All rights reserved.
//
/*
 {
 amount = 10;
 brand = "\U53ef\U53e3\U53ef\U4e50";
 "case_num" = 1;
 cname = "\U996e\U6599";
 id = 1;
 intruduction = "";
 "machine_code" = "shj-0001";
 "machine_name" = "\U4e0b\U6c99\U8def\U4e00\U53f7";
 machineid = 1;
 "product_category" = 1;
 "product_code" = "yl-001";
 "product_name" = "\U96ea\U78a7";
 productid = 1;
 "sale_price" = "2.5";
 scolor = "";
 smodel = vcxz;
 spic = "";
 "vendor_price" = "1.5";
 }

 */
#import "BaseModel.h"

@interface GoodsModel : BaseModel
STRONG_NONATOMIC_PROPERTY NSString *productid;
STRONG_NONATOMIC_PROPERTY NSString *sale_price;
STRONG_NONATOMIC_PROPERTY NSString *intruduction;
STRONG_NONATOMIC_PROPERTY NSString *product_category;
STRONG_NONATOMIC_PROPERTY NSString *spic;
STRONG_NONATOMIC_PROPERTY NSString *product_name;
@end
