//
//  Utils.h
//  Hubeizonghe
//
//  Created by Jorion on 4/7/14.
//  Copyright (c) 2014 Michael Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

CGFloat getTextHeight(NSString *content,UIFont *font);

CGFloat getTextWidth(NSString *content,UIFont *font);

NSString* dateToNSString(NSDate * date);
NSString* dateToNSStringWithFormate(NSDate * date,NSString * formate);
NSDate * stringToDate (NSString * string);
NSDate * stringToDateWithFormate (NSString * string,NSString *format);
UIImage * imimageFromColor (UIColor *color);