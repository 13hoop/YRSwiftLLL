//
//  MallViewController.m
//  quxiangtou
//
//  Created by mac on 15/12/7.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "MallViewController.h"

@interface MallViewController ()

@end

@implementation MallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"顶操04@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
    self.navigationItem.title = @"商城";
    
    
}
-(void)showLeft
{
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
    [dd showLeftController:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}
@end
