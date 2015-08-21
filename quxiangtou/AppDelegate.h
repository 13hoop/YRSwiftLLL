//
//  AppDelegate.h
//  趣相投
//
//  Created by wei feng on 15/7/24.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SharedAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)showHelpViewController;
-(void)showRootViewController;


@end

