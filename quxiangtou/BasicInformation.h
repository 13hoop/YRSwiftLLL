//
//  BasicInformation.h
//  quxiangtou
//
//  Created by wei feng on 15/8/13.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicInformation : NSObject

+(BasicInformation *)shareInformation;

//获取性别
+(NSString *)getGender:(NSNumber *)num;
+(NSNumber *)getNumberGender:(NSString *)gender;

//获取性取向
+(NSString *)getSexual_orientation:(NSNumber *)num;
+(NSNumber *)getNumberSexual_orientation:(NSString *)sexual_orientation;

//获取性爱时长
+(NSString *)getSexual_duration:(NSNumber *)num;
+(NSNumber *)getNumberSexual_duration:(NSString *)sexual_duration;
+(NSNumber *)getNumberSexual_durationFromNSInteger:(NSInteger *)row;

//获取体位
+(NSString *)getSexual_position:(NSNumber *)num;
+(NSNumber *)getNumberSexual_position:(NSString *)sexual_position;

//获取交友目的
+(NSString *)getPurpose:(NSNumber *)num;
+(NSNumber *)getNumberPurpose:(NSString *)purpose;






@end
