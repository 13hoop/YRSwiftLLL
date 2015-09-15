//
//  AboutMeViewController.h
//  quxiangtou
//
//  Created by mac on 15/9/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditAboutMeDelegate <NSObject>

-(void)changePurpose:(NSNumber *)purposeNumber;

@end
@interface AboutMeViewController : UIViewController
@property (nonatomic,strong) NSNumber * purposeNumber;
@property (nonatomic,assign) id<EditAboutMeDelegate>delegate;
@end
