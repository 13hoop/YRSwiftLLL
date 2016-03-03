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

- (IBAction)editButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(editMessageOfMeTwo:)]) {
        [self.delegate editMessageOfMeTwo:self];
    }
}
@end
