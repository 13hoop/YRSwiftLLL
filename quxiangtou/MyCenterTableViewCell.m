//
//  MyCenterTableViewCell.m
//  quxiangtou
//
//  Created by mac on 15/9/29.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "MyCenterTableViewCell.h"

@implementation MyCenterTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 1, self.frame.size.height)];
        label.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:label];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.size.width + label.frame.origin.x + 30, 0, 120, self.frame.size.height)];
//        _titleLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_titleLabel];
        
        _titleDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.size.width + _titleLabel.frame.origin.x + 10, 0, 100, self.frame.size.height)];
//        _titleDetailLabel.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:_titleDetailLabel];
        
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
