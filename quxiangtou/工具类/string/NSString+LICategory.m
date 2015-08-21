//
//  NSString+LICategory.m
//  LIClass
//
//  Created by yesudooDevD on 14-6-11.
//  Copyright (c) 2014年 yesudoo. All rights reserved.
//

#import "NSString+LICategory.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LICategory)
#pragma mark -字符与常量装换
- (NSString *) stringWithFloatValue:(float)floatValue omitDecimalPlacesFromIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            return [NSString stringWithFormat:@"%.0f",floatValue];
        }
            break;
        case 1:
        {
             return [NSString stringWithFormat:@"%.1f",floatValue];
        }
            break;
        case 2:
        {
             return [NSString stringWithFormat:@"%.2f",floatValue];
        }
            break;
        case 3:
        {
             return [NSString stringWithFormat:@"%.3f",floatValue];
        }
            break;
        case 4:
        {
             return [NSString stringWithFormat:@"%.4f",floatValue];
        }
            break;
        case 5:
        {
             return [NSString stringWithFormat:@"%.5f",floatValue];
        }
            break;
        case 6:
        {
             return [NSString stringWithFormat:@"%.6f",floatValue];
        }
            break;
        case 7:
        {
             return [NSString stringWithFormat:@"%.7f",floatValue];
        }
            break;
        case 8:
        {
             return [NSString stringWithFormat:@"%.8f",floatValue];
        }
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark -判断合法函数
- (BOOL) isNotEmpty
{
    if ([self isEqual:@""]) {
        return NO;
    }else
        return YES;
}

- (BOOL) isLocated:(NSString *)string
{
    if (string&&([string isKindOfClass:[NSString class]]||[string isKindOfClass:[NSMutableString class]])) {
        if ([string rangeOfString:self].length > 0) {
            return YES;
        }else
            return NO;
    }else
        return NO;
}

#pragma mark -解析与数据处理
- (id) ObjectWithJsonParsing
{
    NSData * dataValue;
    if ([self hasPrefix:@"l"]) {
        dataValue=[[self dataUsingEncoding:NSUTF8StringEncoding] subdataWithRange:NSMakeRange(1,self.length-1)];
    } if([self hasPrefix:@"\r\n"]){
        NSInteger i = [@"\r\n" length];
        dataValue=[[self dataUsingEncoding:NSUTF8StringEncoding] subdataWithRange:NSMakeRange(i,self.length-i)];
    } if([self hasPrefix:@"\n"]){
        NSInteger i=[@"\n" length];
        dataValue=[[self dataUsingEncoding:NSUTF8StringEncoding] subdataWithRange:NSMakeRange(i,self.length-i)];
    }else
        dataValue=[self dataUsingEncoding:NSUTF8StringEncoding];
    return  [NSJSONSerialization JSONObjectWithData:dataValue options:NSJSONReadingAllowFragments error:nil];
}
+ (NSString*) stringWithJsonObject:(id)object
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
#pragma mark -信息类处理
- (NSString *) stringWithClassNameFromOject:(id)object
{
    if ([object isKindOfClass:[NSNull class]]) {
        return @"NSNull";
    }else if(object == nil){
        return @"nil";
    }else {
        return NSStringFromClass([object class]);
    }
    
}


@end

#pragma mark -字符串转换
NSString * string_urlEncoding(NSString * sourceString){
    NSString * encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)sourceString,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}
NSString * string_UTF8Encoding(NSString * sourceString){
    return [sourceString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
NSString * string_chineseUTF8Encoding(NSString * UTF8String){
    NSString *tempStr1 = [UTF8String stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}
NSString * string_ISOLatin1Encoding(NSString * sourceString){
    NSData *latin1Data = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
    return [[NSString alloc] initWithData:latin1Data encoding:NSISOLatin1StringEncoding];
}

/**
 加密成16位的md5
 */
NSString * string_MD5(NSString *sourceString){
    const char *cStr = [sourceString UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}
NSData * data_base64String(NSString * sourceString)
{
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        return [[NSData alloc] initWithBase64EncodedString:sourceString options:0];
    }else
        return nil;
}
/**
 使用Int输出
 */
int Int(id object){
    return [object integerValue];
}
/**
 使用Int输出
 */
float Float(id object){
    return [object floatValue];
}
/**
 使用NSTimeInterval输出
 */
NSTimeInterval TimeInterval(id object){
    return (NSTimeInterval)[object doubleValue];
}
/**
 使用double输出
 */
double Double(id object){
    return [object doubleValue];
}

NSNumber * number_int(int value){
    return [NSNumber numberWithInt:value];
}

NSNumber * number_float(float value){
    return [NSNumber numberWithFloat:value];
}

NSNumber * number_timeInterval(NSTimeInterval value){
    return [NSNumber numberWithDouble:value];
}

NSNumber * number_double(double value)
{
    return [NSNumber numberWithDouble:value];
}

NSString * string_int(int value){
    return [number_int(value) stringValue];
}

NSString * string_float(float value){
    return [number_float(value) stringValue];
}

NSString * string_timeInterval(NSTimeInterval value){
    return [number_timeInterval(value) stringValue];
}

NSString * string_double(double value){
    return [number_double(value) stringValue];
}