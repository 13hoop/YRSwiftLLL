//
//  LIUserDefaults.h
//  yymweightloss
//
//  Created by yesudooDevD on 14-6-17.
//  Copyright (c) 2014年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIUserDefaults : NSUserDefaults

/**
 单一key值的数据本地化
 */
+ (void) userDefaultObject:(id)Object key:(NSString *)key;

/**
 多key值的数据本地化
 */
+ (void) userDefaultObject:(id)Object keys:(NSString *)key,...;

/**
 单key值的数据获取
 \return NSObject  userDefaultObject
 */
+ (id) userDefaultObjectWithKey:(NSString *)key;

/**
 单key值的数据获取
 \return NSString  userDefaultString
 */
+ (NSString *) userDefaultStringWithKey:(NSString *)key;

/**
 多key值的数据获取
 \return NSObject  userDefaultObject
 */
+ (id) userDefaultObjectWithKeys:(NSString *)key,...;

/**
 多key值的数据获取
 \return NSString  userDefaultString
 */
+ (NSString *) userDefaultStringWithKeys:(NSString *)key,...;
/**
 类似数据库的内容处理
*/

@end
