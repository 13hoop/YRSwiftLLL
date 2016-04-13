//
//  myProgressView.m
//  images
//
//  Created by mac on 16/4/6.
//  Copyright (c) 2016年 蒲瑞玲. All rights reserved.
//

#import "myProgressView.h"

@interface myProgressView ()

@property (nonatomic, strong) UIView *bigView;

@end
#define W CGRectGetWidth([UIScreen mainScreen].bounds)
#define H CGRectGetHeight([UIScreen mainScreen].bounds)

@implementation myProgressView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatenum:) name:@"updateNumber" object:nil];
        self.frame = [UIScreen mainScreen].bounds;
        self.bigView = [[UIView alloc]init];
        _bigView.frame = CGRectMake(20,H + 1 * 44 + 10 + 10, W - 40, 1* 44);
        _bigView.center = CGPointMake(W / 2, H / 2);
        _bigView.backgroundColor = [UIColor whiteColor];
        _bigView.layer.masksToBounds = YES;
        _bigView.layer.cornerRadius = 5;
        [self addSubview:_bigView];
        
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        pro1=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        pro1.backgroundColor = [UIColor redColor];
        pro1.frame=CGRectMake(10, 25, _bigView.frame.size.width - 10 - 50 - 15 - 40, 24);
        //设置进度条颜色
        pro1.trackTintColor=[UIColor blueColor];
        //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
        pro1.progress=0.0;
        //设置进度条上进度的颜色
        pro1.progressTintColor=[UIColor redColor];
        [_bigView addSubview:pro1];
        
        numLabel = [[UILabel alloc]initWithFrame:CGRectMake(pro1.frame.size.width + pro1.frame.origin.x + 5,20, 20, 30)];
        numLabel.text = [NSString stringWithFormat:@"%d",0];
        numLabel.center = CGPointMake(pro1.center.x + pro1.frame.size.width/2 + 15, pro1.center.y);
        numLabel.textAlignment = NSTextAlignmentRight;
//        numLabel.backgroundColor = [UIColor redColor];
        [_bigView addSubview:numLabel];
        
        totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(numLabel.frame.size.width + numLabel.frame.origin.x, 20, 20, 30)];
        totalLabel.text = [NSString stringWithFormat:@"/%d",0];
        totalLabel.center = CGPointMake(pro1.center.x + pro1.frame.size.width/2 + 15 + 20, pro1.center.y);
//        totalLabel.backgroundColor = [UIColor redColor];
        [_bigView addSubview:totalLabel];
        
        UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleButton.frame = CGRectMake(totalLabel.frame.size.width + totalLabel.frame.origin.x + 5, 20, 50, 30);
        [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        cancleButton.center = CGPointMake(pro1.center.x + pro1.frame.size.width/2 + 15 + 20 + 30, pro1.center.y);
        [cancleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cancleButton addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
        [_bigView addSubview:cancleButton];
    }
    return self;
}
-(void)updatenum:(NSNotification *)noti
{
    NSString * num = [noti.object objectForKey:@"num"];
    numLabel.text = num;
    totalLabel.text = [NSString stringWithFormat:@"/%@",[noti.object objectForKey:@"totalNumber"]];
    float per = (float)[num intValue]/[[noti.object objectForKey:@"totalNumber"] intValue];
    pro1.progress= per;
    if ([num isEqualToString:[noti.object objectForKey:@"totalNumber"]]) {
        [self dissmiss];
    }
}
-(void)cancleClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancleRequest)]) {
        [self.delegate cancleRequest];
        [self dissmiss];
        
    }
}

- (void)show {
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    
//    [[InformationShare share].Window addSubview:self];
    
    [UIView animateWithDuration:.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
}
- (void)dissmiss {
    [UIView animateWithDuration:.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        _bigView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[NSNotificationCenter
              defaultCenter] removeObserver:self name:@"updateNumber"
             object:nil];
     
    }];
}
@end
