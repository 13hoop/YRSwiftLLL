//
//  DeviceInfomationShare.h
//  quxiangtou
//
//  Created by wei feng on 15/8/4.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <Foundation/Foundation.h>


#define LI_IS_OS_7_ABOVE [[LIDeviceInformationShare share] isOperatingSystemVersion7Above]

@interface DeviceInfomationShare : NSObject

+ (DeviceInfomationShare *)share;
-(NSString *)UUID;

@end
