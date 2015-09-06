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

    }
    return self;
}
- (void)awakeFromNib {
   }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
