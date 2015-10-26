//
//  loginViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/4.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "loginViewController.h"
#import "ViewController.h"
#import "FRegistViewController.h"
#import "XMShareView.h"
#import "YZMLoginViewController.h"
#import "LoginModel.h"
#import "RecoveryPasswordViewController.h"
#import "UIImageView+WebCache.h"

@interface loginViewController ()<UITextFieldDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) UITextField * nameField;
@property (nonatomic,strong) UITextField * passwordField;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIImageView * touxiang;
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   

    self.view.backgroundColor = color(234, 235, 236);
   [self createUI];
    //[self createNav];
    
}
-(void)createNav
{
    UIView * navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64)];
    navigationView.userInteractionEnabled = YES;
    navigationView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    [self.view addSubview:navigationView];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 30, 50, 25);
    backButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [backButton setTitleColor:[UIColor colorWithRed:47.0/255.0 green:120.0/255.0 blue:200.0/255.0 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width / 2 -40, 30, 80, 30)];
    titleLabel.text = @"登录";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navigationView addSubview:titleLabel];
    
}
-(void)backClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)createUI
{
    _touxiang = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width/2 - 40, 50, 80, 80)];
    _touxiang.layer.cornerRadius = 40;
    _touxiang.layer.masksToBounds = YES;
    _touxiang.userInteractionEnabled = YES;
    NSString * touxiangurl = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"touxiangurl"]];
    [_touxiang sd_setImageWithURL:[NSURL URLWithString:touxiangurl] placeholderImage:[[UIImage imageNamed:@"组 2@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.view addSubview:_touxiang];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _touxiang.frame.size.height + _touxiang.frame.origin.y + 20, Screen_width, 1)];
    label1.backgroundColor = color_alpha(177, 177, 177, 1);
    [self.view addSubview:label1];

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, label1.frame.size.height + label1.frame.origin.y , Screen_width, 50)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    UIImageView * nameImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 12, 26, 26)];
    nameImage.image = [[UIImage imageNamed:@"我的02@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [view addSubview:nameImage];
    
    
    _nameField = [[UITextField alloc] init];
    _nameField.frame=CGRectMake(nameImage.frame.origin.x + 40, 5,260, 40);
    _nameField.backgroundColor = [UIColor whiteColor];
    _nameField.delegate=self;
    _nameField.placeholder=@"填写您的手机号";
    _nameField.textColor=[UIColor grayColor];
    _nameField.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:_nameField];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"]isNotEmpty]) {
        _nameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    }
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(30, view.frame.size.height + view.frame.origin.y, Screen_width - 40, 1)];
    label2.backgroundColor = color_alpha(177, 177, 177, 1);
    [self.view addSubview:label2];

    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, label2.frame.size.height + label2.frame.origin.y , Screen_width, 50)];
    view2.userInteractionEnabled = YES;
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];

    UIImageView * passImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 12, 26, 26)];
    passImage.image = [[UIImage imageNamed:@"密码 拷贝 2@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [view2 addSubview:passImage];
    
    _passwordField = [[UITextField alloc] init];
    _passwordField.frame=CGRectMake(passImage.frame.origin.x + 40, 5, 260, 40);
    _passwordField.backgroundColor=[UIColor whiteColor];
    _passwordField.delegate=self;
    _passwordField.secureTextEntry = YES;
    _passwordField.textColor=[UIColor grayColor];
    _passwordField.placeholder=@"请输入您的密码";
    [view2 addSubview:_passwordField];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]isNotEmpty]) {
        _passwordField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    }
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, view2.frame.size.height + view2.frame.origin.y, Screen_width, 1)];
    label3.backgroundColor = color_alpha(177, 177, 177, 1);
    [self.view addSubview:label3];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, view2.frame.origin.y+view2.frame.size.height + 20, Screen_width - 40, 40);
    button.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:169.0/255.0 blue:255.0/255.0 alpha:1];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTitle:@"登录" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton * regist = [UIButton buttonWithType:UIButtonTypeCustom];
    regist.frame = CGRectMake(button.frame.origin.x, button.frame.size.height + button.frame.origin.y + 10, 100, 20);
    [regist setTitle:@"注册账号" forState:UIControlStateNormal];
    regist.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [regist setTitleColor:color_alpha(118, 119, 120, 1) forState:UIControlStateNormal];
    [regist addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regist];
    
    UIButton * question = [UIButton buttonWithType:UIButtonTypeCustom];
    question.frame = CGRectMake(button.frame.origin.x + button.frame.size.width - 130, button.frame.size.height + button.frame.origin.y + 10, 130, 20);
    [question setTitle:@"登录遇到问题?" forState:UIControlStateNormal];
    question.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [question setTitleColor:color_alpha(118, 119, 120, 1) forState:UIControlStateNormal];
    [question addTarget:self action:@selector(questionClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:question];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, question.frame.size.height + question.frame.origin.y + 40, Screen_width, 20)];
    label.text = @"还可以选择以下账号登录";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color_alpha(169, 170, 171, 1);
    [self.view addSubview:label];
    
    NSArray * images = @[@"微博@2x.png",@"QQ@2x.png",@"微信@2x.png"];
    NSArray * titles = @[@"微博",@"QQ",@"微信"];
    NSArray * colors = @[@[@255,@0,@38],@[@45,@159,@220],@[@0,@208,@58]];
    //double wide = (Screen_width - 100 -40) / 3;
    for (int i = 0; i < 3; i++) {
        UIButton * weibo = [UIButton buttonWithType:UIButtonTypeCustom];
        weibo.frame = CGRectMake(50 + (60+20)*i, label.frame.origin.y+label.frame.size.height+10, 60, 60);
        weibo.tag = 100 + i;
        [weibo addTarget:self action:@selector(thirdClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:weibo];
        
        UIImageView * weiboImageView = [[UIImageView alloc]init];
        if (i == 0) {
             weiboImageView.frame = CGRectMake(15, 5, (weibo.frame.size.width - 30) * 93 / 72, weibo.frame.size.width - 30);
        }else if (i == 1){
             weiboImageView.frame = CGRectMake(15, 5, (weibo.frame.size.width - 30) * 85 / 82, weibo.frame.size.width - 30);
        }else{
             weiboImageView.frame = CGRectMake(15, 5, (weibo.frame.size.width - 30) * 97 / 76, weibo.frame.size.width - 30);
        }
        weiboImageView.userInteractionEnabled = YES;
        weiboImageView.image = [UIImage imageNamed:[images objectAtIndex:i]];
        [weibo addSubview:weiboImageView];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(weiboImageView.frame.origin.x, weiboImageView.frame.origin.y + weiboImageView.frame.size.height + 3, weiboImageView.frame.size.width, weibo.frame.size.height - weiboImageView.frame.size.height - 5 - 8)];
        [label setText:[titles objectAtIndex:i]];
        NSArray * arr = [colors objectAtIndex:i];
        [label setTextColor:color_alpha([[arr objectAtIndex:0] intValue], [[arr objectAtIndex:1] intValue], [[arr objectAtIndex:2] intValue], 1)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [weibo addSubview:label];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_nameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    return YES;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_passwordField resignFirstResponder];
    [_nameField resignFirstResponder];
}
-(void)loginClick:(UIButton *)login
{
    if (_nameField.text.length != 11) {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"手机号位数错误!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];

    }else if ([ACommenData validatePhone:_nameField.text]== NO){
     
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"手机号格式不正确!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
    }else if (![_passwordField.text isNotEmpty]){
        
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"密码为空,请输入密码!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
    }else{
        NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:_nameField.text,@"mobile",_passwordField.text,@"password", nil];
        if ([NSJSONSerialization isValidJSONObject:user]) {
            NSError * error;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
            NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
            NSString * urlStr = [NSString stringWithFormat:@"%@sessions?udid=%@",URL_HOST,[[DeviceInfomationShare share] UUID]];
            NSLog(@"登录  %@",[[DeviceInfomationShare share] UUID]);
            NSURL * url = [NSURL URLWithString:urlStr];
            loginRequest = [[ASIFormDataRequest alloc]initWithURL:url];
            [loginRequest setRequestMethod:@"POST"];
            [loginRequest setDelegate:self];
            [loginRequest addRequestHeader:@"Content-Type" value:@"application/json"];
            [loginRequest setPostBody:tempJsonData];
            [loginRequest startAsynchronous];
        }
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
        ACommenData *data=[ACommenData sharedInstance];
        data.logDic=[dic valueForKey:@"data"]; //将登陆返回的数据存到一个字典对象里面...
         NSLog(@"登录 data %@",[dic valueForKey:@"data"]);
        [[NSUserDefaults standardUserDefaults]setObject:[[DeviceInfomationShare share] UUID] forKey:@"udid"];
        [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"] objectForKey:@"auth_token"] forKey:@"auth_token"];
        if ([[[dic objectForKey:@"data"] objectForKey:@"avatar"] isNotEmpty ]) {
            [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"] objectForKey:@"avatar"] forKey:@"touxiangurl"];
           
        }else{
             [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"touxiangurl"];
        }
        
         [[NSNotificationCenter defaultCenter]postNotificationName:@"updateAvatar" object:dic];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"mobile"];
        [[NSUserDefaults standardUserDefaults]setObject:_nameField.text forKey:@"mobile"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults]setObject:_passwordField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [_passwordField resignFirstResponder];
        [_nameField resignFirstResponder];
        [SharedAppDelegate showRootViewController];
    }else{
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:[[dic valueForKey:@"errors"] objectForKey:@"code"]
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];

        
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

-(void)registerClick:(UIButton *)button
{
    FRegistViewController * fvc = [[FRegistViewController alloc]init];
    fvc.nameOfUpPage = @"register";
    [self presentViewController:fvc animated:YES completion:nil];
}
-(void)questionClick:(UIButton *)button
{
    UIActionSheet * as = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"短信验证码登录",@"找回密码", nil];
    [as showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        YZMLoginViewController * yzmLogin = [[YZMLoginViewController alloc]init];
        yzmLogin.isUpPage = @"yanzhengma";
        [self presentViewController:yzmLogin animated:YES completion:nil];
    }else{
        RecoveryPasswordViewController * yzmLogin = [[RecoveryPasswordViewController alloc]init];
        [self presentViewController:yzmLogin animated:YES completion:nil];
    }

}

-(void)thirdClick:(UIButton *)button
{
    if (button.tag == 100) {
//        YZMLoginViewController * yzmv = [[YZMLoginViewController alloc]init];
//        [self presentViewController:yzmv animated:YES completion:nil];
    }else if (button.tag == 101){
        
    }else{
        
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [loginRequest setDelegate:nil];
    [loginRequest cancel];
}
- (void)didReceiveMemoryWarning {
    [_passwordField resignFirstResponder];
    [_nameField resignFirstResponder];
    
    [super didReceiveMemoryWarning];
    
}

@end
