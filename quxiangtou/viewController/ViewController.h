//
//  ViewController.h
//  quxiangtou
//
//  Created by wei feng on 15/7/24.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    ASIFormDataRequest * xiehouRequest;
    ASIFormDataRequest * UploadDataRequest;
    ASIFormDataRequest * GetPicturesRequest;
    ASIFormDataRequest * update_locationRequest;
    ASIFormDataRequest * addFavoriteFriendRequest;
}
@property (nonatomic,assign) BOOL * isFirst;
@property (nonatomic,strong)  NSMutableArray * xiehouArray;
@end

