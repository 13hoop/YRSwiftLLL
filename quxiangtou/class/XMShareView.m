//
//  XMShareView.m
//  XMShare
//
//  Created by Amon on 15/8/6.
//  Copyright (c) 2015年 GodPlace. All rights reserved.
//

#import "XMShareView.h"
#import "YZMLoginViewController.h"
@implementation XMShareView


//- (id)initWithFrame:(CGRect)frame
//{
//    
//    self = [super initWithFrame:frame];
//    if (self) {
//        
////               [self initUI];
//        
//    }
//    return self;
//    
//}

-(void)login:(UIButton *)button
{
    if (button.tag == 1) {
        NSLog(@"22222222");
        YZMLoginViewController * yzmLogin = [[YZMLoginViewController alloc]init];
    
        [[NSNotificationCenter defaultCenter]postNotificationName:@"yanzhengmaLogin" object:self];        
    }else{
        
    }
}

@end
