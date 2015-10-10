//
//  YZMLoginViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/10.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "YZMLoginViewController.h"
#import "SYZMViewController.h"
@interface YZMLoginViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UILabel * phoneLabel;
@property (nonatomic,strong) UITextField * yanzmField;
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation YZMLoginViewController

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
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 30, 50, 25);
    backButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [backButton setTitleColor:color_alpha(101.0, 177.0, 229.0, 1) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width / 2 -60, 30, 120, 30)];
    titleLabel.text = @"验证码登录";
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
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.backgroundColor = color_alpha(87.0, 169.0, 255.0, 1);
    loginButton.layer.cornerRadius = 6;
    loginButton.layer.masksToBounds = YES;
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
    if (_yanzmField.text.length != 11) {
      
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"手机号位数错误!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
    }else if ([ACommenData validatePhone:_yanzmField.text]== NO){
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"手机号格式不正确!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
    }else{
    SYZMViewController * sy = [[SYZMViewController alloc]init];
    sy.phoneString = _yanzmField.text;
    sy.pageName = @"YZM";
    [self presentViewController:sy animated:YES completion:nil];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YZMLogin"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    _yanzmField = [[UITextField alloc]initWithFrame:CGRectMake(30, 10, 250, 30)];
    _yanzmField.placeholder = @"请输入您的手机号";
    _yanzmField.backgroundColor=[UIColor clearColor];
    _yanzmField.delegate=self;
    _yanzmField.textColor = [UIColor grayColor];
    _yanzmField.keyboardType = UIKeyboardTypeNumberPad;

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
