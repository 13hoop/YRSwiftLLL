//
//  XieHouTableViewCell.m
//  quxiangtou
//
//  Created by wei feng on 15/8/18.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "XieHouTableViewCell.h"

@implementation XieHouTableViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XieHouTableViewCell" owner:self options:nil] lastObject];
//        _touxiangImage.layer.cornerRadius = 45;
//        _touxiangImage.layer.masksToBounds = YES;
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
