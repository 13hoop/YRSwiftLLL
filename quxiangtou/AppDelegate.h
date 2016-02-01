//
//  AppDelegate.h
//  趣相投
//
//  Created by wei feng on 15/7/24.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;  //负责应用和数据库之间的交互（CRUD）
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;   //代表Core Data的模型文件
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;  //添加持久化存储库（比如SQLite数据库）



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)showHelpViewController;
-(void)showRootViewController;
-(void)showLoginViewController;

@end

