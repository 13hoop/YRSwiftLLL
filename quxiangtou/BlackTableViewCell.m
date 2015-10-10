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
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
        label1.text = @"通讯录";
        label1.textAlignment = NSTextAlignmentLeft;
        label1.font = [UIFont systemFontOfSize:16];
        //label1.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:label1];
        
        _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.size.width + label1.frame.origin.x + 5, label1.frame.origin.y, 120, 30)];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        _nameLbl.text = @"张三";
        _nameLbl.font = [UIFont systemFontOfSize:14];
        //_nameLbl.backgroundColor = [UIColor redColor];
        
        [self.contentView addSubview:_nameLbl];
        
        _phoneLbl = [[UILabel alloc]initWithFrame:CGRectMake(_nameLbl.frame.size.width + _nameLbl.frame.origin.x + 10, label1.frame.origin.y, (Screen_width - _nameLbl.frame.size.width - _nameLbl.frame.origin.x - 20), 30)];
        _phoneLbl.textAlignment = NSTextAlignmentRight;
        _phoneLbl.text = @"18888301456";
        _phoneLbl.font = [UIFont systemFontOfSize:14];
       // _phoneLbl.backgroundColor = [UIColor cyanColor];
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
