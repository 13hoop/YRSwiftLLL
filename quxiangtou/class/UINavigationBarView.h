//
//  UINavigationBarView.h
//  quxiangtou
//
//  Created by wei feng on 15/8/4.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BtnClick <NSObject>

@optional
-(void)leftBtnClick;
-(void)rightBtnClick;

@end

@interface UINavigationBarView : UIView
{
    NSString * colorStr;
}
@property (nonatomic,strong) UIImageView * navImageView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIButton * rightBtn;
@property (nonatomic,strong) UIButton * leftBtn;
@property (nonatomic,strong) UIButton * backBtn;
@property (nonatomic,weak) id<BtnClick>btnDelegate;

-(void)NavTitle:(NSString *)title andleftBackBtn:(BOOL)isLeftBackBtn andLeft:(NSString *)isLeft andRight:(NSString *)isRight;
-(void)setRightButtonTitle:(NSString *)string;

@end
