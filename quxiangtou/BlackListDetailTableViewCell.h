//
//  BlackListDetailTableViewCell.h
//  quxiangtou
//
//  Created by mac on 15/9/30.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BlackListDetailDelegate;
@interface BlackListDetailTableViewCell : UITableViewCell
@property (nonatomic,strong) UIButton * UpBlackListButton;
@property (nonatomic,strong) UIButton * NOClickButton;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * nickNameLabel;
@property (nonatomic,strong) UILabel * mobileLabel;
@property (nonatomic,assign) id<BlackListDetailDelegate>delegate;
@end
@protocol BlackListDetailDelegate <NSObject>

- (void) didClickUpBlackListWithCell:(BlackListDetailTableViewCell *) cell;

@end