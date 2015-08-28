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
@interface FRegistViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,ASIHTTPRequestDelegate>
@property (nonatomic,strong) UITextField * passwordField;
@property (nonatomic,strong) UITextField * phoneField;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) ASIFormDataRequest * registerRequest;
@end

@implementation FRegistViewController

- (void)viewDidLoad {
   // [[NSUserDefaults standardUserDefaults]setObject:model forKey:@"user"];
    //注册第一页 model = (null)
    NSLog(@"注册第一页1 model = %@",[XMShareView sharedInstance].loginModel);
    NSLog(@"注册第一页1 model = %@",[XMShareView sharedInstance].loginModel.meetDictionary);

    

    [super viewDidLoad];
    self.view.backgroundColor = color(239, 239, 244);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, Screen_width, 200) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.backgroundColor =  color(239, 239, 244);
    _tableView.scrollEnabled = NO;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(_tableView.separatorInset.top, 0, _tableView.separatorInset.bottom, 0);
    }
    [self.view addSubview:_tableView];
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
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, _tableView.frame.origin.y+_tableView.frame.size.height - 50, Screen_width - 20, 40);
    button.backgroundColor = color_alpha(87.0, 169.0, 255.0, 1);
    [button setTitle:@"注册" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20.0];
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    NSString * string = [NSString stringWithFormat:@"%@",@"注册表示您已经同意"];
    UILabel * agreeLable = [[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.size.height + button.frame.origin.y + 10, 155, 20)];
    agreeLable.text = string;
    agreeLable.textColor = color_alpha(120, 121, 122, 1);
    agreeLable.font = [UIFont systemFontOfSize:15];
    agreeLable.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:agreeLable];
    
   
     NSString * xieyi = [NSString stringWithFormat:@"%@",@"趣相投服务使用协议"];
    UIButton * xieyiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    xieyiButton.frame = CGRectMake(agreeLable.frame.origin.x + agreeLable.frame.size.width, agreeLable.frame.origin.y, 150, 20);
    [xieyiButton setTitle:xieyi forState:UIControlStateNormal];
    xieyiButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [xieyiButton setTitleColor:[UIColor colorWithRed:47.0/255.0 green:120.0/255.0 blue:200.0/255.0 alpha:1] forState:UIControlStateNormal];
    [xieyiButton addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xieyiButton];
    
}
-(void)tap:(UIButton *)tap
{
    XieYiViewController * xyv = [[XieYiViewController alloc]init];
    [self presentViewController:xyv animated:YES completion:nil];
}
-(void)registerClick:(UIButton *)button
{
//    SRViewController * sr = [[SRViewController alloc]init];
//    [self presentViewController:sr animated:YES completion:nil];

    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:_phoneField.text,@"mobile",_passwordField.text,@"password", nil];
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
         NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString * urlStr = [NSString stringWithFormat:@"%@users?udid=%@",URL_HOST,[[DeviceInfomationShare share] UUID]];

        //NSLog(@"%@",[[DeviceInfomationShare share] UUID]);
        NSURL * url = [NSURL URLWithString:urlStr];
       _registerRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [_registerRequest setRequestMethod:@"POST"];
        [_registerRequest setDelegate:self];
        [_registerRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        [_registerRequest setPostBody:tempJsonData];
        [_registerRequest startAsynchronous];
    }

}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
//    //移除加载框
//    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
//    [bd removeFromSuperview];
//    bd=nil;
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    //{"data":"F5505E7C-EA53-56A1-EFE0-CBC0D568BA13"}
    NSLog(@"注册第一页 responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    NSLog(@"注册第一页 statusCode %d",statusCode);
    if (statusCode == 201 ) {
        NSDictionary * dictory = [dic objectForKey:@"data"];
        NSString * session_id = [dictory objectForKey:@"auth_token"];
        LoginModel * model = [[LoginModel alloc]initDic:[dictory objectForKey:@"data"]];
        [LIUserDefaults userDefaultObject:[model dictionaryFromModelData] key:@"user"];
        NSLog(@"注册第一页 model = %@",model);

        [[NSUserDefaults standardUserDefaults]setObject:_phoneField.text forKey:@"userPhone"];
        [[NSUserDefaults standardUserDefaults]setObject:session_id forKey:@"session_id"];
        [[NSUserDefaults standardUserDefaults]setObject:[[DeviceInfomationShare share] UUID] forKey:@"uuid"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"FRegist session_id %@",[dic objectForKey:@"data"]);
        SRViewController * srv = [[SRViewController alloc]init];
        [self presentViewController:srv animated:YES completion:nil];

    }else if (statusCode == 409){
        MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"手机号已注册!";
        //HUD.detailsLabelText =[dic valueForKey:@"手机号已注册!"];
        HUD.mode = MBProgressHUDModeText;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2.0);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
    }else{
      //提示警告框失败...
        MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"密码为空,请输入密码!";
        //HUD.detailsLabelText =[dic valueForKey:@"密码为空,请输入密码!"];
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
    NSLog(@"注册第一页 请求失败 %@",[request responseString]);
    //去掉加载框
    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
    [bd removeFromSuperview];
    bd=nil;
    
    int statusCode = [request responseStatusCode];
    NSLog(@"注册第一页  请求失败  状态码 statusCode %d",statusCode);
        
    //提示警告框失败...
    MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"请检查网络连接";
        
    //HUD.detailsLabelText = @"请检查网络连接";
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"register"];
    }
    //cell.backgroundColor = [PRLColor colorWithHexadecimalRGB:@"#D7EBF6" alpha:1.0];
    if(indexPath.row==1)
    {
        cell.backgroundColor=[UIColor whiteColor];
        
        _phoneField = [[UITextField alloc] init];
        _phoneField.frame=CGRectMake(30, 5,260, 40);
        _phoneField.backgroundColor=[UIColor clearColor];
        _phoneField.delegate=self;
        _phoneField.placeholder=@"填写您的手机号";
        _phoneField.textColor=[UIColor grayColor];
        //phoneText.keyboardType=UIKeyboardTypeNumberPad;
        [cell.contentView addSubview:_phoneField
         ];
        
        
    }else if(indexPath.row==2)
    {
        cell.backgroundColor=[UIColor whiteColor];
        
        _passwordField = [[UITextField alloc] init];
        _passwordField.frame=CGRectMake(30, 5, 260, 40);
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
    [_phoneField resignFirstResponder];
    [_passwordField resignFirstResponder];
    return YES;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_passwordField resignFirstResponder];
    [_phoneField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
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
