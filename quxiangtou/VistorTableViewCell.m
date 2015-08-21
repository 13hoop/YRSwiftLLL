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
        _touxiangImage.layer.cornerRadius = 45;
        _touxiangImage.layer.masksToBounds = YES;
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
