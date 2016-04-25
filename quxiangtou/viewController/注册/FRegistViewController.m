//
//  FRegistViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/7/24.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "FRegistViewController.h"
#import "loginViewController.h"
#import "SRViewController.h"
#import "XieYiViewController.h"
#import"AppDelegate.h"
#import "LoginModel.h"

////-fno-objc-arc
//-fobjc-arc
@interface FRegistViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,ASIHTTPRequestDelegate>
{
    BOOL isAgree;
    UIButton * agreeImage;
    UIButton * _newButton;
    int time;
    NSTimer * timer;
}
@property (nonatomic,strong) UITextField * passwordField;
@property (nonatomic,strong) UITextField * phoneField;
@property (nonatomic,strong) UITextField * yanzmField;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) ASIFormDataRequest * registerRequest;
@property (nonatomic,strong) ASIFormDataRequest * yzmRequest;
@end

@implementation FRegistViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isAgree = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = color(239, 239, 244);
    [self createNav];
    [self createUI];
    
}
#pragma  mark - 自定义状态栏
-(void)createNav
{
    UIView * navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64)];
    navigationView.userInteractionEnabled = YES;
    navigationView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    [self.view addSubview:navigationView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width / 2 -40, 30, 80, 30)];
    titleLabel.text = @"注册";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navigationView addSubview:titleLabel];
    
    UIView * view = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, Screen_width, 1)];
    view.backgroundColor = color_alpha(222, 222, 222, 1);
    [navigationView addSubview:view];
    
}
#pragma  mark - UI
-(void)createUI
{
    UIView * view4 = [[UIView alloc]initWithFrame:CGRectMake(0, 120,Screen_width, 1)];
    view4.backgroundColor = color_alpha(222, 222, 222, 1);
    view4.userInteractionEnabled = YES;
    [self.view addSubview:view4];
    
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0, view4.frame.size.height+view4.frame.origin.y,Screen_width, 40)];
    view3.backgroundColor = [UIColor whiteColor];
    view3.userInteractionEnabled = YES;
    [self.view addSubview:view3];
    
    _phoneField = [[UITextField alloc] init];
    
    _phoneField.frame=CGRectMake(10, 0,Screen_width - 10, 40);
    _phoneField.backgroundColor=[UIColor whiteColor];
    _phoneField.delegate=self;
    _phoneField.placeholder=@"请输入你的手机号";
    _phoneField.textColor=[UIColor grayColor];
    _phoneField.font = [UIFont systemFontOfSize:15];
    _phoneField.keyboardType=UIKeyboardTypeNumberPad;
    [view3 addSubview:_phoneField
     ];
    
    
    UIView * view5 = [[UIView alloc]initWithFrame:CGRectMake(0, view3.frame.size.height+view3.frame.origin.y,Screen_width, 1)];
    view5.backgroundColor = color_alpha(222, 222, 222, 1);
    view5.userInteractionEnabled = YES;
    [self.view addSubview:view5];
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view5.frame.size.height+view5.frame.origin.y, Screen_width, 40)];
    view2.backgroundColor = [UIColor whiteColor];
    view2.userInteractionEnabled = YES;
    [self.view addSubview:view2];
    _passwordField = [[UITextField alloc] init];
    _passwordField.frame=CGRectMake(10, 0, Screen_width - 10 , 40);
    _passwordField.backgroundColor=[UIColor whiteColor];
    _passwordField.delegate=self;
    _passwordField.secureTextEntry = YES;
    _passwordField.textColor=[UIColor grayColor];
    _passwordField.font = [UIFont systemFontOfSize:15];
    _passwordField.placeholder=@"设置密码";
    [view2 addSubview:_passwordField];
    
    UIView * view6 = [[UIView alloc]initWithFrame:CGRectMake(0, view2.frame.size.height + view2.frame.origin.y,Screen_width, 1)];
    view6.backgroundColor = color_alpha(222, 222, 222, 1);
    [self.view addSubview:view6];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, view6.frame.size.height+view6.frame.origin.y, Screen_width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    [self.view addSubview:view];
    
    _yanzmField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, view.frame.size.width - 10 - 180, view.frame.size.height)];
    _yanzmField.placeholder = @"请输入验证码";
    _yanzmField.backgroundColor=[UIColor whiteColor];
    _yanzmField.delegate=self;
    _yanzmField.textColor = [UIColor grayColor];
    _yanzmField.font = [UIFont systemFontOfSize:15];
    [view addSubview:_yanzmField];
    
    
    _newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _newButton.frame = CGRectMake(Screen_width - 170,_yanzmField.frame.origin.y + 5  , 160, 30);
    [_newButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    _newButton.titleLabel.font = [UIFont systemFontOfSize:20];
    _newButton.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:169.0/255.0 blue:255.0/255.0 alpha:1];
    _newButton.layer.cornerRadius = 6;
    _newButton.layer.masksToBounds = YES;
    _newButton.tag = 2;
    _newButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_newButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_newButton];
    
    UIView * view7 = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height + view.frame.origin.y,Screen_width, 1)];
    view7.backgroundColor = color_alpha(222, 222, 222, 1);
    [self.view addSubview:view7];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, view7.frame.origin.y+view7.frame.size.height + 10, Screen_width - 40, 40);
    button.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:169.0/255.0 blue:255.0/255.0 alpha:1];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTitle:@"注册" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    NSString * string = [NSString stringWithFormat:@"%@",@"注册表示您已经同意"];
    UILabel * agreeLable = [[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.size.height + button.frame.origin.y + 10, 138, 20)];
    agreeLable.text = string;
    agreeLable.textColor = color_alpha(120, 121, 122, 1);
    agreeLable.font = [UIFont systemFontOfSize:14];
    agreeLable.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:agreeLable];
    
    
    NSString * xieyi = [NSString stringWithFormat:@"%@",@"趣相投服务使用协议"];
    UIButton * xieyiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    xieyiButton.frame = CGRectMake(agreeLable.frame.origin.x + agreeLable.frame.size.width, agreeLable.frame.origin.y, 142, 20);
    [xieyiButton setTitle:xieyi forState:UIControlStateNormal];
    xieyiButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [xieyiButton setTitleColor:[UIColor colorWithRed:47.0/255.0 green:120.0/255.0 blue:200.0/255.0 alpha:1] forState:UIControlStateNormal];
    [xieyiButton addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xieyiButton];
    
    UIButton * loginButton =[UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(0, Screen_height - 49, Screen_width, 49);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        loginButton.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:169.0/255.0 blue:255.0/255.0 alpha:1];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}
#pragma  mark - 登录按钮的点击事件
-(void)loginClick
{
    loginViewController * login = [[loginViewController alloc]init];
    [self presentViewController:login animated:YES completion:nil];
}
#pragma mark - 获取验证码按钮的点击事件
-(void)buttonClick:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"发送验证码"]) {
        
        if (time != 0) {
            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证码已经发送到您的手机上,请注意查收!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }else{
            [self getYanzhengma];
        }
    }else{
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证码已经发送到您的手机上,请注意查收!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
}
-(void)getYanzhengma
{
    if (_phoneField.text.length != 11) {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"手机号位数错误!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
        
    }else if ([ACommenData validatePhone:_phoneField.text]== NO){
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"手机号格式不正确!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
    }else{
        
        time=120;
        //获取验证码接口  获取成功
        timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ytTimerClick) userInfo:nil repeats:YES];
        
        NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:@"sign_up",@"type",_phoneField.text,@"mobile", nil];
        if ([NSJSONSerialization isValidJSONObject:user]) {
            NSError * error;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
            NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
            NSString * yzm = [NSString stringWithFormat:@"%@sms?udid=%@",URL_HOST,[[DeviceInfomationShare share] UUID]];
            NSURL * url = [NSURL URLWithString:yzm];
            NSLog(@"注册获取验证码 %@",url);
            _yzmRequest = [[ASIFormDataRequest alloc]initWithURL:url];
            [_yzmRequest setRequestMethod:@"POST"];
            [_yzmRequest setDelegate:self];
            _yzmRequest.tag = 101;
            [_yzmRequest addRequestHeader:@"Content-Type" value:@"application/json"];
            [_yzmRequest setPostBody:tempJsonData];
            [_yzmRequest startAsynchronous];
        }
    }
}
#pragma  mark - 协议的点击事件
-(void)tap:(UIButton *)tap
{
    XieYiViewController * xyv = [[XieYiViewController alloc]init];
    [self presentViewController:xyv animated:YES completion:nil];
}
#pragma  mark - 注册按钮的点击事件
-(void)registerClick:(UIButton *)button
{
//    SRViewController * srv = [[SRViewController alloc]init];
//    [self presentViewController:srv animated:YES completion:nil];
        //获取验证码之后登录
    if([_yanzmField.text isNotEmpty])
    {
        if (![_passwordField.text isNotEmpty]){
            
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"密码为空,请输入密码!"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
        }else{
            NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:_phoneField.text,@"mobile",_passwordField.text,@"password",_yanzmField.text,@"captcha", nil];
            if ([NSJSONSerialization isValidJSONObject:user]) {
                NSError * error;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
                NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
                NSString * urlStr = [NSString stringWithFormat:@"%@users?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid"]];
                NSURL * url = [NSURL URLWithString:urlStr];
                _registerRequest = [[ASIFormDataRequest alloc]initWithURL:url];
                [_registerRequest setRequestMethod:@"POST"];
                [_registerRequest setDelegate:self];
                [_registerRequest addRequestHeader:@"Content-Type" value:@"application/json"];
                _registerRequest.tag = 100;
                [_registerRequest setPostBody:tempJsonData];
                [_registerRequest startAsynchronous];
            }
            
        }
        
    }else{
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"请输入验证码之后，再点击\"确定\"验证手机号!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
        
        [_newButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        
        
    }
  
}

#pragma  mark - ASI的请求回调方法
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSLog(@"注册第一页 responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    NSLog(@"注册第一页 statusCode %d",statusCode);
    
    if (request.tag == 100) {
        if (statusCode == 201 ) {
            
            NSString * auth_token =[dic valueForKey:@"data"]; //将登陆返回的数据存到一个字典对象里面...
            NSLog(@"注册第一页 auth_token %@",auth_token);
            [[NSUserDefaults standardUserDefaults]setObject:auth_token forKey:@"auth_token"];
            [[NSUserDefaults standardUserDefaults]setObject:[[DeviceInfomationShare share] UUID] forKey:@"udid"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults]setObject:_phoneField.text forKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
            [[NSUserDefaults standardUserDefaults]setObject:_passwordField.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            SRViewController * srv = [[SRViewController alloc]init];
            [self presentViewController:srv animated:YES completion:nil];
            
        }else{
            NSString * errorString = nil;
            if (statusCode == 400) {
                errorString = @"密码为空";
            }else if (statusCode == 409){
                errorString = @"手机号已注册";
            }else if (statusCode == 422){
                errorString = @"短信验证码不正确";
            }
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:errorString
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
        }

    }
   
    
    //获取验证码
    if(request.tag == 101){
        
        NSString *responseString=[request responseString];
        NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
        NSLog(@"注册获取验证码%@",dic);
        int statusCode = [request responseStatusCode];
        NSLog(@"注册获取验证码的状态码 requestFinished statusCode %d",statusCode);
        if (statusCode == 201 ) {
            [[NSUserDefaults standardUserDefaults]setObject:[[DeviceInfomationShare share] UUID] forKey:@"udid"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else{
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[[dic objectForKey:@"errors"] objectForKey:@"code"]delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil ];
            [alert show];
        }
        
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"注册第一页 请求失败 %@",[request responseString]);
//    //去掉加载框
//    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
//    [bd removeFromSuperview];
//    bd=nil;
    //提示警告框失败...
    MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"请检查网络连接";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2.0);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
    
}
#pragma  mark - 定时器启动后的调用的方法
-(void)ytTimerClick
{
    if(time==0)
    {
        time = 0;
        [timer invalidate];
        _newButton.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:169.0/255.0 blue:255.0/255.0 alpha:1];
        [_newButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    }else
    {
        time--;
        _newButton.backgroundColor = [UIColor grayColor];
        [_newButton setTitle:[NSString stringWithFormat:@"重新获取验证码(%ds)",time] forState:UIControlStateNormal];
    }
    
}

#pragma mark - UITextField的代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_phoneField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_yanzmField resignFirstResponder];
    return YES;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _passwordField) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_passwordField.frame.size.width - 40, (_passwordField.frame.size.height -40) / 2, 40, 40);
        [button setImage:[UIImage imageNamed:@"删除密码@2x"] forState:UIControlStateNormal];
        button.tag = 58;
        [button addTarget:self action:@selector(deletePassword:) forControlEvents:UIControlEventTouchUpInside];
        [_passwordField addSubview:button];
    }
}
-(void)deletePassword:(UIButton *)button
{
    if (button.tag == 58) {
        [button removeFromSuperview];
    }
    _passwordField.text = @"";
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_passwordField resignFirstResponder];
    [_phoneField resignFirstResponder];
    [_yanzmField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    time = 0;
    [timer invalidate];
    _phoneField.text = @"";
    _passwordField.text = @"";
    _yanzmField.text = @"";
    [_registerRequest setDelegate:nil];
    [_registerRequest cancel];
    [upBackListRequest setDelegate:nil];
    [upBackListRequest cancel];
    [_yzmRequest setDelegate:nil];
    [_yzmRequest cancel];
    
}

#pragma mark - 获取通讯录里联系人姓名和手机号
- (void)address
{
    dataSource = [[NSMutableArray alloc] init];
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    //判断是否在ios6.0版本以上
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0){
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        CFErrorRef* error=nil;
        addressBooks = ABAddressBookCreateWithOptions(NULL, error);
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        NSMutableDictionary *addressBook = [[NSMutableDictionary alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        }else {
            if ((__bridge id)abLastName != nil){
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        [addressBook setObject:nameString forKey:@"name"];
        //        addressBook.recordID = (int)ABRecordGetRecordID(person);
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                
                switch (j) {
                    case 0: {// Phone number
                        NSString * valueString = (__bridge NSString*)value;
                        valueString = [valueString stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        NSLog(@"valueString = %@",valueString);
                        [addressBook setObject:valueString forKey:@"mobile"];
                        break;
                    }
                        
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [dataSource addObject:addressBook];
        
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    if (dataSource.count == 0) {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"您的通讯录没有联系人!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
        
    }else{
        [self CheckRequest];
    }
    
}
#pragma mark - 上传黑名单
-(void)CheckRequest
{
    NSArray * user = [NSArray arrayWithObject:dataSource];
    
    NSLog(@"获取用户黑名单状态 user = %@",user);
    if ([NSJSONSerialization isValidJSONObject:[user firstObject]]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:[user firstObject] options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        
        NSString * urlStr = [NSString stringWithFormat:@"%@blacklist?udid=%@",URL_HOST,[[DeviceInfomationShare share] UUID]];
        NSLog(@"注册将用户添加到黑名单 = %@",urlStr);
        NSURL * url = [NSURL URLWithString:urlStr];
        upBackListRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [upBackListRequest setRequestMethod:@"POST"];
        
        //1、header
        [upBackListRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //2、header
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        NSLog(@"注册将用户添加到黑名单 Authorization%@",Authorization);
        [upBackListRequest addRequestHeader:@"Authorization" value:Authorization];
        [upBackListRequest setDelegate:self];
        [upBackListRequest setPostBody:tempJsonData];
        upBackListRequest.tag = 101;
        [upBackListRequest startAsynchronous];
        
    }
    
}

@end
