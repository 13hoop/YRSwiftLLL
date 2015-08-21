//
//  sexDViewController.h
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol setSexDe <NSObject>

-(void)setSexDeString:(NSString *)sex;

@end
@interface sexDViewController : UIViewController
@property (nonatomic,assign) id<setSexDe> delegate;

@end
