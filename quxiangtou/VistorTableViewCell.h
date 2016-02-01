//
//  VistorTableViewCell.h
//  quxiangtou
//
//  Created by wei feng on 15/8/15.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol deleteFavoriteFriendDelegate;

@interface VistorTableViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) id<deleteFavoriteFriendDelegate>deleteDelegate;
//@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@end
@protocol deleteFavoriteFriendDelegate <NSObject>

-(void)deleteFavoriteFriend:(VistorTableViewCell *)indexPath;

@end
