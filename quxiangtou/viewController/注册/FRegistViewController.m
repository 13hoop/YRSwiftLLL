//
//  FRegistViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/7/24.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "FRegistViewController.h"
#import "SRViewController.h"
#import "XieYiViewController.h"
#import"AppDelegate.h"
#import "LoginModel.h"

////-fno-objc-arc
//-fobjc-arc
@interface FRegistViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,ASIHTTPRequestDelegate>
{
    BOOL isAgree;
    UIImageView * agreeImage;
}
@property (nonatomic,strong) UITextField * passwordField;
@property (nonatomic,strong) UITextField * phoneField;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) ASIFormDataRequest * registerRequest;
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
    titleLabel.text = @"注册";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navigationView addSubview:titleLabel];
    
}
-(void)createUI
{
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, Screen_width, 1)];
    label1.backgroundColor = color_alpha(177, 177, 177, 1);
    [self.view addSubview:label1];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, label1.frame.size.height + label1.frame.origin.y , Screen_width, 50)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    _phoneField = [[UITextField alloc] init];
    _phoneField.frame=CGRectMake(15, 5,Screen_width - 30, 40);
    _phoneField.backgroundColor=[UIColor clearColor];
    _phoneField.delegate=self;
    _phoneField.placeholder=@"请输入你的手机号";
    _phoneField.textColor=[UIColor grayColor];
    _phoneField.keyboardType=UIKeyboardTypeNumberPad;
    [view addSubview:_phoneField
     ];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height + view.frame.origin.y, Screen_width, 1)];
    label2.backgroundColor = color_alpha(177, 177, 177, 1);
    [self.view addSubview:label2];
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, label2.frame.size.height + label2.frame.origin.y , Screen_width, 50)];
    view2.userInteractionEnabled = YES;
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    _passwordField = [[UITextField alloc] init];
    _passwordField.frame=CGRectMake(15, 5, Screen_width - 30, 40);
    _passwordField.backgroundColor=[UIColor clearColor];
    _passwordField.delegate=self;
    _passwordField.secureTextEntry = YES;
    _passwordField.textColor=[UIColor grayColor];
    _passwordField.placeholder=@"设置密码";
    [view2 addSubview:_passwordField];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, view2.frame.size.height + view2.frame.origin.y, Screen_width, 1)];
    label3.backgroundColor = color_alpha(177, 177, 177, 1);
    [self.view addSubview:label3];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, view2.frame.origin.y+view2.frame.size.height + 20, Screen_width - 40, 40);
    button.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:169.0/255.0 blue:255.0/255.0 alpha:1];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTitle:@"注册" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    NSString * string = [NSString stringWithFormat:@"%@",@"注册表示您已经同意"];
    UILabel * agreeLable = [[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.size.height + button.frame.origin.y + 10, 138, 20)];
    agreeLable.text = string;
    agreeLable.textColor = color_alpha(120, 121, 122, 1);
    agreeLable.font = [UIFont systemFontOfSize:15];
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
    
    agreeImage = [[UIImageView alloc]initWithFrame:CGRectMake(agreeLable.frame.origin.x, agreeLable.frame.size.height + agreeLable.frame.origin.y + 15, 15, 15)];
    agreeImage.image = [UIImage imageNamed:@"选中@2x.png"];
    agreeImage.userInteractionEnabled = YES;
    [self.view addSubview:agreeImage];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeClick)];
    [agreeImage addGestureRecognizer:tap];
    
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(agreeImage.frame.size.width + agreeImage.frame.origin.x + 5, agreeImage.frame.origin.y , 250, agreeImage.frame.size.height)];
    [label4 setText:@"通过通讯录找到正在玩趣相投的朋友"];
    [label4 setTextColor:[UIColor grayColor]];
    [label4 setTextAlignment:NSTextAlignmentLeft];
    label4.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label4];
    
}
-(void)agreeClick
{
    if (isAgree == YES) {
        isAgree = NO;
        agreeImage.image = [UIImage imageNamed:@"选择框@2x.png"];
    }else{
        isAgree = YES;
        agreeImage.image = [UIImage imageNamed:@"选中@2x.png"];
    }
}
-(void)tap:(UIButton *)tap
{
    XieYiViewController * xyv = [[XieYiViewController alloc]init];
    [self presentViewController:xyv animated:YES completion:nil];
}
-(void)registerClick:(UIButton *)button
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
        if (![_passwordField.text isNotEmpty]){
            
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"密码为空,请输入密码!"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
        }else{
            NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:_phoneField.text,@"mobile",_passwordField.text,@"password", nil];
            if ([NSJSONSerialization isValidJSONObject:user]) {
                NSError * error;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
                NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
                NSString * urlStr = [NSString stringWithFormat:@"%@users?udid=%@",URL_HOST,[[DeviceInfomationShare share] UUID]];
                
                NSLog(@"注册第一页 udid %@",[[DeviceInfomationShare share] UUID]);
                NSURL * url = [NSURL URLWithString:urlStr];
                _registerRequest = [[ASIFormDataRequest alloc]initWithURL:url];
                [_registerRequest setRequestMethod:@"POST"];
                [_registerRequest setDelegate:self];
                [_registerRequest addRequestHeader:@"Content-Type" value:@"application/json"];
                [_registerRequest setPostBody:tempJsonData];
                [_registerRequest startAsynchronous];
            }
 
        }
    }
   
    
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    //{"data":"F5505E7C-EA53-56A1-EFE0-CBC0D568BA13"}
    NSLog(@"注册第一页 responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    NSLog(@"注册第一页 statusCode %d",statusCode);
    if (statusCode == 201 ) {
        
        NSString * auth_token =[dic valueForKey:@"data"]; //将登陆返回的数据存到一个字典对象里面...
        NSLog(@"注册第一页 auth_token %@",auth_token);
        [[NSUserDefaults standardUserDefaults]setObject:auth_token forKey:@"auth_token"];
        [[NSUserDefaults standardUserDefaults]setObject:[[DeviceInfomationShare share] UUID] forKey:@"udid"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"mobile"];
        [[NSUserDefaults standardUserDefaults]setObject:_phoneField.text forKey:@"mobile"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults]setObject:_passwordField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        SRViewController * srv = [[SRViewController alloc]init];
        [self presentViewController:srv animated:YES completion:nil];
        
    }else if (statusCode == 409){
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"手机号已注册!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
    }else if (statusCode == 409){
        //提示警告框失败...
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"密码为空,请输入密码!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
       
    }else{
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:[[dic objectForKey:@"errors"] objectForKey:@"code"]
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"注册第一页 请求失败 %@",[request responseString]);
    //去掉加载框
    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
    [bd removeFromSuperview];
    bd=nil;
    
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

-(void)backClick:(UIButton *)button
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_phoneField resignFirstResponder];
    [_passwordField resignFirstResponder];
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_registerRequest setDelegate:nil];
    [_registerRequest cancel];
}

//- (BOOL)validatePhone
//{
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    
//    if (([regextestmobile evaluateWithObject:_phoneField.text] == YES)
//        || ([regextestcm evaluateWithObject:_phoneField.text] == YES)
//        || ([regextestct evaluateWithObject:_phoneField.text] == YES)
//        || ([regextestcu evaluateWithObject:_phoneField.text] == YES))
//    {
//        
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}


@end
