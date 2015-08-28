//
//  PRLControl.h
//  数字报
//
//  Created by wei feng on 15-3-31.
//  Copyright (c) 2015年 puruiling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRLControl : NSObject

//创建一个系统按钮的加方法
+(UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title traget:(id)target action:(SEL)action tag:(NSInteger)tag;

@end
