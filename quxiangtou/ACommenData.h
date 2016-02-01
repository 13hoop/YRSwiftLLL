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

@property(nonatomic,strong)NSMutableArray * historyArray;

+(ACommenData *)sharedInstance;
+ (BOOL)validatePhone:(NSString *)phone;
+ (BOOL)validate2Phone:(NSString *)phone;
- (void)alert:(NSString *)msg;
- (BOOL)filterError:(NSError *)error;
- (void)openChat:(NSString *)uuid;
@end
