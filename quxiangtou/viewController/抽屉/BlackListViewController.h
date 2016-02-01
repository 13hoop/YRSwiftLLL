//
//  BlackListViewController.h
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Model.h"
#import "SWTableViewCell.h"

@interface BlackListViewController : UIViewController
{
    NSMutableArray *dataSource;
    ASIFormDataRequest * GetBlackListRequest;
    ASIFormDataRequest * deleteBlackListRequest;
    
}
@end
