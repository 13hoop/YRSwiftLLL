//
//  ChatTableViewCell.h
//  quxiangtou
//
//  Created by wei feng on 15/8/15.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell

@property(nonatomic,retain)UIImageView *photoIg;
@property(nonatomic,retain)UILabel *nameLbl,*idLbl,*timeLbl;
@property(nonatomic,retain)UIView *chatView;
@property(nonatomic,retain)UILabel * contentLabel;

@end
