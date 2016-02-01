//
//  MyEquipmentViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "MyEquipmentViewController.h"
//A150911001 - Andy Telephone
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@interface MyEquipmentViewController (){
    //A141230001 Andy
    NSTimer *myTime;
    NSString *strMode;
    NSString *strCust2;
    
    //A150911001 - Andy Telephone
    CTCallCenter *callCenter;
}


//A141223001 Andy - for BLE
//We only connect with 1 device at a time
@property (nonatomic, assign) CBPeripheral *peripheral;
@property (nonatomic, strong) BluetoothLEService *service;
@end

@implementation MyEquipmentViewController
@synthesize activityIndicator;

//int tTimers = 0;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = color_alpha(219, 219, 219, 1);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"顶操01@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
    self.navigationItem.title = @"我的设备";
    //self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    // Do any additional setup after loading the view, typically from a nib.   在加载视图后做任何额外的设置，通常从nib
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [PrivateValues initValuesForFirstLaunch]; // 创建文件夹，文件夹中的内容
    }
    
    //初始值給 NO
    [PrivateValues saveValue:@"NO" forKey:PLIST_VALUE_BLE];
    
    activityIndicator = [[UIActivityIndicatorView alloc] init]; // initWithFrame:CGRectMake(10, 410, 24, 24)];
    [activityIndicator setCenter:CGPointMake(30, 542)];
    activityIndicator.color = [UIColor orangeColor];
    [activityIndicator setHidesWhenStopped:YES];
    [activityIndicator setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    activityIndicator.transform = CGAffineTransformMakeScale(1.75, 1.75);
    [self.view addSubview:activityIndicator];
    [activityIndicator stopAnimating];
    
    //A141223001 Andy - for BLE
    [BluetoothLEManager sharedManagerWithDelegate:self];
    [self setupConnectButton];
    
    //清除畫面 textView
    [self btnClear_Click:0];
    
    self.txtMsg.editable = NO;
    self.txtMsg.scrollEnabled = YES;
    //不一直更新畫面  用scrollRangeToVisible函数进行滚动，可以跳动到最后一行内容上
    [self.txtMsg scrollRangeToVisible:NSMakeRange(self.txtMsg.text.length, 1)];
    //但是只是上面那一行代码，效果不好，由于重新设置了内容，导致每次都要从顶部跳到最后一行，界面很闪，解决办法就是加上下面一行代码
    //UITextView中的layoutManager（NSLayoutManager）的是否非连续布局属性，默认是YES，设置为NO后UITextView就不会在自己重置滑动了
    self.txtMsg.layoutManager.allowsNonContiguousLayout = NO;
    
    //添加手勢動作-隱藏keyboard
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
    
    //設定 HEX 鍵盤
    self.txtCustomer.inputView = [[MRHexKeyboard alloc] initWithTextField:self.txtCustomer];
    self.txtMode.inputView     = [[MRHexKeyboard alloc] initWithTextField:self.txtMode];
    self.txtMode2.inputView    = [[MRHexKeyboard alloc] initWithTextField:self.txtMode2];
    self.txtMode3.inputView    = [[MRHexKeyboard alloc] initWithTextField:self.txtMode3];
    self.txtStrength.inputView = [[MRHexKeyboard alloc] initWithTextField:self.txtStrength];
    self.txtStrength2.inputView = [[MRHexKeyboard alloc] initWithTextField:self.txtStrength2];
    self.txtStrength3.inputView = [[MRHexKeyboard alloc] initWithTextField:self.txtStrength3];
    
    //給初始值
    self.txtCustomer.text  = @"60";
    self.txtCustomer.enabled = NO;
    
    self.txtMode.text      = @"01";
    self.txtMode.enabled = NO;
    
    self.txtMode2.text     = @"01";
    
    self.txtMode3.text     = @"00";
    self.txtMode3.enabled = NO;
    
    self.txtStrength.text  = @"00";
    self.txtStrength2.text = @"00";
    
    self.txtStrength3.text = @"00";
    self.txtStrength3.enabled = NO;
    
    strCust2 = @"61";
    
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
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self btnStop_Click:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self btnStop_Click:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSLog(@"ddd");
    return YES;
}


#pragma mark -
#pragma mark - Button Action  发送
- (void)btnSend_Click:(id)sender {
    BOOL flage = true;
    self.txtCustomer.textColor  = [UIColor blackColor];
    self.txtMode.textColor      = [UIColor blackColor];
    self.txtMode2.textColor     = [UIColor blackColor];
    self.txtMode3.textColor     = [UIColor blackColor];
    self.txtStrength.textColor  = [UIColor blackColor];
    self.txtStrength2.textColor = [UIColor blackColor];
    self.txtStrength3.textColor = [UIColor blackColor];
    
    //判斷是否連線
    if (self.peripheral.state != CBPeripheralStateConnected) {
        self.txtMsg.text = [NSString stringWithFormat:@"%@\n%@",self.txtMsg.text,@"Bluetooth not Connected..."];
        //顯示最後一筆資料
        [self.txtMsg scrollRangeToVisible:NSMakeRange(self.txtMsg.text.length, 1)];
        flage = false;
    }
    
    //限制輸入條件
    if (self.txtCustomer.text.length < 2) {
        self.txtCustomer.textColor = [UIColor redColor];
        self.txtMsg.text = [NSString stringWithFormat:@"%@\n%@",self.txtMsg.text,@"Customer ID Error..."];
        //顯示最後一筆資料
        [self.txtMsg scrollRangeToVisible:NSMakeRange(self.txtMsg.text.length, 1)];
        flage = false;
    }
    //Mode 1~3
    if (self.txtMode.text.length < 2) {
        self.txtMode.textColor = [UIColor redColor];
        self.txtMsg.text = [NSString stringWithFormat:@"%@\n%@",self.txtMsg.text,@"Mode1 Error..."];
        //顯示最後一筆資料
        [self.txtMsg scrollRangeToVisible:NSMakeRange(self.txtMsg.text.length, 1)];
        flage = false;
    }
    
    if (self.txtMode2.text.length < 2 || [self HexInt:self.txtMode2.text] > 9) {
        self.txtMode2.textColor = [UIColor redColor];
        self.txtMsg.text = [NSString stringWithFormat:@"%@\n%@",self.txtMsg.text,@"Mode2 Error...\n Value in 01 ~ 09"];
        //顯示最後一筆資料
        [self.txtMsg scrollRangeToVisible:NSMakeRange(self.txtMsg.text.length, 1)];
        flage = false;
    }
    
    if (self.txtMode3.text.length < 2) {
        self.txtMode3.textColor = [UIColor redColor];
        self.txtMsg.text = [NSString stringWithFormat:@"%@\n%@",self.txtMsg.text,@"Mode3 Error..."];
        //顯示最後一筆資料
        [self.txtMsg scrollRangeToVisible:NSMakeRange(self.txtMsg.text.length, 1)];
        flage = false;
    }
    
    
    //Strength 1~3
    if (self.txtStrength.text.length < 2) {
        self.txtStrength.textColor = [UIColor redColor];
        self.txtMsg.text = [NSString stringWithFormat:@"%@\n%@",self.txtMsg.text,@"Strength Error..."];
        //顯示最後一筆資料
        [self.txtMsg scrollRangeToVisible:NSMakeRange(self.txtMsg.text.length, 1)];
        flage = false;
    }
    
    if (self.txtStrength2.text.length < 2) {
        self.txtStrength2.textColor = [UIColor redColor];
        self.txtMsg.text = [NSString stringWithFormat:@"%@\n%@",self.txtMsg.text,@"Strength2 Error..."];
        //顯示最後一筆資料
        [self.txtMsg scrollRangeToVisible:NSMakeRange(self.txtMsg.text.length, 1)];
        flage = false;
    }
    
    if (self.txtStrength3.text.length < 2) {
        self.txtStrength3.textColor = [UIColor redColor];
        self.txtMsg.text = [NSString stringWithFormat:@"%@\n%@",self.txtMsg.text,@"Strength3 Error..."];
        //顯示最後一筆資料
        [self.txtMsg scrollRangeToVisible:NSMakeRange(self.txtMsg.text.length, 1)];
        flage = false;
    }
    
    if (flage == false) {
        return;
    }
    
    //停止連線時的訊號
    [myTime invalidate];
    myTime = nil;
    
    strMode = @"40";
    if (myTime == nil) {
        myTime = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(dataSend) userInfo:nil repeats:YES];
    }
    
}
#pragma mark - 接收
- (void)btnReceive_Click:(id)sender {
    
    if (myTime != nil){
        [myTime invalidate];
        myTime = nil;
    }
    strMode = @"41";
    [self dataSend];
 
}
#pragma mark - 停止
- (void)btnStop_Click:(id)sender {
    //關閉Bluetooth Scan
    [PrivateValues saveValue:@"NO" forKey:PLIST_VALUE_BLE];
    
    //Activity Indicator 停
    [activityIndicator stopAnimating];
    
    self.labMsg.textColor = [UIColor blackColor];
    self.labMsg.text = @"Message...";
    
    //停止掃描
    [[BluetoothLEManager sharedManager] stopScanning];
    
    //
    [self setupConnectButton];
}

#pragma mark - 扫描
- (void)btnScan_Click:(id)sender {
    //開啟Bluetooth Scan
    [PrivateValues saveValue:@"YES" forKey:PLIST_VALUE_BLE];
    
    //Activity Indicator 轉
    [activityIndicator startAnimating];
    
    self.labMsg.textColor = [UIColor redColor];
    self.labMsg.text = @"Scan Bluetooth Device ...";
    
    self.txtMsg.text = [NSString stringWithFormat:@"%@\n%@",self.txtMsg.text,@"Scan Bluetooth Device ..."];
    //顯示最後一筆資料
    [self.txtMsg scrollRangeToVisible:NSMakeRange(self.txtMsg.text.length, 1)];
    
    
    //開始掃瞄裝置
    [[BluetoothLEManager sharedManager] discoverDevices];
}

#pragma mark - 清空文本
- (void)btnClear_Click:(id)sender {
    self.txtMsg.text = @"";
}

#pragma mark - 暂停
- (void)btnPause_Click:(id)sender {
    [myTime invalidate];
    myTime = nil;
}

#pragma mark -
#pragma mark - Bluetooth Management  发现蓝牙设备的回调
//A140717001 Andy - for BLE
- (void) didDiscoverPeripheral:(CBPeripheral *) peripheral advertisementData:(NSDictionary *) advertisementData
{
    // Determine if this is the peripheral we want. If it is,
    // we MUST stop scanning before connecting
    //self.labBLEMsg.text = @"Scan ...";
    NSLog(@"\nStep1");
    CBUUID *heartRateUUID = [CBUUID UUIDWithString:@"0xFFF0"];
    CBUUID *heartRateUUID2 = [CBUUID UUIDWithString:@"0000FEE9-0000-1000-8000-00805F9B34FB"];
    NSArray *advertisementUUIDs = [advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey];
    for (CBUUID *uuid in advertisementUUIDs)
    {
        NSLog(@"uuid = %@",uuid);
        // for P!NK
        if ([uuid isEqual:heartRateUUID])
        {
            DebugLog(@"found heartrate monitor...");
            [[BluetoothLEManager sharedManager] stopScanning];
            if (self.peripheral == nil)
            {
                self.peripheral = peripheral;
            }
            
            if ([[PrivateValues getValueForKey:PLIST_VALUE_BLE] isEqualToString:@"YES"]) {
                [[BluetoothLEManager sharedManager] connectPeripheral:self.peripheral];
            } else {
                if (self.peripheral.state == CBPeripheralStateConnected) {
                    [[BluetoothLEManager sharedManager] disconnectPeripheral:self.peripheral];
                }
            }
            
            //A141230001 - Andy
            [myTime invalidate];
            myTime = nil;
            break;
        }
        
        //A150706001 Andy
        // for QSPOWER
        if ([uuid isEqual:heartRateUUID2] && self.peripheral == nil)
        {
            DebugLog(@"found heartrate monitor...");
            [[BluetoothLEManager sharedManager] stopScanning];
            if (self.peripheral == nil)
            {
                self.peripheral = peripheral;
            }
            NSLog(@"plist_value_ble = %@",[PrivateValues getValueForKey:PLIST_VALUE_BLE]);
            if ([[PrivateValues getValueForKey:PLIST_VALUE_BLE] isEqualToString:@"YES"]) {
                [[BluetoothLEManager sharedManager] connectPeripheral:self.peripheral];
            } else {
                if (self.peripheral.state == CBPeripheralStateConnected){
                    [[BluetoothLEManager sharedManager] disconnectPeripheral:self.peripheral];
                }
            }
            
            //A141230001 - Andy
            [myTime invalidate];
            myTime = nil;
            break;
        }
    }
}

#pragma mark - 连接到蓝牙设备的回调
- (void) didConnectPeripheral:(CBPeripheral *) peripheral error:(NSError *)error
{
    NSLog(@"\nStep2");
    DebugLog(@"didConnectPeripheral: %@ - %@", peripheral, error);
    
    //A140814001 Andy - 連線時要看設備名稱
    //if ([peripheral.name isEqualToString:@"Simple BLE Peripher"]) {
    //if ([peripheral.name isEqualToString:@"P!NK"]) {
    self.peripheral = peripheral;
    [self setupConnectButton];
    
    //A150706001 Andy
    if (![self.peripheral.name isEqualToString:@"QSPOWER BLE"]){
        self.service = [[BluetoothLEService alloc] initWithPeripheral:self.peripheral withServiceUUIDs:@[@"0xFFF0"] delegate:self];
    } else {
        self.service = [[BluetoothLEService alloc] initWithPeripheral:self.peripheral withServiceUUIDs:@[@"0000FEE9-0000-1000-8000-00805F9B34FB"] delegate:self];
    }
    [self.service discoverServices];
    
    //B150706001 Andy - remark
    //self.service = [[BluetoothLEService alloc] initWithPeripheral:self.peripheral withServiceUUIDs:@[@"0xFFF0"] delegate:self];
    //[self.service discoverServices];
    
    //}
}
#pragma mark - 未连接到蓝牙设备的回调
- (void) didDisconnectPeripheral:(CBPeripheral *) peripheral error:(NSError *)error
{
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
    [self setupConnectButton];
}
#pragma mark - 蓝牙设备状态改变的回调
- (void) didChangeState:(CBCentralManagerState) newState
{
    NSLog(@"\nStep4");
    DebugLog(@"state changed: %ld", (long)newState);
    
    if (newState == CBCentralManagerStatePoweredOn)
    {
        if (self.peripheral == nil)
        {
            [[BluetoothLEManager sharedManager] discoverDevices];
        }
    }
    else
    {
        self.peripheral = nil;
    }
    [self setupConnectButton];
}

- (void) didUpdateValue:(BluetoothLEService *) service forServiceUUID:(CBUUID *) serviceUUID withCharacteristicUUID:(CBUUID *) characteristicUUID withData:(NSData *) data
{
    NSLog(@"\nStep5");
    const uint8_t *reportData = [data bytes];
    
    NSString *str = @"";
    
    for (int i=0; i<8; i++) {
        if (i == 0) {
            str = [NSString stringWithFormat:@"0x%@ ", [self ToDualNum:[self ToHex:reportData[i]]]];
        } else {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@ ", [self ToDualNum:[self ToHex:reportData[i]]]]];
        }
    }
    NSLog(@"STR : %@",str);
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

- (void)setupConnectButton
{
    DebugLog(@"\nStep7");
    
    if ([[PrivateValues getValueForKey:PLIST_VALUE_BLE] isEqualToString:@"NO"]){
        if (self.peripheral.state == CBPeripheralStateConnected) {
            [[BluetoothLEManager sharedManager] disconnectPeripheral:self.peripheral];
            self.peripheral = nil;
        }
    }
    
    //A150101001 Andy
    if (self.peripheral.state == CBPeripheralStateConnected) {
        if (myTime == nil) {
            myTime = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(standbySend) userInfo:nil repeats:YES];
        }
    } else {
        [myTime invalidate];
        myTime = nil;
    }
    
    if (self.peripheral.state == CBPeripheralStateConnected) {
       
        NSString * string = [NSString stringWithFormat:@"Connected - %@",self.peripheral.name];

        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        
    } else {
        [activityIndicator startAnimating];
        
        if ([[PrivateValues getValueForKey:PLIST_VALUE_BLE] isEqualToString:@"YES"]) {
            
            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"Disconnected..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            
        }
    }
}
- (void)sendSend:(NSString *)command
{
    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        //返回索引(某个值,比如i)所在的Unicode字符  - (unichar)characterAtIndex:(NSUInteger)index;
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    
    if (self.peripheral != nil){
        if (self.peripheral.state == CBPeripheralStateConnected) {
            if (![self.peripheral.name isEqualToString:@"QSPOWER BLE"]){
                [self.service setValue:commandToSend forServiceUUID:@"0xFFF0" andCharacteristicUUID:@"0xFFF1"];
            } else {
                [self.service setValue:commandToSend forServiceUUID:@"0000FEE9-0000-1000-8000-00805F9B34FB" andCharacteristicUUID:@"D44BC439-ABFD-45A2-B575-925416129600"];
            }
        } else {
            DebugLog(@"DisConnect!!");
        }
    }
}


- (NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}

- (NSString *)ToDualNum:(NSString *)hexStr
{
    NSString *str = @"";
    
    if ([hexStr length] == 1) {
        str = [NSString stringWithFormat:@"0%@",hexStr];
    } else {
        str = hexStr;
    }
    
    return str;
}

//隱藏keyboard
- (void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
}


- (void)standbySend
{
    NSString *strC = @"60";
    NSString *strM = @"10";
    //這裏模式固定 0x10
    NSString *sendStr = [NSString stringWithFormat:@"5505%@%@000000", strC, strM];
    
    [self sendSend:sendStr];
}

- (void)dataSend
{
    
    NSString *strC  = self.txtCustomer.text;
    
    NSString *strM1 = self.txtMode.text;
    NSString *strM2 = self.txtMode2.text;
    NSString *strM3 = self.txtMode3.text;
    
    NSString *strS  = self.txtStrength.text;
    NSString *strS2 = self.txtStrength2.text;
    NSString *strS3 = self.txtStrength3.text;
    
    NSString *sendStr = [NSString stringWithFormat:@"5509%@%@%@%@%@%@%@%@%@",strC, strCust2, strMode, strM1, strS, strM2, strS2, strM3, strS3];
    
    [self sendSend:sendStr];
}

- (int)HexInt:(NSString *)strint
{
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:strint];
    [scanner scanHexInt:&outVal]; //将十六进制格式字符串转成数字
    NSLog(@"%d", outVal);
    
    return outVal;
}

-(void)createUI
{
    CGFloat width = (Screen_width - 100 - 90)/3;
    CGFloat width1 = (Screen_width - 40 - 100)/3;
    UILabel * CustomerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 120, 30)];
    CustomerLabel.text = @"Customer ID";
//    CustomerLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:CustomerLabel];
    
    self.txtCustomer = [[UITextField alloc]initWithFrame:CGRectMake(CustomerLabel.frame.origin.x + CustomerLabel.frame.size.width + 10, CustomerLabel.frame.origin.y, 50, 30)];
    self.txtCustomer.text = @"60";
    self.txtCustomer.enabled = NO;
    self.txtCustomer.borderStyle = UITextBorderStyleRoundedRect;
    self.txtCustomer.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.txtCustomer];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, CustomerLabel.frame.origin.y+CustomerLabel.frame.size.height + 30, 80, 30)];
//    label1.backgroundColor = [UIColor redColor];
    label1.text = @"Mode";
    [self.view addSubview:label1];
    
    for (int i = 1; i < 4; i++) {
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.size.width + label1.frame.origin.x + 20  + (width + 30)* (i - 1), CustomerLabel.frame.origin.y+CustomerLabel.frame.size.height + 5, width, 20)];
//        lab1.backgroundColor = [UIColor greenColor];
        lab1.text = [NSString stringWithFormat:@"%d",i];
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:lab1];
    }
    self.txtMode = [[UITextField alloc]initWithFrame:CGRectMake(label1.frame.size.width + label1.frame.origin.x + 20  , label1.frame.origin.y, width, 30)];
    self.txtMode.borderStyle = UITextBorderStyleRoundedRect;
    self.txtMode.text = [NSString stringWithFormat:@"%d",01];
    self.txtMode.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.txtMode];
    
    self.txtMode2 = [[UITextField alloc]initWithFrame:CGRectMake(label1.frame.size.width + label1.frame.origin.x + 20  + (width + 30), label1.frame.origin.y, width, 30)];
    self.txtMode2.borderStyle = UITextBorderStyleRoundedRect;
    self.txtMode2.text = [NSString stringWithFormat:@"%d",01];
    self.txtMode2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.txtMode2];
    
    self.txtMode3 = [[UITextField alloc]initWithFrame:CGRectMake(label1.frame.size.width + label1.frame.origin.x + 20  + (width + 30)* 2, label1.frame.origin.y, width, 30)];
    self.txtMode3.borderStyle = UITextBorderStyleRoundedRect;
    self.txtMode3.text = [NSString stringWithFormat:@"%d",00];
    self.txtMode3.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.txtMode3];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1.frame.origin.y+label1.frame.size.height + 30, 80, 30)];
//    label2.backgroundColor = [UIColor redColor];
    label2.text = @"Strength";
    [self.view addSubview:label2];
    
    for (int i = 1; i < 4; i++) {
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(label2.frame.size.width + label2.frame.origin.x + 20  + (width + 30)* (i - 1), label1.frame.origin.y+label1.frame.size.height + 5, width, 20)];
//        lab1.backgroundColor = [UIColor greenColor];
        lab1.text = [NSString stringWithFormat:@"%d",i];
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:lab1];
    }
    
    self.txtStrength = [[UITextField alloc]initWithFrame:CGRectMake(label2.frame.size.width + label2.frame.origin.x + 20  , label2.frame.origin.y, width, 30)];
    self.txtStrength.borderStyle = UITextBorderStyleRoundedRect;
    self.txtStrength.text = [NSString stringWithFormat:@"%d",00];
    self.txtStrength.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.txtStrength];
    
    self.txtStrength2 = [[UITextField alloc]initWithFrame:CGRectMake(label2.frame.size.width + label2.frame.origin.x + 20  + (width + 30), label2.frame.origin.y, width, 30)];
    self.txtStrength2.borderStyle = UITextBorderStyleRoundedRect;
    self.txtStrength2.text = [NSString stringWithFormat:@"%d",00];
    self.txtStrength2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.txtStrength2];
    
    self.txtStrength3 = [[UITextField alloc]initWithFrame:CGRectMake(label2.frame.size.width + label2.frame.origin.x + 20  + (width + 30)* 2, label2.frame.origin.y, width, 30)];
    self.txtStrength3.borderStyle = UITextBorderStyleRoundedRect;
    self.txtStrength3.text = [NSString stringWithFormat:@"%d",00];
    self.txtStrength3.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.txtStrength3];
    
    
    NSArray * arr = @[@"Send",@"Pause",@"Scan",@"Receive",@"Clear",@"Stop"];
    self.btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSend.frame = CGRectMake(20 + (width1 + 50) * 0, label2.frame.origin.y + label2.frame.size.height + (50 * 0) + 20, width1, 30);
//    self.btnSend.backgroundColor = [UIColor blueColor];
    [self.btnSend setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnSend setTitle:[arr objectAtIndex:0 * 3 + 0] forState:UIControlStateNormal];
    [self.btnSend addTarget:self action:@selector(btnSend_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSend];
    
    self.btnPause = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnPause.frame = CGRectMake(20 + (width1 + 50) * 1, label2.frame.origin.y + label2.frame.size.height + (50 * 0) + 20, width1, 30);
//    self.btnPause.backgroundColor = [UIColor blueColor];
    [self.btnPause setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnPause setTitle:[arr objectAtIndex:0 * 3 + 1] forState:UIControlStateNormal];
    [self.btnPause addTarget:self action:@selector(btnPause_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnPause];
    
    self.btnScan = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnScan.frame = CGRectMake(20 + (width1 + 50) * 2, label2.frame.origin.y + label2.frame.size.height + (50 * 0) + 20, width1, 30);
//    self.btnScan.backgroundColor = [UIColor blueColor];
    [self.btnScan setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnScan setTitle:[arr objectAtIndex:0 * 3 + 2] forState:UIControlStateNormal];
    [self.btnScan addTarget:self action:@selector(btnScan_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnScan];
    
    self.btnReceive = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnReceive.frame = CGRectMake(20 + (width1 + 50) * 0, label2.frame.origin.y + label2.frame.size.height + (50 * 1) + 20, width1 + 5, 30);
//    self.btnReceive.backgroundColor = [UIColor blueColor];
    [self.btnReceive setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnReceive setTitle:[arr objectAtIndex:1 * 3 + 0] forState:UIControlStateNormal];
    [self.btnReceive addTarget:self action:@selector(btnReceive_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnReceive];
    
    self.btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnClear.frame = CGRectMake(20 + (width1 + 50) * 1, label2.frame.origin.y + label2.frame.size.height + (50 * 1) + 20, width1, 30);
//    self.btnClear.backgroundColor = [UIColor blueColor];
    [self.btnClear setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnClear setTitle:[arr objectAtIndex:1 * 3 + 1] forState:UIControlStateNormal];
    [self.btnClear addTarget:self action:@selector(btnClear_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnClear];
    
    self.btnStop = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnStop.frame = CGRectMake(20 + (width1 + 50) * 2, label2.frame.origin.y + label2.frame.size.height + (50 * 1) + 20, width1, 30);
//    self.btnStop.backgroundColor = [UIColor blueColor];
    [self.btnStop setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnStop setTitle:[arr objectAtIndex:1 * 3 + 2] forState:UIControlStateNormal];
    [self.btnStop addTarget:self action:@selector(btnStop_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnStop];
    
    self.txtMsg = [[UITextView alloc]initWithFrame:CGRectMake(20, label2.frame.size.height + label2.frame.origin.y + 120, Screen_width - 40, Screen_height - (label2.frame.size.height + label2.frame.origin.y + 120) - 60)];
//    self.txtMsg.backgroundColor = [UIColor redColor];
    self.txtMsg.text = @"Message...";
    [self.view addSubview:self.txtMsg];
    
    self.labMsg = [[UILabel alloc]initWithFrame:CGRectMake(60, self.txtMsg.frame.size.height + self.txtMsg.frame.origin.y + 15, Screen_width - 40, 30)];
    self.labMsg.text = @"message...";
    [self.view addSubview:self.labMsg];
}

-(void)showLeft
{
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
    [dd showLeftController:YES];
}


@end
