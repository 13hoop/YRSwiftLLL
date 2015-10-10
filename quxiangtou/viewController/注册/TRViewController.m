//
//  TRViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/11.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "TRViewController.h"
#import "ViewController.h"

@interface TRViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UIButton * newButton;
    int time;
    NSTimer * timer;
}
@property (nonatomic,strong) UILabel * phoneLabel;
@property (nonatomic,strong) UITextField * yanzmField;
@property (nonatomic,strong) UITableView * tableView;


@end

@implementation TRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = color(239, 239, 244);
    [self createNav];
    [self createUI];
    
}
-(void)createNav
{
    UIView * navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64)];
    navigationView.userInteractionEnabled = YES;
    navigationView.backgroundColor = color_alpha(247.0, 247.0, 247.0, 1);
    [self.view addSubview:navigationView];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 30, 50, 25);
    backButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [backButton setTitleColor:color_alpha(47.0, 120.0, 200.0, 1) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width / 2 -40, 30, 80, 30)];
    titleLabel.text = @"验证码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navigationView addSubview:titleLabel];
    
}
-(void)createUI
{
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, Screen_width, 30)];
    label1.text = @"输入验证码后";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = color(102, 103, 104);
    label1.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, label1.frame.size.height + label1.frame.origin.y + 5, Screen_width, 30)];
    NSString * phoneString = [[ACommenData sharedInstance].logDic objectForKey:@"mobile"];
    NSMutableString * phone = [NSMutableString stringWithFormat:@"%@",phoneString];
    [phone deleteCharactersInRange:NSMakeRange(3, 4)];
    [phone insertString:@"****" atIndex:3];
    NSString * string = [NSString stringWithFormat:@"您的趣相投的账号%@将被激活",phone];
    label2.text = string;
    label2.textColor = color(102, 103, 104);
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label2];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, label2.frame.size.height+label2.frame.origin.y+ 25, Screen_width, 50) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = color(239, 239, 244);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(_tableView.separatorInset.top, 0, _tableView.separatorInset.bottom, 0);
    }
    [self.view addSubview:_tableView];
    
    
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(20, _tableView.frame.size.height+_tableView.frame.origin.y + 15, Screen_width - 30, 40);
    [loginButton setTitle:@"确定" forState:UIControlStateNormal];
    loginButton.backgroundColor = color_alpha(87.0, 169.0, 255.0, 1);;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    loginButton.layer.cornerRadius = 6;
    loginButton.layer.masksToBounds = YES;
    [loginButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.tag = 1;
    [self.view addSubview:loginButton];
    
    newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newButton.frame = CGRectMake(20, loginButton.frame.size.height+loginButton.frame.origin.y + 15 , Screen_width - 30, 40);
    [newButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    newButton.titleLabel.font = [UIFont systemFontOfSize:20];
    newButton.backgroundColor = color_alpha(255.0, 90.0, 97.0, 1);;
    newButton.layer.cornerRadius = 6;
    newButton.layer.masksToBounds = YES;
    newButton.tag = 2;
    [newButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newButton];
    
    UIButton * jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jumpButton.frame = CGRectMake(20, newButton.frame.size.height+newButton.frame.origin.y + 15, Screen_width - 30, 40);
    [jumpButton setTitle:@"跳过" forState:UIControlStateNormal];
    jumpButton.titleLabel.font = [UIFont systemFontOfSize:20];
    jumpButton.layer.cornerRadius = 6;
    jumpButton.layer.masksToBounds = YES;
    jumpButton.tag = 3;
    jumpButton.backgroundColor = color_alpha(255.0, 157.0, 0.0, 1);;
    [jumpButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpButton];
    
}

-(void)backClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma mark - 获取验证码  tag = 101       获取验证码登录   tag = 100
-(void)buttonClick:(UIButton *)button
{
    if (button.tag == 1) {
        //获取验证码之后登录
        if(time!=0){
            if([_yanzmField.text isNotEmpty])
            {
                NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:_yanzmField.text,@"captcha",[[ACommenData sharedInstance].logDic objectForKey:@"mobile" ],@"mobile", nil];
                if ([NSJSONSerialization isValidJSONObject:user]) {
                    NSError * error;
                    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
                    NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
                    NSString * yzm = [NSString stringWithFormat:@"%@users/verify_mobile?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid"]];
                    NSURL * url = [NSURL URLWithString:yzm];
                    NSLog(@"注册获取验证码后登录 %@",url);
                    verityPhoneRequest = [[ASIFormDataRequest alloc]initWithURL:url];
                    [verityPhoneRequest setRequestMethod:@"POST"];
                    [verityPhoneRequest setDelegate:self];
                    verityPhoneRequest.tag = 100;
                    [verityPhoneRequest addRequestHeader:@"Content-Type" value:@"application/json"];
                    [verityPhoneRequest setPostBody:tempJsonData];
                    [verityPhoneRequest startAsynchronous];
                }
                //加载框
                MBProgressHUD *bd=[[MBProgressHUD alloc]initWithView:self.view];
                [self.view addSubview:bd];
                bd.tag=123456;
                bd.dimBackground=YES;
                bd.detailsLabelText=@"正在加载,请稍后";
                [bd show:YES];
            }else{
                UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                 message:@"请输入验证码之后，再点击\"确定\"验证手机号!"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil, nil ];
                [alert show];
                
                [newButton setTitle:@"获取验证码" forState:UIControlStateNormal];
               
                
            }
        }else{
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"请获取验证码"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];

            [newButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
    }
    //注册获取验证码
    if (button.tag == 2){
        NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:@"sign_up",@"type",[[ACommenData sharedInstance].logDic objectForKey:@"mobile" ],@"mobile", nil];
        if ([NSJSONSerialization isValidJSONObject:user]) {
            NSError * error;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
            NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
            NSString * yzm = [NSString stringWithFormat:@"%@sms?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid"]];
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
        
        //加载框
        MBProgressHUD *bd=[[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:bd];
        bd.tag=123456;
        bd.dimBackground=YES;
        bd.detailsLabelText=@"正在加载,请稍后";
        [bd show:YES];
    }
    //跳过
    if (button.tag == 3) {
        [SharedAppDelegate showRootViewController];
    }
    
}

#pragma mark - 获取验证码    tag = 101    验证码登录     tag = 100
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    //移除加载框
    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
    [bd removeFromSuperview];
    bd=nil;
    //获取验证码登录
    if (request.tag == 100) {
        int statusCode = [request responseStatusCode];
        NSLog(@"注册获取验证码后验证手机号 requestFinished statusCode %d",statusCode);
        NSString *responseString=[request responseString];
        NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
        NSLog(@"登录放回data = %@",dic);
        
        if (statusCode == 204) {
            [SharedAppDelegate showRootViewController];
        }else{
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:[[dic objectForKey:@"errors"] objectForKey:@"code"]
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
            time=180;
            //获取验证码接口  获取成功
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ytTimerClick) userInfo:nil repeats:YES];
            
        }else{
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:[[dic objectForKey:@"errors"] objectForKey:@"code"]
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
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
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
    [bd removeFromSuperview];
    bd=nil;
    int statusCode = [request responseStatusCode];
    NSLog(@"注册获取验证码的状态码 requestFailed statusCode %d",statusCode);
    
    //提示警告框失败...
    MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = [request responseString];
    HUD.detailsLabelText = [dic objectForKey:@"error"];
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2.0);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 0;
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Third"];
    }
    
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
    [yzmRequest setDelegate:nil];
    [verityPhoneRequest setDelegate:nil];
    [yzmRequest cancel];
    [verityPhoneRequest cancel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
