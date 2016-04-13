//
//  VisitorDetailViewController.h
//  quxiangtou
//
//  Created by mac on 15/9/16.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitorDetailViewController : UIViewController
{
    ASIFormDataRequest * xiehouRequest;
    ASIFormDataRequest * UploadDataRequest;
    ASIFormDataRequest * GetPicturesRequest;
    ASIFormDataRequest * addFavoriteFriendRequest;
    ASIFormDataRequest * deleteFavoriteFriendRequest;
}
@property (nonatomic,strong)NSArray * visitorArray ;
@property (nonatomic,assign) int page;
@end
