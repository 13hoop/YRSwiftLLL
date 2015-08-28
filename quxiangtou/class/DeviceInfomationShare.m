//
//  DeviceInfomationShare.m
//  quxiangtou
//
//  Created by wei feng on 15/8/4.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "DeviceInfomationShare.h"

static DeviceInfomationShare * appShare;
@implementation DeviceInfomationShare

+ (DeviceInfomationShare *)share
{
    if (appShare==nil) {
        appShare = [[DeviceInfomationShare alloc] init];
    }
    return appShare;
}
-(NSString *)UUID
{
    NSUUID * uid = [[UIDevice currentDevice] identifierForVendor];
    //NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];
    NSString * uuid = [uid UUIDString];
    return uuid;
}

@end
