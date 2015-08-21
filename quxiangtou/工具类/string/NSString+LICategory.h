//
//  NSString+LICategory.h
//  LIClass
//
//  Created by yesudooDevD on 14-6-11.
//  Copyright (c) 2014年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LICategory)

#pragma mark -判断合法函数
/**
 判断字符串是否不是@“”的值
 \return BOOL 非@“”为Yes
 */
- (BOOL) isNotEmpty;
/**
 是否位于其中
 */
- (BOOL) isLocated:(NSString *)string;

#pragma mark -解析与数据处理
/**
 通用Json解析并且返回字典、数组、nil等值；
 \return id JsonObject
 */
- (id) ObjectWithJsonParsing;
/**
 json对象转string
 */
+ (NSString *) stringWithJsonObject:(id)object;

#pragma mark -信息类处理
/**
 获取一个类的类名；
 \return NSString * ClassName;
 */
- (NSString *) stringWithClassNameFromOject:(id)object;
@end

#pragma mark -(字符串的打印)
/**
 打印字符串
 */
#ifdef DEBUG
# define LILog(format, ...) NSLog((@"\n**********$LIBT$**********\n##路径名:%@(*)\n" "##文件名:%@(*)\n" "##函数名:%s(*)\n" "##行号:%d(*)\n##内容LOG_OUTPUT:" format), [NSString stringWithUTF8String:__FILE__],[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define LILog(...);
#endif

#define Format(format, ...) [NSString stringWithFormat:format,##__VA_ARGS__]

#pragma mark -字符串转换(属性类操作)
/**
 将字符串进行Url编码并且返回;
 \return NSString * UrlEncodedString;
 */
NSString * string_urlEncoding(NSString * sourceString);
/**
 将字符串进行UTF8编码并且返回;
 \return NSString * UrlEncodedString;
 */
NSString * string_UTF8Encoding(NSString * sourceString);
/**
 将UTF8编码字符串转成汉字并且返回;
 \return NSString * ChineseUTF8String;
 */
NSString * string_chineseUTF8Encoding(NSString * UTF8String);
/**
 将字符串进行Latin1编码并且返回;
 \note 这里所说的Latin1编码指的是iso8859-1编码；
 \return NSString * Latin1String;
 */
NSString * string_ISOLatin1Encoding(NSString * sourceString);
/**
 加密成16位的md5
 */
NSString * string_MD5(NSString *sourceString);
/**
 base64转NSdata
 */
NSData * data_base64String(NSString * sourceString);
/**
 使用Int输出
 */
int Int(id object);
/**
 使用Int输出
 */
float Float(id object);
/**
 使用NSTimeInterval输出
 */
NSTimeInterval TimeInterval(id object);
/**
 使用double输出
 */
double Double(id object);

NSNumber * number_int(int value);

NSNumber * number_float(float value);

NSNumber * number_timeInterval(NSTimeInterval value);

NSNumber * number_double(double value);

NSString * string_int(int value);

NSString * string_float(float value);

NSString * string_timeInterval(NSTimeInterval value);

NSString * string_double(double value);
