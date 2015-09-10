//
//  LikeMeViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "LikeMeViewController.h"

@interface LikeMeViewController ()

@end

@implementation LikeMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;

    self.view.backgroundColor = [UIColor whiteColor];
//    [self createNavigationBar];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"顶操01@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
    self.navigationItem.title = @"喜欢您";
}
-(void)createNavigationBar
{
    UIView * navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64)];
    navigationView.userInteractionEnabled = YES;
    navigationView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    [self.view addSubview:navigationView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 25, 35, 35);
    [button setBackgroundImage:[UIImage imageNamed:@"顶操01@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:button];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width / 2 -40, 30, 80, 30)];
    titleLabel.text = @"喜欢您";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navigationView addSubview:titleLabel];
    
}
-(void)showLeft
{
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
    [dd showLeftController:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
