//
//  MyAlbumTableViewCell.m
//  quxiangtou
//
//  Created by mac on 15/9/7.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "MyAlbumTableViewCell.h"

@implementation MyAlbumTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _todayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 80, 30)];
        _todayLabel.text = @"今天";
        _todayLabel.font = [UIFont boldSystemFontOfSize:24];
        _todayLabel.textAlignment = NSTextAlignmentCenter;
        //_todayLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_todayLabel];
        
        _dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 40, 30)];
        _dayLabel.font = [UIFont boldSystemFontOfSize:24];
        _dayLabel.textAlignment = NSTextAlignmentRight;
        _dayLabel.text = @"30";
        //_dayLabel.backgroundColor = [UIColor cyanColor];
        [self addSubview:_dayLabel];
        
        _monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(_dayLabel.frame.size.width + _dayLabel.frame.origin.x, _dayLabel.frame.origin.y + 12, 40, 20)];
        _monthLabel.font = [UIFont systemFontOfSize:20];
        _monthLabel.textAlignment = NSTextAlignmentLeft;
        _monthLabel.text = @"12";
        //_monthLabel.backgroundColor = [UIColor yellowColor];
        [self addSubview:_monthLabel];
        
        CGFloat width = (Screen_width - 10 - _monthLabel.frame.size.width - _monthLabel.frame.origin.x - 30) / 3;
        _imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(_monthLabel.frame.origin.x + _monthLabel.frame.size.width  + 10, 10, width, width)];
       // _imageView1.image = [UIImage imageNamed:@"美女01.jpg"];
        [self addSubview:_imageView1];
        
        _imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(_imageView1.frame.origin.x + _imageView1.frame.size.width  + 10, 10, width, width)];
        //_imageView2.image = [UIImage imageNamed:@"美女02.jpg"];
        [self.contentView addSubview:_imageView2];
        
        _imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(_imageView2.frame.origin.x + _imageView2.frame.size.width  + 10, 10, width, width)];
        //_imageView3.image = [UIImage imageNamed:@"美女03.jpg"];
        [self addSubview:_imageView3];
    }
    return self;

}

- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
