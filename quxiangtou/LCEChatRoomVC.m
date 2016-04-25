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
    ASIFormDataRequest * deleteFavoriteFriendRequest;
    UIBarButtonItem *item2;
}
@end

@implementation LCEChatRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    if ([[self.dic objectForKey:@"is_favorite"] intValue] == 0) {
        item2 = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"已添加最爱@2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(addFavorite:)];
    }else if ([[self.dic objectForKey:@"is_favorite"] intValue] == 1)
    {
         item2 = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"添加最爱@2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStyleDone target:self action:@selector(addFavorite:)];
    }

    self.navigationItem.rightBarButtonItem = item2;
    
}

-(void)addFavorite:(id)sender
{
    if ([[self.dic objectForKey:@"is_favorite"] intValue] == 0) {
        
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
    }else if ([[self.dic objectForKey:@"is_favorite"] intValue] == 1)
    {
        [self deleteFavorite:sender];
    }
    NSString * favorite = nil;
    if ([[self.dic objectForKey:@"is_favorite"] intValue] == 0) {
        favorite = @"1";
        item2.image = [[UIImage imageNamed:@"添加最爱@2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    }else{
        favorite = @"0";
        item2.image = [[UIImage imageNamed:@"已添加最爱@2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    }
    NSLog(@"self.dic = %@",self.dic);
    [self.dic removeObjectForKey:@"is_favorite"];
    NSLog(@"删除后 dic = %@",self.dic);
    [self.dic setObject:favorite forKey:@"is_favorite"];
    NSLog(@"添加后 dic = %@",self.dic);
    
    
    
}
-(void)deleteFavorite:(id)sender
{
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:[self.dic objectForKey:@"uuid"],@"uuid", nil];
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString * urlStr = [NSString stringWithFormat:@"%@favorite/delete?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
        NSLog(@"添加最爱的人  %@",urlStr);
        NSURL * url = [NSURL URLWithString:urlStr];
        deleteFavoriteFriendRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        
        [deleteFavoriteFriendRequest setRequestMethod:@"POST"];
        
        [deleteFavoriteFriendRequest setDelegate:self];
        
        //1、
        [deleteFavoriteFriendRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //2、header
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        NSLog(@"找朋友 Authorization%@",Authorization);
        [deleteFavoriteFriendRequest addRequestHeader:@"Authorization" value:Authorization];
        
        deleteFavoriteFriendRequest.tag = 109;
        
        [deleteFavoriteFriendRequest setPostBody:tempJsonData];
        [deleteFavoriteFriendRequest startAsynchronous];
    }
}
#pragma mark - 更多图片响应请求的请求成功回调
//获取相册
- (void)requestFinished:(ASIHTTPRequest *)request {
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic4=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSLog(@"添加最爱 responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    //我的中心 获取图片列表 statusCode 204
    NSLog(@"添加最爱 statusCode %d",statusCode);
    if (request.tag == 107) {
        if (statusCode == 201) {
            NSDictionary * dic = @{@"favorite":@"1"};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"addFavorite" object:dic];
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"温馨提示";
            HUD.detailsLabelText =@"您已将此人添加为最爱!";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
        }else{
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"温馨提示";
            HUD.detailsLabelText =[[dic4 valueForKey:@"errors"] objectForKey:@"code"];
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
        }
    }
    if (request.tag == 109) {
        if (statusCode == 204) {
            NSDictionary * dic = @{@"favorite":@"0"};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteFavorite" object:dic];
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"温馨提示";
            HUD.detailsLabelText =@"成功取消最爱!";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
            
        }else{
            
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"温馨提示";
            HUD.detailsLabelText =[[dic4 valueForKey:@"errors"] objectForKey:@"code"];
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
            
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
