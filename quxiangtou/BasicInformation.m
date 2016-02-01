//
//  BasicInformation.m
//  quxiangtou
//
//  Created by wei feng on 15/8/13.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "BasicInformation.h"

@implementation BasicInformation
static BasicInformation * share = nil;
+(BasicInformation *)shareInformation
{
    if (!share) {
        share = [[BasicInformation alloc]init];
    }
    return share;
}

//获取性别
+(NSString *)getGender:(NSNumber *)num
{
    NSString * gender = [[NSString alloc]init];
    if ([num intValue] == 0) {
        gender = @"未填写";
    }else if ([num intValue] == 1){
        gender = @"男";
    }else if ([num intValue] == 2){
        gender = @"女";
    }
    return gender;
}
+(NSNumber *)getNumberGender:(NSString *)gender
{
    NSNumber * genderNum = [[NSNumber alloc]init];
    if ([gender isEqualToString:@"未填写"]) {
        genderNum = [NSNumber numberWithInt:0];
    }else if ([gender isEqualToString:@"男"]){
        genderNum = [NSNumber numberWithInt:1];
    }else if ([gender isEqualToString:@"女"]){
        genderNum = [NSNumber numberWithInt:2];
    }
    return genderNum;
 
}

//获取性取向
+(NSString *)getSexual_orientation:(NSNumber *)num
{
    NSString * sexual_orientation = [[NSString alloc]init];
    if ([num intValue] == 0) {
        sexual_orientation = @"未填写";
    }else if ([num intValue] == 1){
        sexual_orientation = @"我爱同性";
    }else if ([num intValue] == 2){
        sexual_orientation = @"我爱异性";
    }else if ([num intValue] == 3){
        sexual_orientation = @"我男女都爱";
    }
    return sexual_orientation;

}
+(NSNumber *)getNumberSexual_orientation:(NSString *)exual_orientation
{
    NSNumber * Sexual_orientationNum = [[NSNumber alloc]init];
    if ([exual_orientation isEqualToString:@"未填写"]) {
        Sexual_orientationNum = [NSNumber numberWithInt:0];
    }else if ([exual_orientation isEqualToString:@"我爱同性"]){
        Sexual_orientationNum = [NSNumber numberWithInt:1];
    }else if ([exual_orientation isEqualToString:@"我爱异性"]){
        Sexual_orientationNum = [NSNumber numberWithInt:2];
    }else if ([exual_orientation isEqualToString:@"我男女都爱"]){
        Sexual_orientationNum = [NSNumber numberWithInt:3];
    }

    return Sexual_orientationNum;
}

//获取性爱时长
+(NSString *)getSexual_duration:(NSNumber *)num
{
    NSString * sexual_duration = [[NSString alloc]init];
    if ([num intValue] == 0) {
        sexual_duration = @"未填写";
    }else if ([num intValue] == 5){
        sexual_duration = @"5分钟";
    }else if ([num intValue] == 15){
        sexual_duration = @"15分钟";
    }else if ([num intValue] == 30){
        sexual_duration = @"30分钟";
    }else if ([num intValue] == 45){
        sexual_duration = @"45分钟";
    }else if ([num intValue] == 60){
        sexual_duration = @"60分钟";
    }else if ([num intValue] == 120){
        sexual_duration = @"120分钟";
    }
    return sexual_duration;
}
+(NSNumber *)getNumberSexual_duration:(NSString *)sexual_duration
{
    NSNumber * Sexual_durationNum = [[NSNumber alloc]init];
    if ([sexual_duration isEqualToString:@"未填写"]) {
        Sexual_durationNum = [NSNumber numberWithInt:0];
    }else if ([sexual_duration isEqualToString:@"5分钟"]){
        Sexual_durationNum = [NSNumber numberWithInt:5];
    }else if ([sexual_duration isEqualToString:@"15分钟"]){
        Sexual_durationNum = [NSNumber numberWithInt:15];
    }else if ([sexual_duration isEqualToString:@"30分钟"]){
        Sexual_durationNum = [NSNumber numberWithInt:30];
    }else if ([sexual_duration isEqualToString:@"45分钟"]){
        Sexual_durationNum = [NSNumber numberWithInt:45];
    }else if ([sexual_duration isEqualToString:@"60分钟"]){
        Sexual_durationNum = [NSNumber numberWithInt:60];
    }else if ([sexual_duration isEqualToString:@"120分钟"]){
        Sexual_durationNum = [NSNumber numberWithInt:120];
    }
    
    return Sexual_durationNum;
}

//获取体位
+(NSString *)getSexual_position:(NSNumber *)num
{
    NSString * sexual_position = [[NSString alloc]init];
    if ([num intValue] == 0) {
        sexual_position = @"未填写";
    }else if ([num intValue] == 1){
        sexual_position = @"男上";
    }else if ([num intValue] == 2){
        sexual_position = @"女上";
    }else if ([num intValue] == 3){
        sexual_position = @"后入";
    }else if ([num intValue] == 4){
        sexual_position = @"侧卧";
    }
    return sexual_position;
}
+(NSNumber *)getNumberSexual_position:(NSString *)sexual_position
{
    NSNumber * Sexual_positionNum = [[NSNumber alloc]init];
    if ([sexual_position isEqualToString:@"未填写"]) {
        Sexual_positionNum = [NSNumber numberWithInt:0];
    }else if ([sexual_position isEqualToString:@"男上"]){
        Sexual_positionNum = [NSNumber numberWithInt:1];
    }else if ([sexual_position isEqualToString:@"女上"]){
        Sexual_positionNum = [NSNumber numberWithInt:2];
    }else if ([sexual_position isEqualToString:@"后入"]){
        Sexual_positionNum = [NSNumber numberWithInt:3];
    }else if ([sexual_position isEqualToString:@"侧卧"]){
        Sexual_positionNum = [NSNumber numberWithInt:4];
    }
    
    return Sexual_positionNum;
}

//获取交友目的
+(NSString *)getPurpose:(NSNumber *)num
{
    NSString * purpose = [[NSString alloc]init];
    if ([num intValue] == 0) {
        purpose = @"未填写";
    }else if ([num intValue] == 1){
        purpose = @"我想交新朋友";
    }else if ([num intValue] == 2){
        purpose = @"我要结婚";
    }else if ([num intValue] == 3){
        purpose = @"我要约会";
    }
    return purpose;
}
+(NSNumber *)getNumberPurpose:(NSString *)purpose
{
    NSNumber * purposeNum = [[NSNumber alloc]init];
    
    if ([purpose isEqualToString:@"未填写"]) {
        purposeNum = [NSNumber numberWithInt:0];
    }else if ([purpose isEqualToString:@"我想交新朋友"]){
        purposeNum = [NSNumber numberWithInt:1];
    }else if ([purpose isEqualToString:@"我要结婚"]){
        purposeNum = [NSNumber numberWithInt:2];
    }else if ([purpose isEqualToString:@"我要约会"]){
        purposeNum = [NSNumber numberWithInt:3];
    }
    
    return purposeNum;
}

@end
