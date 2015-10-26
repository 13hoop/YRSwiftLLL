//
//  FMDBManager.m
//  quxiangtou
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "FMDBManager.h"

static FMDBManager* manager = nil;
@implementation FMDBManager

- (id)init{
    if (self = [super init]) {
        //路径
        NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/messageUser.sqlite"];
        _db = [[FMDatabase alloc] initWithPath:path];
        //打开
        BOOL res = [_db open];
        if (res == NO) {
            NSLog(@"数据库打开失败");
            return self;
        }
        //创建用户表
        res = [_db executeUpdate:@"create table if not exists USER(uuid,nickname,imageUrl)"];
        if (res == NO) {
            NSLog(@"用户表创建失败");
            return self;
        }
    }
    return self;
}

//添加用户
- (void)insertUser:(UserItem*)userItem{
    //添加到user表
    BOOL res = [_db executeUpdate:@"insert into USER(uuid,nickname,imageUrl) values(?,?,?)",userItem.uuid ,userItem.nickname, userItem.imageUrl];
    if (res == NO) {
        NSLog(@"添加到user表失败");
        return;
    }
}

//查询用户
- (UserItem*)getAllNicknameAndImageUrl:(NSString *)uuid{
    FMResultSet* set = [_db executeQuery:@"select * from USER WHERE uuid = ?",uuid];
    NSMutableArray* array = [NSMutableArray array];
    while ([set next]) {
        UserItem* userItem = [[UserItem alloc] init];
        userItem.nickname = [set stringForColumn:@"nickname"];
        userItem.imageUrl = [set stringForColumn:@"imageUrl"];
        userItem.uuid = [set stringForColumn:@"uuid"];
        [array addObject:userItem];
    }
    return [array firstObject];
}

//单例
+ (FMDBManager *)sharedManager{
    if (manager == nil) {
        manager = [[FMDBManager alloc] init];
    }
    return manager;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    if (manager == nil) {
        manager = [super allocWithZone:zone];
        return manager;
    }
    return nil;
}
@end
