//
//  SYZMViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/10.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "SYZMViewController.h"
#import "YZMLoginViewController.h"
#import "ViewController.h"
#import "LoginModel.h"
#import "PassYZMViewController.h"

@interface SYZMViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIButton * newButton;
    int time;
    NSTimer * timer;
}
@property (nonatomic,strong) UILabel * phoneLabel;
@property (nonatomic,strong) UITextField * yanzmField;
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation SYZMViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = color_alpha(239, 239, 244,1);
    [self createNav];
    [self createUI];
    
}
-(void)createNav
{
    UIView * navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64)];
    navigationView.userInteractionEnabled = YES;
    navigationView.backgroundColor = color_alpha(247, 247, 247,1);
    [self.view addSubview:navigationView];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 30, 50, 25);
    backButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [backButton setTitleColor:color_alpha(101.0, 177.0, 229.0,1) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width / 2 -40, 30, 80, 30)];
    if ([_pageName isEqualToString:@"YZM"]) {
        titleLabel.text = @"验证码";
    }else if ([_pageName isEqualToString:@"password"]){
        titleLabel.text = @"找回密码";
    }
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navigationView addSubview:titleLabel];
    
}
-(void)createUI
{
    NSMutableString * phone = [NSMutableString stringWithFormat:@"%@",_phoneString];
    [phone deleteCharactersInRange:NSMakeRange(3, 4)];
    [phone insertString:@"****" atIndex:3];
    NSString * string = [NSString stringWithFormat:@"您的手机%@",phone];
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, Screen_width, 30)];
    _phoneLabel.text = string;
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    _phoneLabel.textColor = [UIColor grayColor];
    _phoneLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_phoneLabel];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, _phoneLabel.frame.size.height+_phoneLabel.frame.origin.y + 10, Screen_width, 30)];
    label2.text = @"会收到一条含有4位数字验证码的短信";
    label2.textColor = [UIColor grayColor];
    label2.textAlignment = NSTextAlignmentCenter;
    
    label2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label2];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, label2.frame.size.height+label2.frame.origin.y+ 25, Screen_width, 50)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = color_alpha(239, 239, 244,1);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(_tableView.separatorInset.top, 0, _tableView.separatorInset.bottom, 0);
    }
    [self.view addSubview:_tableView];
    
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(20, _tableView.frame.size.height+_tableView.frame.origin.y + 20, Screen_width - 30, 40);
    loginButton.layer.cornerRadius = 6;
    loginButton.layer.masksToBounds = YES;
    [loginButton setTitle:@"确定" forState:UIControlStateNormal];
    loginButton.backgroundColor = color_alpha(87, 169, 255,1);
    loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.tag = 1;
    [self.view addSubview:loginButton];
    
    newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newButton.frame = CGRectMake(20, loginButton.frame.size.height+loginButton.frame.origin.y + 20, Screen_width - 30, 40);
    newButton.layer.cornerRadius = 6;
    newButton.layer.masksToBounds = YES;
    [newButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    newButton.backgroundColor = color_alpha(255, 90,97 ,1);
    newButton.titleLabel.font = [UIFont systemFontOfSize:20];
    newButton.tag = 2;
    [newButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newButton];
    
}

-(void)backClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(void)buttonClick:(UIButton *)button
{
    if (button.tag == 1) {
        if ([_pageName isEqualToString:@"YZM"]){
            if(time!=0){
                if(_yanzmField.text.length>0)
                {
                    NSString * yzm = [NSString stringWithFormat:@"%@sessions?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
                    NSLog(@"验证码登录是的URL %@",yzm);
                    NSURL * url = [NSURL URLWithString:yzm];
                    yzmLoginRequest = [[ASIFormDataRequest alloc]initWithURL:url];
                    [yzmLoginRequest setDelegate:self];
                    yzmLoginRequest.shouldRedirect = NO;
                    [yzmLoginRequest setRequestMethod:@"POST"];
                    yzmLoginRequest.tag = 100;
                    [yzmLoginRequest addPostValue:_yanzmField.text forKey:@"captcha"];
                    NSLog(@"_yanzmField.text %@",_yanzmField.text);   //_yanzmField.text 5705
                    [yzmLoginRequest addPostValue:_phoneString forKey:@"mobile"];
                    [yzmRequest addRequestHeader:@"Content-Type" value:@"application/json"];
                    [yzmLoginRequest startAsynchronous];
                    
                    MBProgressHUD *bd=[[MBProgressHUD alloc]initWithView:self.view];
                    [self.view addSubview:bd];
                    bd.tag=123456;
                    bd.dimBackground=YES;
                    bd.detailsLabelText=@"正在加载,请稍后";
                    [bd show:YES];
                }else{
                    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                                     message:@"请输入验证码之后，再点击确定登录!"
                                                                    delegate:self
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil, nil ];
                    [alert show];
                    
                }
                
            }else{
                UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                                 message:@"请输入验证码之后，再点击确定登录!"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil, nil ];
                [alert show];

            }
            
        }
        if ([_pageName isEqualToString:@"password"]) {
            NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:_yanzmField.text,@"captcha",_phoneString,@"mobile", nil];
            NSLog(@"_phoneString%@",_phoneString);
            NSLog(@"_yanzmField.text%@",_yanzmField.text);
            if ([NSJSONSerialization isValidJSONObject:user]) {
                NSError * error;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
                NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
                NSString * yzm = [NSString stringWithFormat:@"%@users/find_password?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey: @"udid"]];
                NSLog(@"验证码登录验证  uuid%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]);
                NSURL * url = [NSURL URLWithString:yzm];
                NSLog(@"验证码登录验证 %@",url);
                yzmLoginRequest = [[ASIFormDataRequest alloc]initWithURL:url];
                [yzmLoginRequest setRequestMethod:@"POST"];
                [yzmLoginRequest setDelegate:self];
                yzmLoginRequest.tag = 100;
                [yzmLoginRequest addRequestHeader:@"Content-Type" value:@"application/json"];
                [yzmLoginRequest setPostBody:tempJsonData];
                [yzmLoginRequest startAsynchronous];
            }
            
            
        }
    }
    
    if (button.tag == 2){
        NSString * type = [[NSString alloc]init];
        if ([_pageName isEqualToString:@"YZM"]) {
            type = @"sign_in";
        }
        if ([_pageName isEqualToString:@"password"]) {
            type = @"lost_password";
        }
        NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:type,@"type",_phoneString,@"mobile", nil];
        if ([NSJSONSerialization isValidJSONObject:user]) {
            NSError * error;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
            NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
            NSString * yzm = [NSString stringWithFormat:@"%@sms?udid=%@",URL_HOST,[[DeviceInfomationShare share] UUID]];
            NSURL * url = [NSURL URLWithString:yzm];
            NSLog(@"注册获取验证码 %@",url);
            yzmRequest = [[ASIFormDataRequest alloc]initWithURL:url];
            [yzmRequest setRequestMethod:@"POST"];
            [yzmRequest setDelegate:self];
            yzmRequest.tag = 101;
            [yzmRequest addRequestHeader:@"Content-Type" value:@"application/json"];
            [yzmRequest setPostBody:tempJsonData];
            [yzmRequest startAsynchronous];
        }
    }
    
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    //移除加载框
    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
    [bd removeFromSuperview];
    bd=nil;
    //获取验证码
    if (request.tag == 100) {
        //解析接收回来的数据
        NSString *responseString=[request responseString];
        NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
        NSLog(@"验证码登录时返回的数据 responseString %@",dic);
        int statusCode = [request responseStatusCode];
        NSLog(@"验证码登录登录时的状态码 requestFinished statusCode %d",statusCode);
        if (statusCode == 201 ) {
            //验证码登录
            if ([_pageName isEqualToString:@"YZM"]) {
                ACommenData *data=[ACommenData sharedInstance];
                data.logDic=[dic valueForKey:@"data"]; //将登陆返回的数据存到一个字典对象里面...
                [[NSUserDefaults standardUserDefaults]setObject:[data.logDic objectForKey:@"avatar"] forKey:@"touxiangurl"];
                [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"] objectForKey:@"auth_token"] forKey:@"auth_token"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [SharedAppDelegate showRootViewController];
            }
            // 找回密码
            if ([_pageName isEqualToString:@"password"]) {
                
                PassYZMViewController * pvc = [[PassYZMViewController alloc]init];
                pvc.data = [dic objectForKey:@"data"];
                [self presentViewController:pvc animated:YES completion:nil];
                
            }
            
        }else{
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:[[dic objectForKey:@"errors"] objectForKey:@"code"]
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
        }
        
    }
    
    if (request.tag == 101){
        NSString *responseString=[request responseString];
        NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
        int statusCode = [request responseStatusCode];
        NSLog(@"验证码登录获取验证码的状态码 requestFinished statusCode %d",statusCode);
        if (statusCode == 201 ) {
//            NSLog(@"验证码登录获取到的验证码%@",dic);
            [[NSUserDefaults standardUserDefaults]setObject:[[DeviceInfomationShare share] UUID] forKey:@"udid"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"验证码发送成功";
            HUD.mode = MBProgressHUDModeText;
            //HUD.detailsLabelText =[dic valueForKey:@"return_content"];
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
            
            
            time=180;
            //获取验证码接口  获取成功
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ytTimerClick) userInfo:nil repeats:YES];
        }else{
            [newButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            //提示警告框失败...
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"抱歉";
            HUD.mode = MBProgressHUDModeText;
            HUD.detailsLabelText =[dic valueForKey:@"return_content"];
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
        }
        
    }
    
    
}
-(void)ytTimerClick
{
    if(time==0)
    {
        
        [newButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }else
    {
        time--;
        [newButton setTitle:[NSString stringWithFormat:@"重新获取验证码(%ds)",time] forState:UIControlStateNormal];
    }
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    //去掉加载框
    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
    [bd removeFromSuperview];
    bd=nil;
    
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"syzm"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    _yanzmField = [[UITextField alloc]initWithFrame:CGRectMake(30, 10, 250, 30)];
    _yanzmField.placeholder = @"请输入验证码";
    _yanzmField.backgroundColor=[UIColor clearColor];
    _yanzmField.delegate=self;
    _yanzmField.textColor = [UIColor grayColor];
    [cell.contentView addSubview:_yanzmField];
    return cell;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_yanzmField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_yanzmField resignFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [yzmLoginRequest setDelegate:nil];
    [yzmRequest setDelegate:nil];
    [yzmRequest cancel];
    [yzmLoginRequest cancel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
