//
//  BlackTableViewCell.m
//  quxiangtou
//
//  Created by wei feng on 15/8/15.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "BlackTableViewCell.h"

@implementation BlackTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 30)];
        label1.text = @"通讯录";
        label1.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label1];
        
        _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width / 2 - 50, label1.frame.origin.y, 100, 30)];
        _nameLbl.textAlignment = NSTextAlignmentCenter;
        _nameLbl.text = @"张三";
        [self.contentView addSubview:_nameLbl];
        
        _phoneLbl = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width - 140, label1.frame.origin.y, 130, 30)];
        _phoneLbl.textAlignment = NSTextAlignmentRight;
        _phoneLbl.text = @"18888301456";
        [self.contentView addSubview:_phoneLbl];
        
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
