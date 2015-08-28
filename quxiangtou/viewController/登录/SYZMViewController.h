//
//  SYZMViewController.h
//  quxiangtou
//
//  Created by wei feng on 15/8/10.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYZMViewController : UIViewController
{
    ASIFormDataRequest * yzmRequest;
    ASIFormDataRequest * yzmLoginRequest;
    
}
@property (nonatomic,strong) NSString * phoneString;
@property (nonatomic,strong) NSString * pageName;
@end
