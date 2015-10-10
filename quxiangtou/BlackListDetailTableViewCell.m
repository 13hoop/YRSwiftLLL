//
//  BlackListDetailTableViewCell.m
//  quxiangtou
//
//  Created by mac on 15/9/30.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "BlackListDetailTableViewCell.h"

@implementation BlackListDetailTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _UpBlackListButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _UpBlackListButton.backgroundColor = color_alpha(69, 192, 24, 1);
        _UpBlackListButton.frame = CGRectMake(Screen_width - 80, 25, 70, 30);
        _UpBlackListButton.layer.cornerRadius = 5;
        _UpBlackListButton.layer.masksToBounds = YES;
        [_UpBlackListButton setTitle:@"添加" forState:UIControlStateNormal];
        [_UpBlackListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.UpBlackListButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickUpBlackListWithCell:)])
            {
                [self.delegate didClickUpBlackListWithCell:self];
            }
        }];
        [self.contentView addSubview:_UpBlackListButton];
        
        _NOClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _NOClickButton.backgroundColor = [UIColor grayColor];
        [_NOClickButton setTitle:@"已添加" forState:UIControlStateNormal];
        _NOClickButton.layer.masksToBounds = YES;
        _NOClickButton.layer.cornerRadius = 5;
        _NOClickButton.frame = CGRectMake(self.frame.size.width - 80, 25, 70, 30);
        [self.contentView addSubview:_NOClickButton];
        
        CGFloat height = (80 - 60) /4;
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, height, 200, 20)];
        //_nameLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_nameLabel];
        
        _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, height + _nameLabel.frame.size.height + _nameLabel.frame.origin.y, 200, 20)];
        _nickNameLabel.font = [UIFont systemFontOfSize:14];
        _nickNameLabel.textColor = [UIColor grayColor];
        //_nickNameLabel.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:_nickNameLabel];
        
        _mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, height + _nickNameLabel.frame.size.height + _nickNameLabel.frame.origin.y, 200, 20)];
        _mobileLabel.font = [UIFont systemFontOfSize:14];
        _mobileLabel.textColor = [UIColor grayColor];
        //_mobileLabel.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:_mobileLabel];
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
