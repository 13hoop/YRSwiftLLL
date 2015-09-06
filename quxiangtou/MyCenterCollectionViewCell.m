//
//  MyCenterCollectionViewCell.m
//  quxiangtou
//
//  Created by mac on 15/9/3.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "MyCenterCollectionViewCell.h"

@implementation MyCenterCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyCenterCollectionViewCell" owner:self options:nil] lastObject];
       
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}


@end
