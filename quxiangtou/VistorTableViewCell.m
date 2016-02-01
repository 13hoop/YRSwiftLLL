//
//  VistorTableViewCell.m
//  quxiangtou
//
//  Created by wei feng on 15/8/15.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "VistorTableViewCell.h"

@implementation VistorTableViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"VistorTableViewCell" owner:self options:nil] lastObject];
        _touxiangImage.userInteractionEnabled = YES;
        _touxiangImage.layer.cornerRadius = 45;
        _touxiangImage.layer.masksToBounds = YES;
        UILongPressGestureRecognizer * gester = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [_touxiangImage addGestureRecognizer:gester];
    }
    return self;
}
-(void)longPress:(UIGestureRecognizer *)gester
{
    if (gester.state == UIGestureRecognizerStateBegan) {
        
        if (self.deleteDelegate && [self.deleteDelegate respondsToSelector:@selector(deleteFavoriteFriend:)]) {
            [self.deleteDelegate deleteFavoriteFriend:self];
        }
        
    }
   
   
    
}
- (void)awakeFromNib {
   
}
//- (IBAction)deleteButtonClick:(UIButton *)sender {
//    if (self.deleteDelegate && [self.deleteDelegate respondsToSelector:@selector(deleteFavoriteFriend:)]) {
//        [self.deleteDelegate deleteFavoriteFriend:self];
//    }
//}
@end
