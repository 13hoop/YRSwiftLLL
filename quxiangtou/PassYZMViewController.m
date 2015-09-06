//
//  PassYZMViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/13.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "PassYZMViewController.h"

@interface PassYZMViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UILabel * label1;
    UIButton * loginButton;
    UIImageView * imageView;
}

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UITextField * yanzmField;

@end

@implementation PassYZMViewController

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
    titleLabel.text = @"找回密码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navigationView addSubview:titleLabel];
    
}
-(void)createUI
{
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width / 2 - 50, 85, 100, 100)];
    imageView.image = [UIImage imageNamed:@"成功@2x.png"];
    imageView.hidden = YES;
    [self.view addSubview:imageView];
    
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, Screen_width, 30)];
    label1.text = @"设置新密码";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.hidden = NO;
    label1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, label1.frame.size.height+label1.frame.origin.y+ 25, Screen_width, 1)];
    label2.backgroundColor = color_alpha(177, 177, 177, 1);
    [self.view addSubview:label2];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, label2.frame.size.height + label2.frame.origin.y , Screen_width, 50)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    _yanzmField = [[UITextField alloc] init];
    _yanzmField.frame=CGRectMake(15, 5,Screen_width - 30, 40);
    _yanzmField.backgroundColor=[UIColor clearColor];
    _yanzmField.delegate=self;
    _yanzmField.placeholder=@"请输入新密码";
    _yanzmField.textColor=[UIColor grayColor];
    _yanzmField.keyboardType=UIKeyboardTypeNumberPad;
    [view addSubview:_yanzmField
     ];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height + view.frame.origin.y, Screen_width, 1)];
    label3.backgroundColor = color_alpha(177, 177, 177, 1);
    [self.view addSubview:label3];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(20, label3.frame.size.height+label3.frame.origin.y + 20, Screen_width - 30, 40);
    [loginButton setTitle:@"完成" forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 6;
    loginButton.layer.masksToBounds = YES;
    loginButton.backgroundColor = [UIColor redColor];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
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
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:_yanzmField.text,@"password", nil];
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString * urlStr = [NSString stringWithFormat:@"%@users/update?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid" ]];
        NSURL * url = [NSURL URLWithString:urlStr];
        loginRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [loginRequest setRequestMethod:@"POST"];
        [loginRequest setDelegate:self];
        [loginRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"]];
        [loginRequest addRequestHeader:@"Authorization" value:Authorization];
        [loginRequest setPostBody:tempJsonData];
        [loginRequest startAsynchronous];
    }


}
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSLog(@"找回密码中 responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    NSLog(@"找回密码中 statusCode %d",statusCode);
    if (statusCode == 204 ) {
        imageView.hidden = NO;
        label1.hidden = YES;
        _tableView.hidden = YES;
        [loginButton setTitle:@"新密码设置成功" forState:UIControlStateNormal];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_yanzmField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_yanzmField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
