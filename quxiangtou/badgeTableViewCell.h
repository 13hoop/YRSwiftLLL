//
//  badgeTableViewCell.h
//  quxiangtou
//
//  Created by mac on 16/2/3.
//  Copyright © 2016年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol editMessageOfMeThreeDelegate <NSObject>

-(void)editMessageOfMeThree:(UITableViewCell *)cell;

@end
@interface badgeTableViewCell : UITableViewCell
@property (nonatomic,strong) id<editMessageOfMeThreeDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *tag1;
@property (weak, nonatomic) IBOutlet UILabel *tag2;
@property (weak, nonatomic) IBOutlet UILabel *tag3;
@property (weak, nonatomic) IBOutlet UIButton *tag4Button;
- (IBAction)tag4ButtonClick:(UIButton *)sender;

@end
