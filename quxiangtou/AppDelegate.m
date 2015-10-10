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
#import "MenuViewController.h"
#import "DDMenuController.h"
#import <CoreLocation/CoreLocation.h>
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
    
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    
    int statusCode = [request responseStatusCode];
    NSLog(@"登录 statusCode %d",statusCode);
    if (statusCode == 201 ) {
        ACommenData *data=[ACommenData sharedInstance];
        data.logDic=[dic valueForKey:@"data"]; //将登陆返回的数据存到一个字典对象里面...
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
    loginViewController * hvc = [[loginViewController alloc]init];
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
}

@end
