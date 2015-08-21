//
//  LINotification.h
//  yymweightloss
//
//  Created by yesudooDevD on 14-6-23.
//  Copyright (c) 2014年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LINotification : NSNotification
+ (void) postNotificationName:(NSString *)name info:(NSDictionary *)infoDictionary;
+ (void) getObserver:(id)object selector:(SEL)sel name:(NSString *)name;
+(void) removeObserver:(id)Object;
@end
