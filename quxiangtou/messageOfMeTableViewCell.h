//
//  messageOfMeTableViewCell.h
//  quxiangtou
//
//  Created by mac on 16/2/3.
//  Copyright © 2016年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol editMessageOfMeOneDelegate <NSObject>

-(void)editMessageOfMeOne:(UITableViewCell *)cell;

@end
@interface messageOfMeTableViewCell : UITableViewCell
@property (nonatomic,strong) id<editMessageOfMeOneDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *shapeLabel;
@property (weak, nonatomic) IBOutlet UILabel *skinLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel4;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel5;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)editButtonClick:(UIButton *)sender;

@end
