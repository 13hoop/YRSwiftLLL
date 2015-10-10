//
//  MyMailListViewController.h
//  quxiangtou
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Model.h"

@interface MyMailListViewController : UIViewController
{
    NSMutableArray *dataSource;
    ASIFormDataRequest * upBackListRequest;
    ASIFormDataRequest * CheckListRequest;
    
}
@end
