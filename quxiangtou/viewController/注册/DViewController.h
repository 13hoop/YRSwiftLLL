//
//  DViewController.h
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol setDe <NSObject>

-(void)setDeString:(NSString *)sex;

@end
@interface DViewController : UIViewController
@property (nonatomic,assign)id<setDe> delegate;

@end
