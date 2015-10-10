//
//  ACommenData.h
//  Matchmaker_LYBT
//
//  Created by mac on 14-2-15.
//  Copyright (c) 2014年 蒲瑞玲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACommenData : NSObject

@property(nonatomic,retain)NSDictionary *logDic;

@property(nonatomic,retain)NSDictionary *regDic;

+(ACommenData *)sharedInstance;
+ (BOOL)validatePhone:(NSString *)phone;
@end
