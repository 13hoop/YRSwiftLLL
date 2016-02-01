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
    _imageArray = [[NSArray alloc]init];
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 40, 30)];
        _dayLabel.font = [UIFont boldSystemFontOfSize:24];
        _dayLabel.textAlignment = NSTextAlignmentRight;
        _dayLabel.text = @"30";
        //_dayLabel.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:_dayLabel];
        
        _monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(_dayLabel.frame.size.width + _dayLabel.frame.origin.x, _dayLabel.frame.origin.y + 12, 40, 20)];
        _monthLabel.font = [UIFont systemFontOfSize:20];
        _monthLabel.textAlignment = NSTextAlignmentLeft;
        _monthLabel.text = @"12";
        //_monthLabel.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_monthLabel];
        
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_dayLabel.frame.origin.x + 7, _dayLabel.frame.origin.y + _dayLabel.frame.size.height + 5, 80, 30)];
//        _numberLabel.textAlignment = NSTextAlignmentRight;
        _numberLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_numberLabel];
        
        CGFloat width = (Screen_width - 10 - _monthLabel.frame.size.width - _monthLabel.frame.origin.x - 30) / 3;
        _imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(_monthLabel.frame.origin.x + _monthLabel.frame.size.width  + 10, 10, width, width)];
        [self.contentView addSubview:_imageView1];
        
        _imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(_imageView1.frame.origin.x + _imageView1.frame.size.width  + 10, 10, width, width)];
        [self.contentView addSubview:_imageView2];
        
        _imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(_imageView2.frame.origin.x + _imageView2.frame.size.width  + 10, 10, width, width)];
        [self.contentView addSubview:_imageView3];
        
        _imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(_monthLabel.frame.origin.x + _monthLabel.frame.size.width  + 10, _imageView1.frame.size.height + _imageView1.frame.origin.y + 5, width, width)];
        [self.contentView addSubview:_imageView4];
        
        _imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(_imageView1.frame.origin.x + _imageView1.frame.size.width  + 10, _imageView4.frame.origin.y, width, width)];
        [self.contentView addSubview:_imageView5];
        
        _imageView6 = [[UIImageView alloc]initWithFrame:CGRectMake(_imageView2.frame.origin.x + _imageView2.frame.size.width  + 10, _imageView4.frame.origin.y, width, width)];
        [self addSubview:_imageView6];
        
        _imageView7 = [[UIImageView alloc]initWithFrame:CGRectMake(_monthLabel.frame.origin.x + _monthLabel.frame.size.width  + 10, _imageView4.frame.size.height + _imageView4.frame.origin.y + 5, width, width)];
        [self.contentView addSubview:_imageView7];
        
        _imageView8 = [[UIImageView alloc]initWithFrame:CGRectMake(_imageView1.frame.origin.x + _imageView1.frame.size.width  + 10, _imageView7.frame.origin.y, width, width)];
        [self.contentView addSubview:_imageView8];
        
        _imageView9 = [[UIImageView alloc]initWithFrame:CGRectMake(_imageView2.frame.origin.x + _imageView2.frame.size.width  + 10, _imageView7.frame.origin.y , width, width)];
        [self.contentView addSubview:_imageView9];
        _imageView1.hidden = YES;
        _imageView2.hidden = YES;
        _imageView3.hidden = YES;
        _imageView4.hidden = YES;
        _imageView5.hidden = YES;
        _imageView6.hidden = YES;
        _imageView7.hidden = YES;
        _imageView8.hidden = YES;
        _imageView9.hidden = YES;
           }
    return self;

}

- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
        

    
}

@end
