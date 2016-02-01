//
//  EquipmentViewController.h
//  quxiangtou
//
//  Created by mac on 15/12/7.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivateValues.h"
#import "MRHexKeyboard.h"
#import "BaseViewController.h"

//A141223001 Andy - for BLE
#import "BluetoothLEManager.h"
#import "BluetoothLEService.h"
@interface EquipmentViewController : BaseViewController<BluetoothLEManagerDelegateProtocol, BluetoothLEServiceProtocol>

@end
