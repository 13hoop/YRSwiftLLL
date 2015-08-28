//
//  meetModel.h
//  quxiangtou
//
//  Created by mac on 15/8/26.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface meetModel : NSObject
@property (nonatomic,strong) NSString * auth_token;  //登录凭证
@property (nonatomic,strong) NSString * avatar;   //   头像
@property (nonatomic,strong) NSString * birthday;   //    生日
@property (nonatomic,strong) NSString * city;     //   市
@property (nonatomic,strong) NSNumber * gender;    //   性别
@property (nonatomic,strong) NSMutableDictionary * meetDictionary;   // 返回的默认邂逅信息
@property (nonatomic,strong) NSString * mobile;    //  手机号
@property (nonatomic,strong) NSString * nickname;   //   昵称
@property (nonatomic,strong) NSString * province;   //    省
@property (nonatomic,strong) NSNumber * purpose;       // 交友目的
@property (nonatomic,strong) NSString * recent_images;  //最近上传的图片
@property (nonatomic,strong) NSNumber * sexual_duration;    //   性爱时长
@property (nonatomic,strong) NSNumber * sexual_frequency;   //  性爱频率
@property (nonatomic,strong) NSNumber * sexual_orientation;   //  性取向
@property (nonatomic,strong) NSNumber * sexual_position;    //  体位
@property (nonatomic,strong) NSString * uuid;
-(meetModel *)initDic:(NSDictionary *)dic;
@end
