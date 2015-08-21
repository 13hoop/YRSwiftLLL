//
//  RecoveryPasswordViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/13.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "RecoveryPasswordViewController.h"
#import "SYZMViewController.h"

@interface RecoveryPasswordViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UITextField * phoneField;
@end

@implementation RecoveryPasswordViewController

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
    [backButton setTitleColor:color_alpha(47.0, 120.0, 200.0,1) forState:UIControlStateNormal];
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
    label1.text = @"请输入注册或绑定趣相投的手机号,";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor grayColor];
    label1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, label1.frame.size.height+label1.frame.origin.y + 5, Screen_width, 30)];
    label2.text = @"以收取验证码。";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor grayColor];
    label2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label2];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, label2.frame.size.height+label2.frame.origin.y+ 25, Screen_width, 50) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.backgroundColor = color_alpha(239, 239, 244,1);

    _tableView.scrollEnabled = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(_tableView.separatorInset.top, 0, _tableView.separatorInset.bottom, 0);
    }
    [self.view addSubview:_tableView];
    
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(20, _tableView.frame.size.height+_tableView.frame.origin.y + 20, Screen_width - 30, 40);
    [loginButton setTitle:@"确定" forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 6;
    loginButton.layer.masksToBounds = YES;
    loginButton.backgroundColor = color_alpha(87.0, 169.0, 255.0, 1);
    loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    SYZMViewController * sy = [[SYZMViewController alloc]init];
    sy.phoneString = _phoneField.text;
    sy.pageName = @"password";
    [self presentViewController:sy animated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recoverypassword"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(30, 10, 250, 30)];
    _phoneField.placeholder = @"请输入您的手机号";
    _phoneField.backgroundColor=[UIColor clearColor];
    _phoneField.delegate=self;
    _phoneField.textColor = [UIColor grayColor];
    [cell.contentView addSubview:_phoneField];
    return cell;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_phoneField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
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
