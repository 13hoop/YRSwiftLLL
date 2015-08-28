//
//  PassYZMViewController.h
//  quxiangtou
//
//  Created by wei feng on 15/8/13.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassYZMViewController : UIViewController
{
    ASIFormDataRequest * loginRequest;
}
@property (nonatomic,strong) NSString * data;
@property (nonatomic,strong) NSString * captcha;
@end
