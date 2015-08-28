//
//  LoginModel.m
//  quxiangtou
//
//  Created by wei feng on 15/8/13.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "LoginModel.h"
#import <objc/runtime.h>
@implementation LoginModel
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//- (id)copyWithZone:(NSZone *)zone
//{
//    LoginModel *result = [[[self class] allocWithZone:zone] init];
//    
//    result->_auth_token = [self->_auth_token copy];
//    result->_avatar = [self->_avatar copy];
//    result->_birthday = [self->_birthday copy];
//    result->_gender = self.gender;
//    result->_city = [self->_city copy];
//    result->_meetDictionary = [self->_meetDictionary copy];
//    result->_mobile = [self->_mobile copy];
//    result->_nickname = [self->_nickname copy];
//    result->_province = [self->_province copy];
//    result->_recent_images = [self->_recent_images copy];
//    result->_sexual_duration = self.sexual_duration;
//    result->_purpose = self.purpose;
//    result->_sexual_frequency = self.sexual_frequency;
//    result->_sexual_orientation = self.sexual_orientation;
//    result->_sexual_position = self.sexual_position;
//    result->_uuid = [self->_uuid copy];
//    
//    return result;
//}
//
-(LoginModel *)initDic:(NSDictionary *)dic
{
    if(self=[super init])
    {
        self.auth_token=[dic objectForKey:@"auth_token"];
        self.avatar=[dic objectForKey:@"avatar"];
        self.birthday=[dic objectForKey:@"birthday"];
        self.gender=[dic objectForKey:@"gender"];
        self.city=[dic objectForKey:@"city"];
        self.mobile=[dic objectForKey:@"mobile"];
        self.meetDictionary=[dic objectForKey:@"meetDictionary"];
        self.nickname=[dic objectForKey:@"nickname"];
        self.province=[dic objectForKey:@"province"];
        self.recent_images=[dic objectForKey:@"recent_images"];
        self.sexual_duration=[dic objectForKey:@"sexual_duration"];
        self.purpose=[dic objectForKey:@"purpose"];
        self.sexual_frequency=[dic objectForKey:@"sexual_frequency"];
        self.sexual_orientation=[dic objectForKey:@"sexual_orientation"];
        self.sexual_position=[dic objectForKey:@"sexual_position"];
        self.uuid=[dic objectForKey:@"uuid"];
    }
    return self;
}
//-(NSDictionary *)dictionaryFromModelData
//{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    unsigned int outCount, i;
//    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
//    
//    for (i = 0; i < outCount; i++) {
//        objc_property_t property = properties[i];
//        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
//        //NSString *propertyType = [[NSString alloc] initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
//        
//        id propertyValue = [self valueForKey:propertyName];
//        //该值不为NSNULL，并且也不为nil
//        if ([propertyValue isNotObject]) {
//            [dic setObject:propertyValue forKey:propertyName];
//        }
//    }
//    
//    return dic;
//}
//- (BOOL) isNotObject
//{
//    if (self != nil&&(![self isKindOfClass:[NSNull class]])){
//        return YES;
//    }else
//        return NO;
//}
@end
