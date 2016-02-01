//
//  EquipmentViewController.m
//  quxiangtou
//
//  Created by mac on 15/12/7.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "EquipmentViewController.h"
#import "DGActivityIndicatorView.h"

//A150911001 - Andy Telephone
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@interface EquipmentViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    UIButton * backButton;
    UIButton * findEquipmentButton;
    UILabel * findEquipmentLabel;
    DGActivityIndicatorView *activityIndicatorView;
    
    //A150911001 - Andy Telephone
    CTCallCenter *callCenter;
    NSMutableArray * availableDeviceArray;
    BOOL isPaired;
}
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) BluetoothLEService *service;
@end

@implementation EquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isPaired = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"顶操01@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];

    self.navigationItem.title = @"我的设备";
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [PrivateValues initValuesForFirstLaunch]; // 创建文件夹，文件夹中的内容
    }
    
    //初始值給 NO
    [PrivateValues saveValue:@"NO" forKey:PLIST_VALUE_BLE];
    
    //A141223001 Andy - for BLE
    [BluetoothLEManager sharedManagerWithDelegate:self];
    
    //A150911001 - Andy Telephone
    __weak typeof(self) weakSelf = self;
    callCenter = [[CTCallCenter alloc] init];
    callCenter.callEventHandler = ^(CTCall* ctcall) {
        // do something, for example ...
        if (ctcall.callState == CTCallStateConnected) {
            //目前有通話正在進行中
        }
        
        if (ctcall.callState == CTCallStateIncoming) {
            //有來電
            [weakSelf btnStop_Click:0];
        }
        
        if (ctcall.callState == CTCallStateDisconnected) {
            //掛斷電話
            [weakSelf btnScan_Click:0];
        }
    };

   [self createUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
#pragma mark - 蓝牙设备状态改变的回调
- (void) didChangeState:(CBCentralManagerState) newState
{
    NSLog(@"\nStep4");
    DebugLog(@"state changed: %ld", (long)newState);
    
    if (newState == CBCentralManagerStatePoweredOn)
    {
        NSLog(@"蓝牙状态打开");
    }
    else
    {
        self.peripheral = nil;
    }
}

#pragma mark - 停止
- (void)btnStop_Click:(id)sender {
    //關閉Bluetooth Scan
    [PrivateValues saveValue:@"NO" forKey:PLIST_VALUE_BLE];
    
    //停止掃描
    [[BluetoothLEManager sharedManager] stopScanning];

}

#pragma mark - 扫描
- (void)btnScan_Click:(id)sender {
    //開啟Bluetooth Scan
    [PrivateValues saveValue:@"YES" forKey:PLIST_VALUE_BLE];

    //開始掃瞄裝置
    [[BluetoothLEManager sharedManager] discoverDevices];
}

-(void)createUI
{
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(Screen_width/ 2 - 70, Screen_height/2 - 100, 140, 200);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(searchEquipment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    findEquipmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    findEquipmentButton.frame = CGRectMake(0, 0, 140, 140);
    [findEquipmentButton setImage:[UIImage imageNamed:@"点击发现设备@2x.png"] forState:UIControlStateNormal];
     [findEquipmentButton addTarget:self action:@selector(searchEquipment) forControlEvents:UIControlEventTouchUpInside];
    [backButton addSubview:findEquipmentButton];
    
    findEquipmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(findEquipmentButton.frame.origin.x, findEquipmentButton.frame.size.height + findEquipmentButton.frame.origin.y + 20, findEquipmentButton.frame.size.width, 30)];
    [findEquipmentLabel setText:@"点击发现设备"];
    findEquipmentLabel.textAlignment = NSTextAlignmentCenter;
    findEquipmentLabel.backgroundColor = [UIColor clearColor];
    [findEquipmentLabel setTextColor:color_alpha(252, 93, 161, 1)];
    [backButton addSubview:findEquipmentLabel];
    
    NSArray *activityTypes = @[ @(DGActivityIndicatorAnimationTypeTriplePulse),
                                ];
    NSArray *sizes = @[@(150.0f),
                       ];
    activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)[activityTypes[0] integerValue] tintColor:[UIColor colorWithRed:252/255.0f green:93/255.0f blue:161/255.0f alpha:1.0f] size:[sizes[0] floatValue]];
    CGFloat width = self.view.bounds.size.width / 2.0f;
    CGFloat height = self.view.bounds.size.height / 3.0f;
    activityIndicatorView.frame = CGRectMake(self.view.frame.size.width / 2 - width/ 2, self.view.frame.size.height / 2 - height / 2, width, height);
    activityIndicatorView.hidden = YES;
    [self.view addSubview:activityIndicatorView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height - 64 - 44) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
}
-(void)searchEquipment
{
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"此应用需要使用蓝牙功能" message:nil delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"允许", nil];
    [av show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else if(buttonIndex == 1){
        findEquipmentLabel.hidden = YES;
        findEquipmentButton.hidden = YES;
        activityIndicatorView.hidden = NO;
        [activityIndicatorView startAnimating];
        //開啟Bluetooth Scan
        [PrivateValues saveValue:@"YES" forKey:PLIST_VALUE_BLE];
        
        //開始掃瞄裝置
        [[BluetoothLEManager sharedManager] discoverDevices];
    }
}

#pragma mark -
#pragma mark - Bluetooth Management  发现蓝牙设备的回调
//A140717001 Andy - for BLE
- (void) didDiscoverPeripheral:(CBPeripheral *) peripheral advertisementData:(NSDictionary *) advertisementData
{
    NSLog(@"\nStep1");
    CBUUID *heartRateUUID = [CBUUID UUIDWithString:@"0xFFF0"];
    CBUUID *heartRateUUID2 = [CBUUID UUIDWithString:@"0000FEE9-0000-1000-8000-00805F9B34FB"];
    NSArray *advertisementUUIDs = [advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey];
    for (CBUUID *uuid in advertisementUUIDs)
    {
        NSLog(@"uuid = %@",uuid);

        if ([uuid isEqual:heartRateUUID])
        {
            DebugLog(@"found heartrate monitor...");
            [[BluetoothLEManager sharedManager] stopScanning];
            if (self.peripheral == nil)
            {
                self.peripheral = peripheral;
            }
            break;
        }

        if ([uuid isEqual:heartRateUUID2] && self.peripheral == nil)
        {
            DebugLog(@"found heartrate monitor...");
            [[BluetoothLEManager sharedManager] stopScanning];
            if (self.peripheral == nil)
            {
                self.peripheral = peripheral;
            }
            NSLog(@"plist_value_ble = %@",[PrivateValues getValueForKey:PLIST_VALUE_BLE]);
            break;
        }
    }
    [activityIndicatorView stopAnimating];
    activityIndicatorView.hidden = YES;
    _tableView.hidden = NO;
    [_tableView reloadData];

}
#pragma mark - 连接到蓝牙设备的回调
- (void) didConnectPeripheral:(CBPeripheral *) peripheral error:(NSError *)error
{
    isPaired = YES;
    [_tableView reloadData];
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"蓝牙设备已配对,可到自娱自乐了解功能详情!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
    NSLog(@"\nStep2");
    DebugLog(@"didConnectPeripheral: %@ - %@", peripheral, error);
    self.peripheral = peripheral;
 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"peripheral" object:@{@"peripheral":peripheral}];


}
#pragma mark - 未连接到蓝牙设备的回调
- (void) didDisconnectPeripheral:(CBPeripheral *) peripheral error:(NSError *)error
{
    isPaired = NO;
    [_tableView reloadData];
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"蓝牙设备断开连接!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
    NSLog(@"\nStep3");
    DebugLog(@"didDisconnect: %@ %@", peripheral, error);
    self.service = nil;
    
    if (self.peripheral != nil && [[NSUserDefaults standardUserDefaults] boolForKey:kAutomaticalllyReconnect])
    {
        [[BluetoothLEManager sharedManager] connectPeripheral:self.peripheral];
    }
    else
    {
        [[BluetoothLEManager sharedManager] discoverDevices];
    }
    self.peripheral = nil;
}
- (void) didDiscoverCharacterisics:(BluetoothLEService *) service
{
    NSLog(@"\nStep6");
    //A150706001 Andy
    if (![self.peripheral.name isEqualToString:@"QSPOWER BLE"]){
        [service startNotifyingForServiceUUID:@"0xFFF0" andCharacteristicUUID:@"0xFFF4"];
    } else {
        [service startNotifyingForServiceUUID:@"0000FEE9-0000-1000-8000-00805F9B34FB" andCharacteristicUUID:@"D44BC439-ABFD-45A2-B575-925416129601"];
    }
    DebugLog(@"finished discovering: %@", service);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [PrivateValues saveValue:@"YES" forKey:PLIST_VALUE_BLE];
    if ([[PrivateValues getValueForKey:PLIST_VALUE_BLE] isEqualToString:@"YES"]) {
        [[BluetoothLEManager sharedManager] connectPeripheral:self.peripheral];
    } else {
        if (self.peripheral.state == CBPeripheralStateConnected){
            [[BluetoothLEManager sharedManager] disconnectPeripheral:self.peripheral];
        }
    }
}
-(void)showLeft
{
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
    [dd showLeftController:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"可用设备";
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * string = @"equipment";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:string];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.text = self.peripheral.name;
    if (self.peripheral.state == 0) {
        cell.detailTextLabel.text = @"未连接";
    }else if (self.peripheral.state == 1){
        cell.detailTextLabel.textColor = [UIColor yellowColor];
        cell.detailTextLabel.text = @"正在连接";
    }else if (self.peripheral.state == 2){
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.text = @"已连接";
    }
    return cell;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    _tableView.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
