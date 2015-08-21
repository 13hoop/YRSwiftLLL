//
//  ChatTableViewCell.m
//  quxiangtou
//
//  Created by wei feng on 15/8/15.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        // Initialization code
        UIImageView *photoBack=[[UIImageView alloc]initWithFrame:CGRectMake(5,5,69,69)];
        photoBack.layer.cornerRadius = 34;
        photoBack.layer.masksToBounds = YES;
        photoBack.image=[UIImage imageNamed:@"默认头像@2x.png"];
        [self addSubview:photoBack];
        //用户头像
        self.photoIg=[[UIImageView alloc]initWithFrame:CGRectMake(4.5,4.5,60,60)];
//        ACommenData *commenData=[ACommenData sharedInstance];
//        UIImage *placeIg;
//        if([[commenData.logDic valueForKey:@"gender"] isEqualToString:@"0"]){
//            placeIg=[UIImage imageNamed:@"男.png"];
//        }else{
//            placeIg=[UIImage imageNamed:@"女.png"];
//        }
//        _photoIg.image=placeIg;
        self.photoIg.image = [UIImage imageNamed:@"美女01.jpg"];
        self.photoIg.layer.cornerRadius = 30;
        self.photoIg.layer.masksToBounds = YES;
        [photoBack addSubview:_photoIg];
        
        //姓名
        _nameLbl=[[UILabel alloc]initWithFrame:CGRectMake(80,23,80,20)];
        [_nameLbl setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [_nameLbl setTextColor:[UIColor colorWithRed:218.0f/255.0f green:68.0f/255.0f blue:120.0f/255.0f alpha:1.0f]];
        _nameLbl.backgroundColor=[UIColor clearColor];
        _nameLbl.text=@"扩大进口大";
        [self addSubview:_nameLbl];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, _nameLbl.frame.size.height+_nameLbl.frame.origin.y+5, 170, 20)];
        _contentLabel.font = [UIFont boldSystemFontOfSize:10.0f];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.text = @"张三";
        [self addSubview:_contentLabel];
        
        //id
        _idLbl=[[UILabel alloc]initWithFrame:CGRectMake(_nameLbl.frame.origin.x+_nameLbl.frame.size.width+3,23,100,20)];
        [_idLbl setFont:[UIFont boldSystemFontOfSize:12.0f]];
        _idLbl.backgroundColor=[UIColor clearColor];
        _idLbl.text=@"(ID:23434343)";
        [self addSubview:_idLbl];
        //时间
        _timeLbl=[[UILabel alloc]initWithFrame:CGRectMake(126,5,165,18)];
        _timeLbl.backgroundColor=[UIColor clearColor];
        [_timeLbl setTextAlignment:NSTextAlignmentRight];
        [_timeLbl setText:@"14:23"];
        [_timeLbl setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [_timeLbl setTextColor:[UIColor redColor]];
        [self addSubview:_timeLbl];
        
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
