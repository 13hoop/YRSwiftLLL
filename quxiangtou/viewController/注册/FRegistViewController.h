//
//  FRegistViewController.h
//  quxiangtou
//
//  Created by wei feng on 15/7/24.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Model.h"

@class AppDelegate;

@interface FRegistViewController : UIViewController
{
    AppDelegate *app; //APPDelegate的对象..
    NSMutableArray *dataSource;
    ASIFormDataRequest * upBackListRequest;
}
@property (nonatomic,strong) NSString * nameOfUpPage;

@end
