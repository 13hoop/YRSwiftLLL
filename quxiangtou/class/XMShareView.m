//
//  XMShareView.m
//  XMShare
//
//  Created by Amon on 15/8/6.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#import "XMShareView.h"
#import "LoginModel.h"
static XMShareView * sharedObj =nil;
@implementation XMShareView
+ (XMShareView*) sharedInstance
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj=[[XMShareView alloc] init];
            
            
        }
        [sharedObj shareInit];
    }
    return sharedObj;
}
-(void)shareInit
{
   
    if( [LIUserDefaults userDefaultObjectWithKey:@"user"])
    {
        LoginModel * mm = [[LoginModel alloc]initDic:[LIUserDefaults userDefaultObjectWithKey:@"user"]];
        self.loginModel=mm;
    }
}


@end
