//
//  TPLHelpTool.h
//  quxiangtou
//
//  Created by wei feng on 15/8/10.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPLHelpTool : NSObject
#pragma mark - 设备
+(NSString *)getDeviceType;

#pragma mark - 屏幕
//获取屏幕分辨率
+(CGRect)getScreenRect;

//获取屏幕尺寸，1为3.5英寸 2为4英寸
+(int)getScreenSize;

#pragma mark －操作系统
//获得操作系统版本
+(NSString *)getSystemVersion;

#pragma mark －估算
//获得字符串占的大小
+(CGSize)sizeOfString:(NSString *)string withFont:(UIFont *)font;

//获得字符串长度
+(CGFloat)lengthOfString:(NSString *)string withFont:(UIFont *)font;

//限定宽度，获得字符串高度
+(CGFloat)heightOfString:(NSString *)string withFont:(UIFont *)font fotWith:(CGFloat)width lineBreakMode:(NSLineBreakMode)linkBreakMode;

#pragma mark - 颜色
//获得一个随机颜色
+(UIColor *)getRandomColor;

#pragma mark - 字符串
//修改接收到的字符串，返回符合iOS系统的。。。。。主要是换行符不同
+(NSString *)htmlToString:(NSString *)str;

@end
