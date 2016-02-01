//
//  CASegmentedControl.m
//  PalmCar4S
//
//  Created by libingting on 14-9-3.
//  Copyright (c) 2014年 PalmCar. All rights reserved.
//

#import "CASegmentedControl.h"

@implementation CASegmentedControl{
    NSArray * titles;
    NSMutableArray * buttons;
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        buttons = [[NSMutableArray alloc] init];
        self.backgroundColor = color(234, 235, 243);
    }
    return self;
}
+(CASegmentedControl *)titles:(NSArray *)array delegate:(id)my
{
   CASegmentedControl * control = [[self alloc] initWithFrame:CGRectMake(0, 10, Screen_width, 44)];
    control.delegate = my;
    control.backgroundColor = [UIColor whiteColor];
    [control copyTitles:array];
    return control;
}
-(void)copyTitles:(NSArray *)array
{
    titles = [array copy];
    float d = (Screen_width - 40) / (titles.count*1.0);
    for (int i=0;i<titles.count;i++) {
        UIButton * buton = [UIButton buttonWithType:UIButtonTypeCustom];
        buton.tag = 100+i;
        NSLog(@"%d",buton.tag);
        buton.frame =CGRectMake( 20 + d*i, 0, d, 44.0);
        [buton setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        buton.titleLabel.font =[UIFont systemFontOfSize:20.0];
        [buton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (buton.tag == 100) {
            [buton setBackgroundImage:[[UIImage imageNamed:@"已加您为最爱的人选中@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }else{
            [buton setBackgroundImage:[[UIImage imageNamed:@"您的最爱为选中@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
        
        [self addSubview:buton];
        [buttons addObject:buton];
        [buton addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (titles.count >0) {
        [self tap:(UIButton *)[self viewWithTag:100]];
       
    }
}
-(void)tap:(UIButton *)button
{
    if (button.tag == 100) {
        [button setBackgroundImage:[[UIImage imageNamed:@"已加您为最爱的人选中@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        UIButton * bn = (UIButton *)[self viewWithTag:101];
        [bn setBackgroundImage:[[UIImage imageNamed:@"您的最爱为选中@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
    }else{
        [button setBackgroundImage:[[UIImage imageNamed:@"您的最爱选中@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        UIButton * bn = (UIButton *)[self viewWithTag:100];
        [bn setBackgroundImage:[[UIImage imageNamed:@"已加您为最爱的人未选中@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
//    for (int i=0;i<titles.count;i++) {
//       UIButton * bn = (UIButton *)[self viewWithTag:100+i];
////        [bn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [bn setBackgroundImage:[[UIImage imageNamed:@"您的最爱选中@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
//    }
    if (delegate&&[delegate respondsToSelector:@selector(segmentedControl:index:)]) {
        [delegate segmentedControl:self index:button.tag - 100];
    }
}


@end
