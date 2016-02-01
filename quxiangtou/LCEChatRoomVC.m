//
//  LCEChatRoomVC.m
//  quxiangtou
//
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "LCEChatRoomVC.h"

@interface LCEChatRoomVC ()<ASIHTTPRequestDelegate>
{
    ASIFormDataRequest * addFavoriteFriendRequest;
    UIBarButtonItem *item2;
}
@end

@implementation LCEChatRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([[self.dic objectForKey:@"is_favorite"] intValue] == 0) {
        item2 = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"添加最爱@2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(addFavorite:)];
    }else if ([[self.dic objectForKey:@"is_favorite"] intValue] == 1)
    {
         item2 = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"已添加最爱@2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStyleDone target:self action:nil];
    }

    self.navigationItem.rightBarButtonItem = item2;
}
-(void)addFavorite:(id)sender
{
//    AVIMConversation * imcon = noti.object;
//    NSLog(@"imConversation otherid = %@",imcon.otherId);
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:[self.dic objectForKey:@"uuid"],@"uuid", nil];
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString * urlStr = [NSString stringWithFormat:@"%@favorite?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
        NSLog(@"添加最爱的人  %@",urlStr);
        NSURL * url = [NSURL URLWithString:urlStr];
        addFavoriteFriendRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        
        [addFavoriteFriendRequest setRequestMethod:@"POST"];
        
        [addFavoriteFriendRequest setDelegate:self];
        
        //1、
        [addFavoriteFriendRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //2、header
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        NSLog(@"找朋友 Authorization%@",Authorization);
        [addFavoriteFriendRequest addRequestHeader:@"Authorization" value:Authorization];
        
        addFavoriteFriendRequest.tag = 107;
        
        [addFavoriteFriendRequest setPostBody:tempJsonData];
        [addFavoriteFriendRequest startAsynchronous];
    }
    
    
}
#pragma mark - 更多图片响应请求的请求成功回调
//获取相册
- (void)requestFinished:(ASIHTTPRequest *)request {
    //http://api.quxiangtou.com/v1/users/meet
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic4=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
//    NSDictionary * dic3 = [dic4 objectForKey:@"data"];
    NSLog(@"添加最爱 responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    //我的中心 获取图片列表 statusCode 204
    NSLog(@"添加最爱 statusCode %d",statusCode);
    if (request.tag == 107) {
        if (statusCode == 201) {
            item2.image = [[UIImage imageNamed:@"已添加最爱@2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
            item2.enabled = NO;
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

- (void)goChatGroupDetail:(id)sender {
    DLog(@"click");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
