//
//  PRLColor.m
//  quxiangtou
//
//  Created by wei feng on 15/8/10.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "PRLColor.h"

@implementation PRLColor

+(UIColor *)colorWithHexadecimalRGB:(NSString *)RGBString
{
    return [PRLColor colorWithHexadecimalRGB:RGBString alpha:1.0];
}
+(UIColor *)colorWithHexadecimalRGB:(NSString *)RGBString alpha:(float)alpha
{
    //去掉空格，table newline，nextline   定义的NSCharacterSet 包含药过滤的字符
    NSString * cString = [[RGBString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)  return [UIColor blackColor];
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rstring = [cString substringWithRange:range];
    range.location = 2;
    NSString * gstring = [cString substringWithRange:range];
    range.location = 4;
    NSString * bString = [cString substringWithRange:range];
    unsigned int r,g,b;
    
    [[NSScanner scannerWithString:rstring] scanHexInt:&r];
    [[NSScanner scannerWithString:gstring] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
    
}

@end

UIColor * color(int R,int G, int B){
    return [UIColor colorWithRed:(R / 255.0f)
                           green:(G / 255.0f)
                            blue:(B / 255.0f)
                           alpha:1.0];
}
UIColor * color_alpha(int R,int G, int B, float alpha){
    return [UIColor colorWithRed:(R / 255.0f)
                           green:(G / 255.0f)
                            blue:(B / 255.0f)
                           alpha:alpha];
}


