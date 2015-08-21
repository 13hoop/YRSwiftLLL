//
//  AppDelegate.m
//  quxiangtou
//
//  Created by wei feng on 15/7/24.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "HelpViewController.h"
#import "MenuViewController.h"
#import "DDMenuController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    if ([ud objectForKey:@"First"]) {
        [self showRootViewController];
    }else{
        [self showHelpViewController];
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}
-(void)showHelpViewController
{
    HelpViewController * hvc = [[HelpViewController alloc]init];
//    UINavigationController * hnvc = [[UINavigationController alloc]initWithRootViewController:hvc];
//    DDMenuController * dd = [[DDMenuController alloc]initWithRootViewController:hnvc];
        self.window.rootViewController = hvc;
//
//    MenuViewController * mvc = [[MenuViewController alloc]init];
//    dd.leftViewController = mvc;
//    [self.window setRootViewController:dd];

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
