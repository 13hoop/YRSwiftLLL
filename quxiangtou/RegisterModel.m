//
//  RegisterModel.m
//  quxiangtou
//
//  Created by wei feng on 15/8/13.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "RegisterModel.h"

@implementation RegisterModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

//-(RegisterModel *)initDic:(NSDictionary *)dic
//{
//    if(self=[super init])
//    {
//        self.nickname=[dic objectForKey:@"nickname"];
//        self.birthday=[dic objectForKey:@"birthday"];
//        self.province=[dic objectForKey:@"province"];
//        self.city=[dic objectForKey:@"city"];
//        if([[dic objectForKey:@"gender"] isEqualToNumber:@"1")
//        {
//            self.gender=@"男";
//        }else  if([[dic objectForKey:@"sexual"] isEqualToString:@"female"])
//        {
//            self.sexual=@"女";
//            
//        }else
//        {
//            self.sexual=[dic objectForKey:@"sexual"];
//        }
//        
//        self.truename=[dic objectForKey:@"truename"];
//        self.headurl=[dic objectForKey:@"headurl"];
//        self.address=[dic objectForKey:@"address"];
//        self.mobileno=[dic objectForKey:@"mobileno"];
//        self.car_mode=[dic objectForKey:@"car_mode"];
//        self.email=[dic objectForKey:@"email"];
//        self.role=[[dic objectForKey:@"role"] intValue];
//        self.belongshop=[dic objectForKey:@"belongshop"];
//        self.duty=[dic objectForKey:@"duty"];
//        self.defaultshopid=[dic objectForKey:@"defaultshopid"];
//        self.defaultshopname=[dic objectForKey:@"defaultshopname"];
//        self.registercitycode=[[dic objectForKey:@"registercitycode"] intValue];
//        self.sid=[dic objectForKey:@"sid"];
//    }
//    return self;
//}

@end
