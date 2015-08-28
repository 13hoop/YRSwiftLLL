//
//  meetModel.m
//  quxiangtou
//
//  Created by mac on 15/8/26.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "meetModel.h"

@implementation meetModel
-(meetModel *)initDic:(NSDictionary *)dic
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
@end
