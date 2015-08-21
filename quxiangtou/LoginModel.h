//
//  LoginModel.h
//  quxiangtou
//
//  Created by wei feng on 15/8/13.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

@property (nonatomic,strong) NSString * auth_token;
@property (nonatomic,strong) NSString * avatar;
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,strong) NSString * nickname;
@property (nonatomic,strong) NSString * birthday;
@property (nonatomic,strong) NSString * province;
@property (nonatomic,strong) NSString * city;
@property (nonatomic,strong) NSNumber * gender;
@property (nonatomic,strong) NSNumber * sexual_orientation;
@property (nonatomic,strong) NSNumber * sexual_frequency;
@property (nonatomic,strong) NSNumber * sexual_duration;
@property (nonatomic,strong) NSNumber * sexual_position;
@property (nonatomic,strong) NSNumber * purpose;
@property (nonatomic,strong) NSMutableDictionary * meetDictionary;

@end
