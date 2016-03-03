//
//  messageOfMeTableViewCell.m
//  quxiangtou
//
//  Created by mac on 16/2/3.
//  Copyright © 2016年 蒲瑞玲. All rights reserved.
//

#import "messageOfMeTableViewCell.h"

@implementation messageOfMeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(editMessageOfMeOne:)]) {
        [self.delegate editMessageOfMeOne:self];
    }
}
@end
