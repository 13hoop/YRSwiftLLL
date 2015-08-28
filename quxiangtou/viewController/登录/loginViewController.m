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


@interface loginViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) UITextField * nameField;
@property (nonatomic,strong) UITextField * passwordField;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIImageView * touxiang;
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   

    self.view.backgroundColor = color(239, 239, 244);
    [self createUI];
    [self createNav];
    
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
    _touxiang = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width/2 - 40, 70, 80, 80)];
    _touxiang.layer.cornerRadius = 40;
    _touxiang.layer.masksToBounds = YES;
    _touxiang.userInteractionEnabled = YES;
    _touxiang.image = [UIImage imageNamed:@"组 2@2x"];
    [self.view addSubview:_touxiang];
    
    //self.view.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:230.0/255.0 blue:231.0/255.0 alpha:1];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _touxiang.frame.origin.y+_touxiang.frame.size.height , Screen_width, 200) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //_tableView.backgroundColor = color(207, 231, 224);
    _tableView.scrollEnabled = NO;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(_tableView.separatorInset.top, 0, _tableView.separatorInset.bottom, 0);
    }
    [self.view addSubview:_tableView];

    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, _tableView.frame.origin.y+_tableView.frame.size.height - 40, Screen_width - 40, 50);
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
    label.text = @"还可以选择以下账号登录或注册";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color_alpha(169, 170, 171, 1);
    [self.view addSubview:label];
    
//    NSArray * third = @[@"微博",@"QQ",@"微信"];
    NSArray * images = @[@"微博@2x.png",@"QQ@2x.png",@"微信@2x.png"];
    double wide = (Screen_width - 100 -40) / 3;
    for (int i = 0; i < 3; i++) {
        UIButton * weibo = [UIButton buttonWithType:UIButtonTypeCustom];
        weibo.frame = CGRectMake(50 + (wide+20)*i, label.frame.origin.y+label.frame.size.height+10, wide, wide);
//        [weibo setTitle:[third objectAtIndex:i] forState:UIControlStateNormal];
        weibo.tag = 100 + i;
        [weibo addTarget:self action:@selector(thirdClick:) forControlEvents:UIControlEventTouchUpInside];
        //weibo.backgroundColor = [UIColor yellowColor];
        [weibo setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
//        weibo.imageView.image = [[UIImage imageNamed:images[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [weibo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:weibo];

    }
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"id"];
    }
    //cell.backgroundColor = [PRLColor colorWithHexadecimalRGB:@"#D7EBF6" alpha:1.0];
    if(indexPath.row==1)
    {
        UIImageView * nameImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 12, 26, 26)];
        nameImage.image = [UIImage imageNamed:@"我的02@2x.png"];
        [cell.contentView addSubview:nameImage];
        
        cell.backgroundColor=[UIColor whiteColor];
        
        _nameField = [[UITextField alloc] init];
        _nameField.frame=CGRectMake(nameImage.frame.origin.x + 40, 5,260, 40);
        _nameField.delegate=self;
        _nameField.placeholder=@"填写您的用户名";
        _nameField.textColor=[UIColor grayColor];
        [cell.contentView addSubview:_nameField
         ];
        
        
    }else if(indexPath.row==2)
    {
        cell.backgroundColor=[UIColor whiteColor];
        UIImageView * passImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 12, 26, 26)];
        passImage.image = [UIImage imageNamed:@"密码 拷贝 2@2x.png"];
        [cell.contentView addSubview:passImage];
        
        _passwordField = [[UITextField alloc] init];
        _passwordField.frame=CGRectMake(passImage.frame.origin.x + 40, 5, 260, 40);
        _passwordField.backgroundColor=[UIColor clearColor];
        _passwordField.delegate=self;
        _passwordField.secureTextEntry = YES;
        _passwordField.textColor=[UIColor grayColor];
        _passwordField.placeholder=@"请输入您的密码";
        [cell.contentView addSubview:_passwordField];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
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
//    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"First"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    ViewController * vc = [[ViewController alloc]init];
//    vc.isFirst = YES;
//    [self presentViewController:vc animated:YES completion:nil];
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:_nameField.text,@"mobile",_passwordField.text,@"password", nil];
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString * urlStr = [NSString stringWithFormat:@"%@sessions?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid" ]];
        NSURL * url = [NSURL URLWithString:urlStr];
        loginRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [loginRequest setRequestMethod:@"POST"];
        [loginRequest setDelegate:self];
        [loginRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        [loginRequest setPostBody:tempJsonData];
        [loginRequest startAsynchronous];
    }
}
/**
 *  请求完成
 *
 *  @param request 请求
 */
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    //"auth_token" = "9A78C82C-DF71-106D-D3AC-D0083AB3D78E";
    NSLog(@"loginViewController responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    NSLog(@"loginViewController statusCode %d",statusCode);
    if (statusCode == 201 ) {
//        LoginModel * LModel = [dic objectForKey:@"data"];
//        NSLog(@"LModel%@",LModel);
//        [[NSUserDefaults standardUserDefaults] setObject:LModel forKey:@"user"];
        [_passwordField resignFirstResponder];
        [_nameField resignFirstResponder];
        [SharedAppDelegate showRootViewController];
    }else{
        //提示警告框失败...
        MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"抱歉";
        HUD.detailsLabelText =[dic valueForKey:@"return_content"];
        HUD.mode = MBProgressHUDModeText;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2.0);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
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

- (void)didReceiveMemoryWarning {
    [_passwordField resignFirstResponder];
    [_nameField resignFirstResponder];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
