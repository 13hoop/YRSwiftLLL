//
//  MyPhotoAlbumViewController.h
//  quxiangtou
//
//  Created by mac on 15/9/7.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPhotoAlbumViewController : UIViewController
@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic,assign) int page;
@property (nonatomic,strong) NSString * pageName;
@property (nonatomic,strong) NSString * avatarString;
@property (nonatomic,strong) NSString * nickName;
@end