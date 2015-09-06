//
//  MyMessageTableViewCell.h
//  quxiangtou
//
//  Created by mac on 15/9/5.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *AuthorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *TitleImage;

@end
