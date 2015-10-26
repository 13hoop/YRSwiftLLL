//
//  MenuViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "MenuViewController.h"
#import "SeekFriendViewController.h"
#import "MessageViewController.h"
#import "VisitorViewController.h"
#import "BlackListViewController.h"
#import "LikeMeViewController.h"
#import "FavoriteViewController.h"
#import "MyEquipmentViewController.h"
#import "MyCenterViewController.h"
#import "DDMenuController.h"
#import "ViewController.h"
#import "loginViewController.h"

#import "CDChatManager.h"

@interface MenuViewController ()<ASIHTTPRequestDelegate>
{
    UIImageView * imageView;
}
@property (nonatomic,strong) ASIFormDataRequest * exitRequest;
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
//    self.view.backgroundColor = color_alpha(63/255.0, 77/255.0, 91/255.0, 1);
    UIImageView * imageView1 = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"抽屉背景.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    imageView1.frame = CGRectMake(0, 0, self.view.frame.size.width - 100, self.view.frame.size.height);
    [self.view addSubview:imageView1];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 85, 250, 1)];
    label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    
    [self createButton];
}
-(void)createButton
{
    NSArray * arr1 = @[@"默认头像@2x.png",@"找朋友@2x.png",@"邂逅@2x.png",@"信息@2x.png",@"访客@2x.png",@"黑名单@2x.png",@"抽屉喜欢您1@2x",@"最爱@2x",@"抽屉我的设备@2x"];
    NSArray * arr2 = nil;
    if ([[[ACommenData sharedInstance].logDic objectForKey:@"nickname"] isNotEmpty]) {
        arr2 = @[[[ACommenData sharedInstance].logDic objectForKey:@"nickname"],@"找朋友",@"邂逅",@"信息",@"访客",@"黑名单",@"喜欢您",@"最爱",@"我的设备"];
    }else{
        arr2 = @[@"会员名称",@"找朋友",@"邂逅",@"信息",@"访客",@"黑名单",@"喜欢您",@"最爱",@"我的设备"];
    }
    
    
    for (int i = 0; i < arr1.count;i++) {
        UIButton * button = nil;
        if (i == 0) {
            button = [PRLControl createButtonWithFrame:CGRectMake(0, 30, 200, 40) title:nil traget:self action:@selector(buttonClick:) tag:i];
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 40, 40)];
            NSString * touxiangurl = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"touxiangurl"]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:touxiangurl] placeholderImage:[[UIImage imageNamed:@"组 2@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            imageView.layer.cornerRadius = 20;
            imageView.layer.masksToBounds = YES;
            [button addSubview:imageView];
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 100, 40)];
            [label setText:arr2[i]];
            label.tag = 9 + i;
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont boldSystemFontOfSize:20];
            [button addSubview:label];
            [self.view addSubview:button];

        }else{
            button = [PRLControl createButtonWithFrame:CGRectMake(0,50 + 40 * i, 200, 30) title:nil traget:self action:@selector(buttonClick:) tag:i];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 5, 20, 20)];
            imageView.image = [[UIImage imageNamed:arr1[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [button addSubview:imageView];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 100, 30)];
            [label setText:arr2[i]];
            label.tag = 9 + i;
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont boldSystemFontOfSize:16];
            [button addSubview:label];
            [self.view addSubview:button];

        }
        
        if (button.tag == 0) {
            button.selected = YES;
        }
    }
    UIButton * exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.frame = CGRectMake(50, 400, 50, 40);
    [exitButton setTitle:@"退出" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
}
-(void)exitClick
{
    [self logout];
    NSString * urlStr = [NSString stringWithFormat:@"%@sessions/delete?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
    NSURL * url = [NSURL URLWithString:urlStr];
    _exitRequest = [[ASIFormDataRequest alloc]initWithURL:url];
    [_exitRequest setRequestMethod:@"POST"];
    [_exitRequest setDelegate:self];
    
    //1、header
    [_exitRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    
    //2、header
    NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
    NSLog(@"退出 Authorization%@",Authorization);
    [_exitRequest addRequestHeader:@"Authorization" value:Authorization];
    
    [_exitRequest startAsynchronous];
}
- (void)logout {
    [[CDChatManager manager] closeWithCallback: ^(BOOL succeeded, NSError *error) {
        DLog(@"%@", error);
        //[self deleteAuthDataCache];
        [AVUser logOut];
//        CDAppDelegate *delegate = (CDAppDelegate *)[UIApplication sharedApplication].delegate;
//        [delegate toLogin];
    }];
}
#pragma mark - 退出响应请求的请求成功回调
//退出
- (void)requestFinished:(ASIHTTPRequest *)request {
    //解析接收回来的数据
    
    int statusCode = [request responseStatusCode];
    //我的中心 获取图片列表 statusCode 204
    NSLog(@"退出 statusCode %d",statusCode);
    if (statusCode == 204 ) {
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"udid"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"auth_token"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"touxiangurl"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"mobile"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"password"];
      [[NSUserDefaults standardUserDefaults]synchronize];
        SharedAppDelegate.showLoginViewController;
    }

    
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    //去掉加载框
    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
    [bd removeFromSuperview];
    bd=nil;
    
    //提示警告框失败...
    MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = [request responseString];
    
    HUD.detailsLabelText = @"请检查网络连接";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2.0);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
    
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

            MyCenterViewController * mvc = [[MyCenterViewController alloc]init];
            UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:mvc];
            [dd setRootController:nvc animated:YES];

        
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
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_exitRequest setDelegate:nil];
    [_exitRequest cancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
