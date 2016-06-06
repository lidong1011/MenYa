//
//  Utils.m
//  Hubeizonghe
//
//  Created by Jorion on 4/7/14.
//  Copyright (c) 2014 Michael Fan. All rights reserved.
//

#import "Utils.h"
#define kTEXT_WIDTH 320.0f
#define kTEXT_MARGIN 10.0f

CGFloat getTextHeight(NSString *content,UIFont *font)
{
    CGSize constraint = CGSizeMake(kTEXT_WIDTH - (kTEXT_MARGIN*2),1000.0f);
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGSize size = [content boundingRectWithSize:constraint options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGFloat height = MAX(size.height, 21.0f);
    return height;
}

CGFloat getTextWidth(NSString *content,UIFont *font)
{
    CGSize constraint = CGSizeMake(kTEXT_WIDTH - (kTEXT_MARGIN*2),1000.0f);
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize size = [content boundingRectWithSize:constraint options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    size = [content sizeWithFont:font constrainedToSize:constraint];
    return size.width;
}

NSString* dateToNSString(NSDate * date)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

NSString* dateToNSStringWithFormate(NSDate * date,NSString * formate)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formate];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

NSDate * stringToDate (NSString * string)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

NSDate * stringToDateWithFormate (NSString * string,NSString *format)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

UIImage * imimageFromColor (UIColor *color)
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}