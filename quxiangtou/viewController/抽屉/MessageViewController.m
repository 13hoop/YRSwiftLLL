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
   self.navigationController.navigationBarHidden = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"顶操01@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
    self.navigationItem.title = @"信息";

    self.view.backgroundColor = [UIColor whiteColor];
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
            NSDictionary * dic5 = @{@"nickname":[dic3 objectForKey:@"nickname"],@"avatar":[dic3 objectForKey:@"avatar"],@"uuid":[dic3 objectForKey:@"uuid"],@"is_favorite":[dic3 objectForKey:@"is_favorite"]};
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
