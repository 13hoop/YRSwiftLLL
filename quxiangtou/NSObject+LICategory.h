//
//  NSObject+LICategory.h
//  yymweightloss
//
//  Created by Bingtingli on 14/6/23.
//  Copyright (c) 2014年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LICategory)

/**
 字符串不为空
 */
- (BOOL) isNotEmpty;

/**
 对象不为空
 */
- (BOOL) isNotObject;

/**
 生成JsonModel
 */
- (BOOL) modelDataFromDictionary:(NSDictionary *)dic;
/**
 生成字典
 */
-(NSDictionary *)dictionaryFromModelData;
/**
 延时执行方法
 */
@end
