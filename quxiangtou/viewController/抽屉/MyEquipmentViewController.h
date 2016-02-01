//
//  MyEquipmentViewController.h
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivateValues.h"
#import "MRHexKeyboard.h"

//A141223001 Andy - for BLE
#import "BluetoothLEManager.h"
#import "BluetoothLEService.h"
@interface MyEquipmentViewController : UIViewController<BluetoothLEManagerDelegateProtocol, BluetoothLEServiceProtocol>
{
    UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic,strong) UITextField *txtCustomer;
@property (nonatomic,strong) UITextField *txtMode;
@property (nonatomic,strong) UITextField *txtMode2;
@property (nonatomic,strong) UITextField *txtMode3;
@property (nonatomic,strong) UITextField *txtStrength;
@property (nonatomic,strong) UITextField *txtStrength2;
@property (nonatomic,strong) UITextField *txtStrength3;
@property (nonatomic,strong) UIButton *btnSend;
@property (nonatomic,strong) UIButton *btnReceive;
@property (nonatomic,strong) UIButton *btnStop;
@property (nonatomic,strong) UITextView *txtMsg;
@property (nonatomic,strong) UIButton *btnScan;
@property (nonatomic,strong) UILabel *labMsg;
@property (nonatomic,strong) UIButton *btnClear;
@property (nonatomic,strong) UIButton *btnPause;
@property (nonatomic,strong) UIActivityIndicatorView * activityIndicator;
- (void)btnSend_Click:(id)sender;
- (void)btnReceive_Click:(id)sender;
- (void)btnStop_Click:(id)sender;
- (void)btnScan_Click:(id)sender;
- (void)btnClear_Click:(id)sender;
- (void)btnPause_Click:(id)sender;
@end