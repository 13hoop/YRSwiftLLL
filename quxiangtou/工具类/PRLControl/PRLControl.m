//
//  PRLControl.m
//  数字报
//
//  Created by wei feng on 15-3-31.
//  Copyright (c) 2015年 puruiling. All rights reserved.
//

#import "PRLControl.h"

@implementation PRLControl

+(UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title traget:(id)target action:(SEL)action tag:(NSInteger)tag
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    button.frame = frame;
    return button;
}

@end
