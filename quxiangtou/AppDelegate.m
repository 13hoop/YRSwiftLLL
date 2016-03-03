//
//  AppDelegate.m
//  quxiangtou
//
//  Created by wei feng on 15/7/24.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "loginViewController.h"
#import "FRegistViewController.h"
#import "MenuViewController.h"
#import "DDMenuController.h"
#import <CoreLocation/CoreLocation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "CDUserFactory.h"

@interface AppDelegate ()<CLLocationManagerDelegate>
{
    ASIFormDataRequest * loginRequest;
}
@property (nonatomic, strong) CLLocationManager * locMgr;
@property (nonatomic, strong) CLGeocoder * geocoder;  //iOS 5.0 及5.0以上SDK版本使用
@property (nonatomic, strong) CLLocation * meCoordinate;
@end

@implementation AppDelegate

-(CLLocationManager *)locMgr
{
    if (_locMgr == nil) {
        //1、创建位置管理器（定位用户的位置）
        self.locMgr = [[CLLocationManager alloc]init];
        //2、设置代理
        self.locMgr.delegate = self;
    }
    return _locMgr;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Launched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Launched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    
    //如果使用美国站点，请加上这行代码 [AVOSCloud useAVCloudUS];
    [AVOSCloud setApplicationId:@"dm3umf7CG2umcAwzepQ5HXwB"
                      clientKey:@"k9bVOrFqAw3VSn7iVhCwPKDd"];
//    AVIMMessageMediaType
    // 注册暂态消息
//    IMOperationMessage.registerSubclass()
//    [CDChatManager manager].userDelegate = [[CDUserFactory alloc] init];
    
#ifdef DEBUG
    [AVAnalytics setAnalyticsEnabled:NO];
    [AVOSCloud setAllLogsEnabled:YES];
#endif

    
    self.window.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self locationMe];
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
//    if ([ud objectForKey:@"First"]) {
//        [self showRootViewController];
//    }else{
//        [self showLoginViewController];
//    }
    if ([[ud objectForKey:@"mobile"] isNotEmpty] && [[ud objectForKey:@"password"] isNotEmpty]) {
        [self loginClick];
    }else{
        [self showLoginViewController];
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}
-(void)loginClick
{
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"],@"mobile",[[NSUserDefaults standardUserDefaults] objectForKey:@"password"],@"password", nil];
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString * urlStr = [NSString stringWithFormat:@"%@sessions?udid=%@",URL_HOST,[[DeviceInfomationShare share] UUID]];
        NSLog(@"登录  %@",[[DeviceInfomationShare share] UUID]);
        NSURL * url = [NSURL URLWithString:urlStr];
        loginRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [loginRequest setRequestMethod:@"POST"];
        [loginRequest setDelegate:self];
        [loginRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        [loginRequest setPostBody:tempJsonData];
        [loginRequest startAsynchronous];
    }
    
    
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [loginRequest cancel];
    loginRequest.delegate = nil;
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    
    int statusCode = [request responseStatusCode];
    NSLog(@"登录 statusCode %d",statusCode);
    if (statusCode == 201 ) {
        ACommenData *data=[ACommenData sharedInstance];
        data.logDic=[dic valueForKey:@"data"]; //将登陆返回的数据存到一个字典对象里面...
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"xiehouUpdate" object:[[ACommenData sharedInstance].logDic objectForKey:@"meet"]];
//         [_xiehouArray addObject:[[ACommenData sharedInstance].logDic objectForKey:@"meet"]];
        NSLog(@"登录 data %@",[dic valueForKey:@"data"]);
        [[NSUserDefaults standardUserDefaults]setObject:[[DeviceInfomationShare share] UUID] forKey:@"udid"];
        [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"] objectForKey:@"auth_token"] forKey:@"auth_token"];
        if ([[[dic objectForKey:@"data"] objectForKey:@"avatar"] isNotEmpty ]) {
            [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"] objectForKey:@"avatar"] forKey:@"touxiangurl"];
            
        }else{
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"touxiangurl"];
        }
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateAvatar" object:dic];
        [self showRootViewController];
         [loginRequest cancel];
    }else{
        [self showLoginViewController];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [loginRequest cancel];
    loginRequest.delegate = nil;
    [self showLoginViewController];
}
-(void)locationMe
{
    _geocoder = [[CLGeocoder alloc]init];
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"开始执行定位服务");
        self.locMgr.distanceFilter = kCLDistanceFilterNone;
        self.locMgr.desiredAccuracy = kCLLocationAccuracyBest;
        //开始定位用户的位置
        //取得定位权限，有两个方法，取决于你的定位使用情况
        //一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
        [self.locMgr requestWhenInUseAuthorization];
        [self.locMgr requestAlwaysAuthorization];
        [self.locMgr startUpdatingLocation];
    }else{
        NSLog(@"无法使用定位服务");
    }
}

#pragma mark - 定位的回调方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _meCoordinate = [locations objectAtIndex:0];
    [_geocoder reverseGeocodeLocation:_meCoordinate completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark * placeMark = [placemarks objectAtIndex:0];
            NSString * city = placeMark.locality;
            if (!city) {
                city = placeMark.administrativeArea;
            }
            NSString * addressString = [NSString stringWithFormat:@"%@%@",placeMark.administrativeArea,city];
            NSNumber * lon = [NSNumber numberWithDouble:_meCoordinate.coordinate.longitude];
            NSNumber * lat = [NSNumber numberWithDouble:_meCoordinate.coordinate.latitude];
//            double longitude = 116.35308;
//            double latitude = 40.07341;
//            NSNumber * lon = [NSNumber numberWithDouble:longitude];
//            NSNumber * lat = [NSNumber numberWithDouble:latitude];
            [[NSUserDefaults  standardUserDefaults] setObject:addressString forKey:@"MyAddress"];
            [[NSUserDefaults standardUserDefaults] setObject:lon forKey:@"longitude"];
            [[NSUserDefaults standardUserDefaults] setObject:lat forKey:@"latitude"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else if (error ==nil && placemarks.count == 0){
            NSLog(@"没有返回结果");
        }else if (error != nil){
            NSLog(@"有错误产生 = %@",error);
        }
    }];
    [self.locMgr stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败");
}

-(void)showLoginViewController
{
    FRegistViewController * hvc = [[FRegistViewController alloc]init];
    self.window.rootViewController = hvc;

    
}
-(void)showRootViewController
{
    ViewController * vc = [[ViewController alloc]init];
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    DDMenuController * dd = [[DDMenuController alloc]initWithRootViewController:nvc];
    
    MenuViewController * mvc = [[MenuViewController alloc]init];
    dd.leftViewController = mvc;
    
    [self.window setRootViewController:dd];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.gogomall.AirCup_Demo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AirCup_Demo" withExtension:@"momd"];
    //从应用程序包中加载模型文件
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    //传入模型对象，初始化NSPersistentStoreCoordinator
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    //构建SQLite数据库文件的路径
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AirCup_Demo.sqlite"];
    //添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    //初始化上下文，设置persistentStoreCoordinator属性
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
