//
//  SingleViewController.m
//  quxiangtou
//
//  Created by mac on 15/12/7.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "SingleViewController.h"
#import "PICircularProgressView.h"

@interface SingleViewController ()<progressSize>{
    //A141230001 Andy
    NSTimer *myTime;
    BOOL isWorking;
    NSInteger clickButton;
}
@property (nonatomic, assign) CBPeripheral *peripheral;
@property (nonatomic, strong) BluetoothLEService *service;

@property (strong, nonatomic) PICircularProgressView *progressView;
@property (nonatomic,strong) UIButton * GentleForeplayButton;
@property (nonatomic,strong) UIButton * NineDepthButton;
@property (nonatomic,strong) UIButton * LeftAndRightButton;
@property (nonatomic,strong) UIButton * HappyPeakButton;
@property (nonatomic,strong) NSString * strength;

@end

@implementation SingleViewController

int tTimers = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateMessageLabel:) name:@"peripheral" object:nil];
        //updateAvatar
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isWorking = NO;
    _strength = @"50";
    NSLog(@"self.peripheral = %@",self.peripheral);
    NSLog(@"self.peripheral.name = %@",self.peripheral.name);
    //A150706001 Andy
    if (![self.peripheral.name isEqualToString:@"QSPOWER BLE"]){
        self.service = [[BluetoothLEService alloc] initWithPeripheral:self.peripheral withServiceUUIDs:@[@"0xFFF0"] delegate:self];
    } else {
        self.service = [[BluetoothLEService alloc] initWithPeripheral:self.peripheral withServiceUUIDs:@[@"0000FEE9-0000-1000-8000-00805F9B34FB"] delegate:self];
    }
    [self.service discoverServices];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"顶操04@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
    self.navigationItem.title = @"单人娱乐";
    
    [self createUI];
}
- (void) didDiscoverCharacterisics:(BluetoothLEService *) service
{
    NSLog(@"\nStep6");
    NSLog(@"自娱自乐 = %@",service);
    //A150706001 Andy
    if (![self.peripheral.name isEqualToString:@"QSPOWER BLE"]){
        [service startNotifyingForServiceUUID:@"0xFFF0" andCharacteristicUUID:@"0xFFF4"];
    } else {
        [service startNotifyingForServiceUUID:@"0000FEE9-0000-1000-8000-00805F9B34FB" andCharacteristicUUID:@"D44BC439-ABFD-45A2-B575-925416129601"];
    }
    
    DebugLog(@"finished discovering: %@", service);
}

-(void)createUI
{
    self.progressView = [[PICircularProgressView alloc]init];
    self.progressView.frame = CGRectMake((Screen_width - 200) /2, 100, 200, 182);
    self.progressView.delegate = self;
    self.progressView.progress = 0.5;
    
    self.progressView.progressFillColor = nil;
    self.progressView.userInteractionEnabled = YES;
    self.progressView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.progressView];
    NSLog(@"self.progressView.progress = %lf",self.progressView.progress);
    CGFloat width = (Screen_width - 30 * 4)/3;
    
    self.GentleForeplayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.GentleForeplayButton.frame = CGRectMake(30, self.progressView.frame.size.height + self.progressView.frame.origin.y + 20, width, width);
    [self.GentleForeplayButton setImage:[[UIImage imageNamed:@"温柔前戏@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.GentleForeplayButton.tag = 100;
    [self.GentleForeplayButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.GentleForeplayButton];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(self.GentleForeplayButton.frame.origin.x, self.GentleForeplayButton.frame.size.height + self.GentleForeplayButton.frame.origin.y + 5, width, 20)];
    label1.text = @"温柔前戏";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label1];
    
    self.NineDepthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.NineDepthButton.frame = CGRectMake(30 * 2 + width * 1, self.progressView.frame.size.height + self.progressView.frame.origin.y + 20, width, width);
    [self.NineDepthButton setImage:[[UIImage imageNamed:@"九浅一深@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.NineDepthButton.tag = 101;
    [self.NineDepthButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.NineDepthButton];
        
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(self.NineDepthButton.frame.origin.x, self.GentleForeplayButton.frame.size.height + self.GentleForeplayButton.frame.origin.y + 5, width, 20)];
    label2.text = @"九浅一深";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label2];
    
    self.LeftAndRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.LeftAndRightButton.frame = CGRectMake(30 * 3 + width * 2, self.progressView.frame.size.height + self.progressView.frame.origin.y + 20, width, width);
    [self.LeftAndRightButton setImage:[[UIImage imageNamed:@"左右往返@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.LeftAndRightButton.tag = 102;
    [self.LeftAndRightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.LeftAndRightButton];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(self.LeftAndRightButton.frame.origin.x, self.GentleForeplayButton.frame.size.height + self.GentleForeplayButton.frame.origin.y + 5, width, 20)];
    label3.text = @"左右往返";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label3];
    
    self.HappyPeakButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HappyPeakButton.frame = CGRectMake(30 , label3.frame.size.height + label3.frame.origin.y + 10, width, width);
    [self.HappyPeakButton setImage:[[UIImage imageNamed:@"快了巅峰@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.HappyPeakButton.tag = 103;
    [self.HappyPeakButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.HappyPeakButton];
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(self.HappyPeakButton.frame.origin.x, self.HappyPeakButton.frame.size.height + self.HappyPeakButton.frame.origin.y + 5, width, 20)];
    label4.text = @"快乐巅峰";
    label4.textAlignment = NSTextAlignmentCenter;
    label4.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label4];
    
    
}
-(void)updateMessageLabel:(NSNotification *)noti
{
    CBPeripheral * per = [noti.object objectForKey:@"peripheral"];
    self.peripheral = per;
    NSLog(@"self.peripheral = %@",self.peripheral.name);
}
-(void)buttonClick:(UIButton *)button
{
    clickButton = button.tag;
    if (button.tag == 100) {
        if (isWorking == NO) {
            isWorking = YES;
            [self dataSend];
            //停止連線時的訊號
            [myTime invalidate];
            myTime = nil;
            
            //    strMode = @"40";
            if (myTime == nil) {
                myTime = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(dataSend) userInfo:nil repeats:YES];
            }

        }
        
    }
    if (button.tag == 101) {
        if (isWorking == NO) {
            isWorking = YES;
            [self dataSend];
            //停止連線時的訊號
            [myTime invalidate];
            myTime = nil;
            
            //    strMode = @"40";
            if (myTime == nil) {
                myTime = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(dataSend) userInfo:nil repeats:YES];
            }
            
        }
    }
    if (button.tag == 102) {
        if (isWorking == NO) {
            isWorking = YES;
            [self dataSend];
            //停止連線時的訊號
            [myTime invalidate];
            myTime = nil;
            
            //    strMode = @"40";
            if (myTime == nil) {
                myTime = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(dataSend) userInfo:nil repeats:YES];
            }
            
        }
       
    }
    if (button.tag == 103) {
        if (isWorking == NO) {
            isWorking = YES;
            [self dataSend];
            //停止連線時的訊號
            [myTime invalidate];
            myTime = nil;
            
            //    strMode = @"40";
            if (myTime == nil) {
                myTime = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(dataSend) userInfo:nil repeats:YES];
            }
            
        }
       
    }
}
- (void)dataSend
{
    NSString * sendStr = nil;
    if (clickButton == 100) {
        sendStr = [NSString stringWithFormat:@"5509%@%@%@%@%@%@%@%@%@",@"60",@"61",@"40", @"01", @"16", @"01",@"16",@"00", @"00"];
    }
    if (clickButton == 101) {
        sendStr = [NSString stringWithFormat:@"5509%@%@%@%@%@%@%@%@%@",@"60",@"61",@"40", @"01", @"0F", @"03",@"22",@"00", @"00"];
    }
    if (clickButton == 102) {
        sendStr = [NSString stringWithFormat:@"5509%@%@%@%@%@%@%@%@%@",@"60",@"61",@"40", @"01", @"0F", @"06",@"0F",@"00", @"00"];
    }
    if (clickButton == 103) {
        sendStr = [NSString stringWithFormat:@"5509%@%@%@%@%@%@%@%@%@",@"60",@"61",@"40", @"01", @"11", @"09",@"23",@"00", @"00"];
    }
    
    [self sendSend:sendStr];
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
        DebugLog(@"%@", commandToSend);
        if (self.peripheral.state == CBPeripheralStateConnected) {
            //A141129001 Andy
            if (tTimers < 10){
                DebugLog(@"Send Data");
            } else {
                tTimers = 0;
            }
            tTimers++;
            
            //A150706001 Andy
            if (![self.peripheral.name isEqualToString:@"QSPOWER BLE"]){
                [self.service setValue:commandToSend forServiceUUID:@"0xFFF0" andCharacteristicUUID:@"0xFFF1"];
            } else {
                [self.service setValue:commandToSend forServiceUUID:@"0000FEE9-0000-1000-8000-00805F9B34FB" andCharacteristicUUID:@"D44BC439-ABFD-45A2-B575-925416129600"];
            }
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

-(void)showLeft
{
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
    [dd showLeftController:YES];
}
-(void)getProgressSize:(NSString *)size
{
    _strength = size;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.peripheral != nil) {
        [[BluetoothLEManager sharedManager] disconnectPeripheral:self.peripheral];
    }
    [PrivateValues saveValue:@"NO" forKey:PLIST_VALUE_BLE];
    self.peripheral = nil;
    self.service = nil;
    [myTime invalidate];
    myTime = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    
}
@end
