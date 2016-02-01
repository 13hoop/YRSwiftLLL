//
//  sendDataViewController.h
//  quxiangtou
//
//  Created by mac on 15/12/28.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
//A141223001 Andy - for BLE
#import "BluetoothLEManager.h"
#import "BluetoothLEService.h"

@interface sendDataViewController : UIViewController<BluetoothLEManagerDelegateProtocol, BluetoothLEServiceProtocol>
@property (nonatomic,strong) NSDictionary * dic;
@end
