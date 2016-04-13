//
//  sendDataViewController.m
//  quxiangtou
//
//  Created by mac on 15/12/28.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "sendDataViewController.h"
#import "AVOSCloudIM.h"
#import "IMOperationMessage.h"
#import "PICircularProgressView.h"

@interface sendDataViewController ()<AVIMClientDelegate,ASIHTTPRequestDelegate,progressSize,UIAlertViewDelegate>
{
    AVIMConversation * mConversation;
    NSMutableArray * pairedArray;
    UIButton * button;
    UIButton * button1;
    ASIFormDataRequest * uploadPairedRequest;
    
    NSString * dataString;
    NSTimer *myTime;
    
    
}
@property (strong, nonatomic) PICircularProgressView *progressView;
@property (nonatomic,strong) UIButton * GentleForeplayButton;
@property (nonatomic,strong) UIButton * NineDepthButton;
@property (nonatomic,strong) UIButton * LeftAndRightButton;
@property (nonatomic,strong) UIButton * HappyPeakButton;
@property (nonatomic,strong) NSString * strength;

@property (nonatomic, assign) CBPeripheral *peripheral;
@property (nonatomic, strong) BluetoothLEService *service;


@end

@implementation sendDataViewController

int Timers = 0;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.hidesBottomBarWhenPushed = YES;
//        self.navigationController.navigationBarHidden=NO;
        _dic = [[NSDictionary alloc]init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateMessageLabel:) name:@"peripheral" object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    pairedArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setImage:[[UIImage imageNamed:@"顶操04@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 50, 39);
    [backButton addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,btn_right, nil];
    self.navigationItem.title = [_dic objectForKey:@"nickname"];
    
    [self uploadPaired];
    [self createUI];
   
     // 获取聊天信息
     AVIMClient * client = [AVIMClient defaultClient];
     client.delegate = self;
     [client openWithClientId:[[ACommenData sharedInstance].logDic objectForKey:@"uuid"] callback:^(BOOL succeeded, NSError *error) {
     if (error != nil) {
         NSLog(@"%@",error.localizedDescription);
         return;
     }
         NSLog(@"uuid = %@",[_dic objectForKey:@"uuid"]);
         AVIMConversationQuery * query = [client conversationQuery];
         [query whereKey:@"m" containsAllObjectsInArray:@[[[ACommenData sharedInstance].logDic objectForKey:@"uuid"],[_dic objectForKey:@"uuid"]]];
         [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
             if (objects.count > 0) {
                 //已经建立过对话，使用第一个
                 mConversation = (AVIMConversation *)[objects firstObject];
             }else{
                 //没有建立过对话
                 [client createConversationWithName:@"我的设备" clientIds:@[[_dic objectForKey:@"uuid"]] callback:^(AVIMConversation *conversation, NSError *error) {
                     if (error != nil) {
                         NSLog(@"建立对话 error = %@",error.localizedDescription);
                     }else{
                         mConversation = conversation;
                     }
                 }];
             }
         }];
     }];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.peripheral == nil) {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有连接设备,请到设备模块连接设备!" delegate:self cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
    }else{
        //A150706001 Andy
        if (![self.peripheral.name isEqualToString:@"QSPOWER BLE"]){
            self.service = [[BluetoothLEService alloc] initWithPeripheral:self.peripheral withServiceUUIDs:@[@"0xFFF0"] delegate:self];
        } else {
            self.service = [[BluetoothLEService alloc] initWithPeripheral:self.peripheral withServiceUUIDs:@[@"0000FEE9-0000-1000-8000-00805F9B34FB"] delegate:self];
        }
        [self.service discoverServices];
    }
    
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
/*!
 接收到新的普通消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMTypedMessage *)message
{
    switch (message.mediaType) {
        case 1:{
            NSString * str = [NSString stringWithFormat:@"对方传过来的蓝牙数据%@，是否要连接蓝牙",message.text];
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:self cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"确定", nil ];
            alert.tag = 109;
            [alert show];
            dataString = message.text;
            
        }
            break;
        default:
            break;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 109) {
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            if (self.peripheral != nil && self.service != nil) {
                //停止連線時的訊號
                [myTime invalidate];
                myTime = nil;
                
                //    strMode = @"40";
                if (myTime == nil) {
                    myTime = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(dataSend) userInfo:nil repeats:YES];
                }
            }else{
                UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有连接设备,请到设备模块连接设备!" delegate:self cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil, nil ];
                [alert show];
            }
            

        }
    }
}
-(void)buttonClick:(UIButton *)clickButton
{
    NSString * sendStr = nil;
    if (clickButton.tag == 100) {
        //        sendStr = [NSString stringWithFormat:@"5509%@%@%@%@%@%@%@%@%@",@"60",@"61",@"40", @"01", _strength, @"01",_strength,@"00", @"00"];
        sendStr = [NSString stringWithFormat:@"5509%@%@%@%@%@%@%@%@%@",@"60",@"61",@"40", @"01", @"16", @"01",@"16",@"00", @"00"];
    }
    if (clickButton.tag == 101) {
        sendStr = [NSString stringWithFormat:@"5509%@%@%@%@%@%@%@%@%@",@"60",@"61",@"40", @"01", @"0F", @"03",@"22",@"00", @"00"];
    }
    if (clickButton.tag == 102) {
        sendStr = [NSString stringWithFormat:@"5509%@%@%@%@%@%@%@%@%@",@"60",@"61",@"40", @"01", @"0F", @"06",@"0F",@"00", @"00"];
    }
    if (clickButton.tag == 103) {
        sendStr = [NSString stringWithFormat:@"5509%@%@%@%@%@%@%@%@%@",@"60",@"61",@"40", @"01", @"11", @"09",@"23",@"00", @"00"];
    }

    [self sendMessage:sendStr];
}
-(void)sendMessage:(NSString *)string
{
    IMOperationMessage * message = [IMOperationMessage messageWithText:string attributes:nil];
    [mConversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [pairedArray  addObject:string];
            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"消息发送成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }
    }];
    
}
-(void)createUI
{
    self.progressView = [[PICircularProgressView alloc]init];
    self.progressView.frame = CGRectMake((Screen_width - 200) /2, 100 - 64, 200, 182);
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
-(void)getProgressSize:(NSString *)size
{
    _strength = size;
}
-(void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma 设备连接上之后的通知方法实现
-(void)updateMessageLabel:(NSNotification *)noti
{
    CBPeripheral * per = [noti.object objectForKey:@"peripheral"];
    self.peripheral = per;
    NSLog(@"self.peripheral = %@",self.peripheral.name);
}

#pragma mark - 接受到消息之后，给蓝牙发送数据
- (void)dataSend
{
    [self sendSend:dataString];
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
            if (Timers < 10){
                DebugLog(@"Send Data");
            } else {
                Timers = 0;
            }
            Timers++;
            
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

#pragma mark - 上传配对记录
-(void)uploadPaired
{
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:[_dic objectForKey:@"uuid"],@"uuid", nil];
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString * urlStr = [NSString stringWithFormat:@"%@logs/pair?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid"]];
        
        NSURL * url = [NSURL URLWithString:urlStr];
        uploadPairedRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [uploadPairedRequest setRequestMethod:@"POST"];
        [uploadPairedRequest setDelegate:self];
        
        //1、header
        [uploadPairedRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //2、header
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        NSLog(@"配对历史 Authorization%@",Authorization);
        [uploadPairedRequest addRequestHeader:@"Authorization" value:Authorization];
        
        [uploadPairedRequest setPostBody:tempJsonData];
        [uploadPairedRequest startAsynchronous];
    }
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSLog(@"登录放回data = %@",dic);
    int statusCode = [request responseStatusCode];
    NSLog(@"登录 statusCode %d",statusCode);
    if (statusCode == 201 ) {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"配对历史上传成功" delegate:self cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
        
    }else{
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[[dic valueForKey:@"errors"] objectForKey:@"code"]delegate:self cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    //提示警告框失败...
    MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = [request responseString];
    
    HUD.detailsLabelText = @"请检查网络连接";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2.0);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.peripheral != nil) {
        [[BluetoothLEManager sharedManager] disconnectPeripheral:self.peripheral];
    }
    
    self.peripheral = nil;
    self.service = nil;
    [myTime invalidate];
    myTime = nil;
    [uploadPairedRequest cancel];
    uploadPairedRequest = nil;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
