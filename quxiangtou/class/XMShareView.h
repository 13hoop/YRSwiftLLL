//
//  XMShareView.h
//  XMShare
//
//  Created by Amon on 15/8/6.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RegisterModel;
@class LoginModel;


@interface XMShareView : NSObject
+ (XMShareView*) sharedInstance;
@property (nonatomic,strong) RegisterModel * registModel;
@property (nonatomic,strong) LoginModel * loginModel;
@property (nonatomic,strong) NSMutableArray * loginMeetArray;

@end

