//
//  HomeVideoModel.h
//  MenYa
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 ldq. All rights reserved.
/*{
 "Id": 17,
 "Title": "Chewy能量棒",
 "Url": "http://www.menyaer.com/data/image/video/Chewy.mp4",
 "ImgUrl1": "/data/image/0408396208.png",
 "ImgUrl2": "",
 "ImgUrl3": "",
 "ImgUrl4": "",
 "Recomm": 0,
 "Audit": 0,
 "Large": null,
 "Format": null,
 "Type": 0,
 "Position": 0,
 "OrderNum": 15,
 "RegDate": "/Date(1465198971310)/",
 "SkuId": 1060,
 "GoodsId": 14,
 "SkuPrice": 0,
 "CostPrice": 20
 }*/

#import "BaseModel.h"

@interface HomeVideoModel : BaseModel
STRONG_NONATOMIC_PROPERTY NSString *Id;
STRONG_NONATOMIC_PROPERTY NSString *Url;
STRONG_NONATOMIC_PROPERTY NSString *ImgUrl1;
STRONG_NONATOMIC_PROPERTY NSString *ImgUrl2;
STRONG_NONATOMIC_PROPERTY NSString *ImgUrl3;
STRONG_NONATOMIC_PROPERTY NSString *ImgUrl4;
STRONG_NONATOMIC_PROPERTY NSString *SkuId;
STRONG_NONATOMIC_PROPERTY NSString *GoodsId;
STRONG_NONATOMIC_PROPERTY NSString *SkuPrice;
STRONG_NONATOMIC_PROPERTY NSString *CostPrice;
@end
