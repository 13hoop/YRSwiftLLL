//
//  myProgressView.h
//  images
//
//  Created by mac on 16/4/6.
//  Copyright (c) 2016年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol cancleRequestDelegate <NSObject>

- (void)cancleRequest;

@end
@interface myProgressView : UIView
{
    UIProgressView *pro1;
    UILabel * numLabel;
    UILabel * totalLabel;
}
@property (nonatomic,retain) NSString * totalNumber;
@property (nonatomic , weak) id<cancleRequestDelegate> delegate;
- (void)show;
@end
