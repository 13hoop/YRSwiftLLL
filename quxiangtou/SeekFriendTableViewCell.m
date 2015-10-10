//
//  SeekFriendTableViewCell.m
//  quxiangtou
//
//  Created by mac on 15/9/26.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "SeekFriendTableViewCell.h"

@implementation SeekFriendTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 80 - 18, 80 - 18)];
        [self.contentView addSubview:_avatarImageView];
        
        _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avatarImageView.frame.size.width + _avatarImageView.frame.origin.x + 10, 10, 150, 25)];
        //_nickNameLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_nickNameLabel];
        
        _genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_nickNameLabel.frame.origin.x, _avatarImageView.frame.origin.y +_avatarImageView.frame.size.height - 25, 20, 25)];
        [self.contentView addSubview:_genderImageView];
        
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
