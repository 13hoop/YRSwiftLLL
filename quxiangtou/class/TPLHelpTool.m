//
//  TPLHelpTool.m
//  quxiangtou
//
//  Created by wei feng on 15/8/10.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//
#define MORE_WIDTH 0
#define ANIMATION_DURATION_DEFAULT 0.5

#import "TPLHelpTool.h"

@implementation TPLHelpTool
+(NSString *)getDeviceType
{
    return [[UIDevice currentDevice] model];
}

+(CGRect)getScreenRect
{
    return [[UIScreen mainScreen]bounds];
}

+(int)getScreenSize
{
    CGRect bounds = [TPLHelpTool getScreenRect];
    int size = 1;
    if (bounds.size.height <= 480 || bounds.size.height <= 960) {
        size = 1;
    }else if (bounds.size.height <= 1136){
        size = 2;
    }
    return size;
}

+(CGSize)sizeOfString:(NSString *)string withFont:(UIFont *)font
{
    NSString * systemString = [TPLHelpTool getSystemVersion];
    CGSize size;
    if ([systemString intValue] >= 7) {
        
        size = [string sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
    }else{
        size = [string sizeWithFont:font];
    }
    return size;
}

//获得字符串长度
+(CGFloat)lengthOfString:(NSString *)string withFont:(UIFont *)font
{
    NSString * systemString = [TPLHelpTool getSystemVersion];
    CGSize size;
    if ([systemString intValue] >= 7) {
        size = [string sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
    }else
    {
        size = [string sizeWithFont:font];
    }
    
    return size.width + MORE_WIDTH;
}
//限定宽度，获得字符串高度
+(CGFloat)heightOfString:(NSString*)string withFont:(UIFont*)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSString * systemString = [TPLHelpTool getSystemVersion];
    CGSize size;
    if ([systemString intValue] >= 7)
    {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        size = [string boundingRectWithSize:CGSizeMake(width, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    }
    else
    {
        //        string = [NSString stringWithFormat:@"%@     hahaha",string];
        //        size = [string sizeWithFont:font forWidth:width lineBreakMode:lineBreakMode];
        size = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 9999) lineBreakMode:lineBreakMode];
    }
    
    return size.height;
}

//获得操作系统版本号
+(NSString *)getSystemVersion
{
    return  [[UIDevice currentDevice] systemVersion];
}

#pragma mark
#pragma mark---------------about color
//获得一个随机颜色
+(UIColor*)getRandomColor
{
    return [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f blue:256/255.0f alpha:1];
}


#pragma mark
#pragma mark---------------about String
//修改接收的字符串，返回符合iOS系统的....主要是换行符不同
+(NSString *)htmlToString:(NSString *)str
{
    
    NSString *tempStr;
    //    tempStr = [str stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    
    
    
    if (str == nil)
    {
        return nil;
    }
    else
    {
        //tempStr = [str stringByReplacingOccurrencesOfString:@"&lt;p" withString:@""];
        //tempStr = [tempStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@""];
        //            tempStr = [tempStr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        //            tempStr = [tempStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        //            tempStr = [tempStr stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        
        tempStr = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        tempStr = [tempStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        tempStr = [tempStr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        tempStr = [tempStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        tempStr = [tempStr stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        //        tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<br/>"];
        
        
    }
    return tempStr;
}

@end
