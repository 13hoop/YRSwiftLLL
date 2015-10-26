//
//  MessageViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "MessageViewController.h"
#import "LCEChatRoomVC.h"


@interface MessageViewController ()<CDChatListVCDelegate>

@end

@implementation MessageViewController
- (instancetype)init {
    self = [super init];
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
    LCEChatRoomVC *chatRoomVC = [[LCEChatRoomVC alloc] initWithConv:conv];
    chatRoomVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatRoomVC animated:YES];
}

- (void)setBadgeWithTotalUnreadCount:(NSInteger)totalUnreadCount {
    if (totalUnreadCount > 0) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", totalUnreadCount];
    }
    else {
        self.tabBarItem.badgeValue = nil;
    }
}

@end
