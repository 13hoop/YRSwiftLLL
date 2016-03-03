//
//  MyCenterTableViewCell.h
//  quxiangtou
//
//  Created by mac on 15/9/29.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol editMessageOfMeTwoDelegate <NSObject>

-(void)editMessageOfMeTwo:(UITableViewCell *)cell;

@end
@interface MyCenterTableViewCell : UITableViewCell
@property (nonatomic,strong) id<editMessageOfMeTwoDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


- (IBAction)editButtonClick:(UIButton *)sender;


@end
