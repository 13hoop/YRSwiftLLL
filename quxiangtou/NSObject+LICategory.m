//
//  NSObject+LICategory.m
//  yymweightloss
//
//  Created by Bingtingli on 14/6/23.
//  Copyright (c) 2014年 yesudoo. All rights reserved.
//

#import "NSObject+LICategory.h"
#import <objc/runtime.h>
//#import "RegexKitLite.h"

@implementation NSObject (LICategory)

- (BOOL) isNotEmpty
{
    if (self != nil&&(![self isKindOfClass:[NSNull class]])&&([self isKindOfClass:[NSString class]]||[self isKindOfClass:[NSMutableString class]])&&(![self isEqual:@""])) {
        return YES;
    }else
        return NO;
}

- (BOOL) isNotObject
{
    if (self != nil&&(![self isKindOfClass:[NSNull class]])){
        return YES;
    }else
        return NO;
}
//-(BOOL)modelDataFromDictionary:(NSDictionary *)dic
//{
//    unsigned int outCount, i;
//    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
//    
//    for (i = 0; i < outCount; i++) {
//        objc_property_t property = properties[i];
//        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
//        NSString *propertyType = [[NSString alloc] initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
//        
//        if ([[dic allKeys] containsObject:propertyName]) {
//            id value = [dic valueForKey:propertyName];
//            if (![value isKindOfClass:[NSNull class]] && value != nil) {
//                if ([value isKindOfClass:[NSDictionary class]]) {
//                    id pro = [self createInstanceByClassName:[self getClassName:propertyType]];
//                    [pro modelDataFromDictionary:value];
//                    [self setValue:pro forKey:propertyName];
//                }else{
//                    [self setValue:value forKey:propertyName];
//                }
//            }
//        }
//    }
//    
//    free(properties);
//    return true;
//}
//
//-(NSString *)getClassName:(NSString *)attributes
//{
//    NSString *type = [attributes substringFromIndex:[attributes rangeOfRegex:@"\""].location + 1];
//    type = [type substringToIndex:[type rangeOfRegex:@"\""].location];
//    return type;
//}

-(id) createInstanceByClassName: (NSString *)className {
    NSBundle *bundle = [NSBundle mainBundle];
    Class aClass = [bundle classNamed:className];
    id anInstance = [[aClass alloc] init];
    return anInstance;
}

-(NSDictionary *)dictionaryFromModelData
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        //NSString *propertyType = [[NSString alloc] initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        id propertyValue = [self valueForKey:propertyName];
        //该值不为NSNULL，并且也不为nil
        if ([propertyValue isNotObject]) {
            [dic setObject:propertyValue forKey:propertyName];
        }
    }
    
    return dic;
}

@end
