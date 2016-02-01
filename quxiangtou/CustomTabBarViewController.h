//
//  CustomTabBar ViewController.h
//  StarDoctor1
//
//  Created by mac on 15/8/24.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarViewController : UITabBarController{
    NSMutableArray *buttons;
    int currentSelectedIndex;
    UIImageView *slideBg;
    UIButton *saveBtn;
}
@property (nonatomic,assign) int currentSelectedIndex;
@property (nonatomic,retain) NSMutableArray *buttons;

- (void)hideRealTabBar;
- (void)customTabBar;
- (void)selectedTab:(UIButton *)button;
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
@end

