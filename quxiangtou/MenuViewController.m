//
//  MenuViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "MenuViewController.h"
#import "SeekFriendViewController.h"
#import "MeetViewController.h"
#import "MessageViewController.h"
#import "VisitorViewController.h"
#import "BlackListViewController.h"
#import "LikeMeViewController.h"
#import "FavoriteViewController.h"
#import "MyEquipmentViewController.h"
#import "MyCenterViewController.h"
#import "DDMenuController.h"
#import "ViewController.h"

@interface MenuViewController ()
{
    UIImageView * imageView;
}
@end

@implementation MenuViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateAvatar:) name:@"updateAvatar" object:nil];
       
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"u4.png"]];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width - 100, self.view.frame.size.height);
    [self.view addSubview:imageView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 85, 250, 1)];
    label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    
    [self createButton];
}
-(void)createButton
{
    NSArray * arr1 = @[@"默认头像@2x.png",@"找朋友@2x.png",@"邂逅@2x.png",@"信息@2x.png",@"访客@2x.png",@"黑名单@2x.png",@"抽屉喜欢您1@2x",@"最爱@2x",@"抽屉我的设备@2x"];
    NSArray * arr2 = @[@"会员名称",@"找朋友",@"邂逅",@"信息",@"访客",@"黑名单",@"喜欢您",@"最爱",@"我的设备"];
    
    for (int i = 0; i < arr1.count;i++) {
        UIButton * button = nil;
        if (i == 0) {
            button = [PRLControl createButtonWithFrame:CGRectMake(0, 30, 200, 40) title:nil traget:self action:@selector(buttonClick:) tag:i];
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 40, 40)];
            NSString * touxiangurl = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"touxiangurl"]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:touxiangurl] placeholderImage:[UIImage imageNamed:@"组 2@2x"]];
            imageView.layer.cornerRadius = 20;
            imageView.layer.masksToBounds = YES;
            [button addSubview:imageView];

        }else{
            button = [PRLControl createButtonWithFrame:CGRectMake(0,50 + 40 * i, 200, 30) title:nil traget:self action:@selector(buttonClick:) tag:i];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 5, 20, 20)];
            imageView.image = [UIImage imageNamed:arr1[i]];
            [button addSubview:imageView];

        }
        
        if (button.tag == 0) {
            button.selected = YES;
        }
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 100, 30)];
        [label setText:arr2[i]];
        label.tag = 9 + i;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:16];
        [button addSubview:label];
        [self.view addSubview:button];
    }
    
}
-(void)buttonClick:(UIButton *)button
{
    for (UIView * view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * button1 = (UIButton *)view;
            if (button1.tag == button.tag) {
                button1.selected = YES;
            }else{
                button1.selected = NO;
            }
        }
    }
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if (button.tag == 1) {
        SeekFriendViewController * svc = [[SeekFriendViewController alloc]init];
        //rvc.page = 1;
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:svc];
        [dd setRootController:nvc animated:YES];
    }else if(button.tag == 2){
        ViewController * vc = [[ViewController alloc]init];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
        [dd setRootController:nvc animated:YES];
    }else if(button.tag == 3){
        MessageViewController * mvc = [[MessageViewController alloc]init];
        //rvc.page = 3;
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:mvc];
        [dd setRootController:nvc animated:YES];

    }else if (button.tag == 4){
        VisitorViewController * vvc = [[VisitorViewController alloc]init];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vvc];
        [dd setRootController:nvc animated:YES];
    }else if(button.tag == 0){
//        BOOL islog = [[NSUserDefaults standardUserDefaults]boolForKey:@"isLog"];
//        if (islog) {
//            ShowLoginViewController * slvc = [[ShowLoginViewController alloc]init];
//            UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:slvc];
//            [dd setRootController:nvc animated:YES];
//            
//        }else{
            MyCenterViewController * mvc = [[MyCenterViewController alloc]init];
            UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:mvc];
            [dd setRootController:nvc animated:YES];
//        }
        
        
    }else if(button.tag == 5){
        BlackListViewController * bvc = [[BlackListViewController alloc]init];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:bvc];
        [dd setRootController:nvc animated:YES];
    }else if(button.tag == 6){
        LikeMeViewController * lvc = [[LikeMeViewController alloc]init];
        //rvc.page = 3;
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:lvc];
        [dd setRootController:nvc animated:YES];
        
    }else if (button.tag == 7){
        FavoriteViewController * fvc = [[FavoriteViewController alloc]init];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:fvc];
        [dd setRootController:nvc animated:YES];
    }else if (button.tag == 8){
        MyEquipmentViewController * mevc = [[MyEquipmentViewController alloc]init];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:mevc];
        [dd setRootController:nvc animated:YES];
    }
    
}
-(void)updateAvatar:(NSNotification *)note{
    
    NSString * touxiangurl = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"touxiangurl"]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:touxiangurl] placeholderImage:[UIImage imageNamed:@"组 2@2x"]];
   
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"updateAvatar" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
