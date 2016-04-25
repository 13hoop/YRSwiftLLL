//
//  MessageViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "MessageViewController.h"
#import "LCEChatRoomVC.h"
#import "ASIFormDataRequest.h"

@interface MessageViewController ()<CDChatListVCDelegate,ASIHTTPRequestDelegate>
{
    ASIFormDataRequest * getUserMessageRequest;
    
    AVIMConversation * conv11;
}
@end

@implementation MessageViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"消息";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_chat_active"];
        self.chatListDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setImage:[[UIImage imageNamed:@"顶操01@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 50, 39);
    [backButton addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,btn_right, nil];
    self.navigationItem.title = @"信息";
//    self.navigationController.navigationBarHidden = YES;
//    [self createNav];
    
}
#pragma  mark - 自定义状态栏
-(void)createNav
{
    UIView * navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64)];
    navigationView.userInteractionEnabled = YES;
    navigationView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    [self.view addSubview:navigationView];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setImage:[[UIImage imageNamed:@"顶操01@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(5, 25, 50, 39);
    backButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [backButton setTitleColor:color_alpha(47.0, 120.0, 200.0,1) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width / 2 -60, 30, 120, 30)];
    titleLabel.text = @"信息";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [navigationView addSubview:titleLabel];
    
    UIView * view = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, Screen_width, 1)];
    view.backgroundColor = color_alpha(222, 222, 222, 1);
    [navigationView addSubview:view];
    
}
-(void)showLeft
{
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
    [dd showLeftController:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewController:(UIViewController *)viewController didSelectConv:(AVIMConversation *)conv {
    conv11 = conv;
    [self requestUserMessage:conv];
}
#pragma mark - 获取用户信息
-(void)requestUserMessage:(AVIMConversation *)conv
{
    NSString * urlStr = [NSString stringWithFormat:@"%@users/%@?udid=%@",URL_HOST,conv.otherId,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
    NSLog(@"个人中心 获取用户信息 = %@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    getUserMessageRequest = [[ASIFormDataRequest alloc]initWithURL:url];
    [getUserMessageRequest setRequestMethod:@"GET"];
    
    //1、header
    [getUserMessageRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    
    //2、header
    NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
    NSLog(@"Authorization%@",Authorization);
    [getUserMessageRequest addRequestHeader:@"Authorization" value:Authorization];
    
    [getUserMessageRequest setDelegate:self];
    getUserMessageRequest.tag = 106;
    [getUserMessageRequest startAsynchronous];
    
}
#pragma mark - 更多图片响应请求的请求成功回调
//获取相册
- (void)requestFinished:(ASIHTTPRequest *)request {
    //http://api.quxiangtou.com/v1/users/meet
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic4=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSDictionary * dic3 = [dic4 objectForKey:@"data"];
    NSLog(@"添加最爱 responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    //我的中心 获取图片列表 statusCode 204
    NSLog(@"添加最爱 statusCode %d",statusCode);
        //获取用户信息
    if (request.tag == 106) {
        if (statusCode == 200 ) {
            NSMutableDictionary * dic5 = [NSMutableDictionary dictionaryWithDictionary:@{@"nickname":[dic3 objectForKey:@"nickname"],@"avatar":[dic3 objectForKey:@"avatar"],@"uuid":[dic3 objectForKey:@"uuid"],@"is_favorite":[dic3 objectForKey:@"is_favorite"]}];
            LCEChatRoomVC *chatRoomVC = [[LCEChatRoomVC alloc] initWithConv:conv11];
            chatRoomVC.hidesBottomBarWhenPushed = YES;
            chatRoomVC.dic = dic5;
            [self.navigationController pushViewController:chatRoomVC animated:YES];
        }else{
           
        }
        
    }
    if (request.tag == 107) {
        if (statusCode == 201) {
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"您已将此人添加为最爱!"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
        }else{
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:[[dic4 valueForKey:@"errors"] objectForKey:@"code"]
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
        }
    }
    
    
}

- (void)setBadgeWithTotalUnreadCount:(NSInteger)totalUnreadCount {
    if (totalUnreadCount > 0) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", totalUnreadCount];
    }
    else {
        self.tabBarItem.badgeValue = nil;
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [getUserMessageRequest cancel];
//    [addFavoriteFriendRequest cancel];
    [getUserMessageRequest setDelegate:nil];
//    [addFavoriteFriendRequest setDelegate:nil];
}
@end
