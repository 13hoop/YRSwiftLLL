//
//  FMDBManager.h
//  quxiangtou
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "UserItem.h"

@interface FMDBManager : NSObject{
    FMDatabase* _db;
}

+ (FMDBManager*)sharedManager;

//添加用户
- (void)insertUser:(UserItem*)userItem;

//查询用户
- (UserItem*)getAllNicknameAndImageUrl:(NSString * )uuid;

@end
