//
//  LCEChatRoomVC.m
//  quxiangtou
//
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "LCEChatRoomVC.h"

@interface LCEChatRoomVC ()

@end

@implementation LCEChatRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *_peopleImage = [UIImage imageNamed:@"chat_menu_people"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:_peopleImage style:UIBarButtonItemStyleDone target:self action:@selector(goChatGroupDetail:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)goChatGroupDetail:(id)sender {
    DLog(@"click");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
