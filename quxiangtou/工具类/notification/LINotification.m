//
//  LINotification.m
//  yymweightloss
//
//  Created by yesudooDevD on 14-6-23.
//  Copyright (c) 2014年 yesudoo. All rights reserved.
//

#import "LINotification.h"

@implementation LINotification
+ (void) postNotificationName:(NSString *)name info:(NSDictionary *)infoDictionary
{
    NSNotificationCenter* ncc = [NSNotificationCenter defaultCenter];
    [ncc postNotificationName:name object:nil userInfo:infoDictionary];
}
+ (void) getObserver:(id)object selector:(SEL)sel name:(NSString *)name
{
    NSNotificationCenter *nccom = [NSNotificationCenter defaultCenter];
    [nccom addObserver:object selector:sel name:name object:nil];
}
+(void) removeObserver:(id)Object
{
    [[NSNotificationCenter defaultCenter] removeObserver:Object];
}
@end
