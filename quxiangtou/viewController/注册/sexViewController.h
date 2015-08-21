//
//  sexViewController.h
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol setSex <NSObject>

-(void)setSexString:(NSString *)sex;

@end
@interface sexViewController : UIViewController
@property (nonatomic,assign) id <setSex>delegate;
@end
