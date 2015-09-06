//
//  ViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/7/24.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "XieHouTableViewCell.h"
#import "LoginModel.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * listTable;
    NSMutableDictionary * dic;
    NSString * nickName;
    NSString * ageString;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ACommenData * data = [ACommenData sharedInstance];
    dic = [data.logDic objectForKey:@"meet"];
    nickName = [dic objectForKey:@"nickname"];
    
    self.navigationController.navigationBarHidden = YES;
    
//    UIButton * tuichu = [UIButton buttonWithType:UIButtonTypeCustom];
//    tuichu.frame = CGRectMake(150, 100, 100, 50);
//    [tuichu setTitle:@"推出" forState:UIControlStateNormal];
//    tuichu.backgroundColor = [UIColor yellowColor];
//    [tuichu addTarget:self action:@selector(tuichu:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:tuichu];
    
    [self createNavigationBar];
    [self createUI];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)createNavigationBar
{
    UIView * navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64)];
    navigationView.userInteractionEnabled = YES;
    navigationView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    [self.view addSubview:navigationView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 25, 35, 35);
    [button setBackgroundImage:[UIImage imageNamed:@"顶操01@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:button];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width / 2 -40, 30, 80, 30)];
    titleLabel.text = @"首页";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navigationView addSubview:titleLabel];
    
}
-(void)showLeft
{
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
    [dd showLeftController:YES];
}
-(void)createUI
{
    UIImageView * topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, 184)];
    NSString * string = [[NSUserDefaults standardUserDefaults] objectForKey:@"touxiangurl"];
    NSLog(@"topImage%@",[dic objectForKey:@"avatar"]);
    if ([[dic objectForKey:@"avatar"] isKindOfClass:[NSNull class]]) {
        [topImage setImage:[UIImage imageNamed:@"美女01.jpg"]];
    }else{
        [topImage sd_setImageWithURL:[NSURL URLWithString:string]];
    }
    topImage.userInteractionEnabled = YES;
    [self.view addSubview:topImage];
    
    UIImageView * cameraButton = [[UIImageView alloc]initWithFrame:CGRectMake(10, topImage.frame.origin.y + topImage.frame.size.height - 95, 36.5, 25)];
    cameraButton.userInteractionEnabled = YES;
    cameraButton.image = [UIImage imageNamed:@"相机 00@2x.png"];
    [topImage addSubview:cameraButton];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto)];
    [cameraButton addGestureRecognizer:tap];
    
    UIImageView * messageButton = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width - 25 - 10, topImage.frame.origin.y + topImage.frame.size.height - 95, 27, 25)];
    messageButton.userInteractionEnabled = YES;
    messageButton.image = [UIImage imageNamed:@"信息@2x.png"];
    [topImage addSubview:messageButton];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(messageClick)];
    [messageButton addGestureRecognizer:tap2];
    
    UIImageView * fingerButton = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width / 2 - 70, topImage.frame.size.height - 65, 60, 60)];
    fingerButton.userInteractionEnabled = YES;
    fingerButton.image = [UIImage imageNamed:@"点赞@2x.png"];
    [topImage addSubview:fingerButton];
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fingerClick)];
    [fingerButton addGestureRecognizer:tap3];
    
    UIImageView * footButton = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width / 2 + 10,topImage.frame.size.height - 65, 60, 60)];
    footButton.userInteractionEnabled = YES;
    footButton.image = [UIImage imageNamed:@"踩@2x.png"];
    [topImage addSubview:footButton];
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(footClick)];
    [footButton addGestureRecognizer:tap4];
    
    listTable=[[UITableView alloc]initWithFrame:CGRectMake(0,topImage.frame.size.height + 64, self.view.frame.size.width,Screen_height-topImage.frame.size.height-65) style:UITableViewStyleGrouped];
    listTable.delegate=self;
    listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    listTable.dataSource=self;
    [self.view addSubview:listTable];
    
    
    
}
-(void)addPhoto
{
    
}
-(void)messageClick
{
    
}
-(void)fingerClick
{
    
}
-(void)footClick
{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XieHouTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"xiehou"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XieHouTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //当前位置
    if (indexPath.row == 0) {
        cell.topicImageView.image = [UIImage imageNamed:@"定位@2x.png"];
        cell.topicLabel.text = @"当前位置";
        NSString * address = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"province"],[dic objectForKey:@"city"]];
        cell.detailTextLabel.text = address;
    }
    //生日
    if (indexPath.row == 1) {
        cell.topicImageView.image = [UIImage imageNamed:@"爱好@2x.png"];
        cell.topicLabel.text = @"生日";
        cell.contenceLabel.text = [dic objectForKey:@"birthday"];
    }
    //性别
    if (indexPath.row == 2) {
        cell.topicImageView.image = [UIImage imageNamed:@"关于我@2x.png"];
        cell.topicLabel.text = @"性别";
        //[dic objectForKey:@"gender"]
        NSInteger num = [[dic objectForKey:@"gender"] integerValue];
        NSLog(@"num = %ld",(long)num);
        NSNumber * num1 = [NSNumber numberWithInteger:num];
        NSLog(@"num1 = %@",num1);
        NSString * gender = [BasicInformation getGender:num1];
        NSLog(@"gender = %@",gender);
        
        cell.contenceLabel.text = gender;
    }
    //手机号
    if (indexPath.row == 3) {
        cell.topicImageView.image = [UIImage imageNamed:@"职业@2x.png"];
        cell.topicLabel.text = @"手机号";
        cell.contenceLabel.text = [dic objectForKey:@"mobile"];
    }
    //交友目的
    if (indexPath.row == 4) {
        cell.topicImageView.image = [UIImage imageNamed:@"职业@2x.png"];
        cell.topicLabel.text = @"交友目的";
        NSInteger num = [[dic objectForKey:@"purpose"] integerValue];
        NSNumber * num1 = [NSNumber numberWithInteger:num];
        NSString * purpose = [BasicInformation getPurpose:num1];
        NSLog(@"purpose = %@",purpose);
        cell.contenceLabel.text = purpose;
    }
    //性爱时长
    if (indexPath.row == 5) {
        cell.topicImageView.image = [UIImage imageNamed:@"爱好@2x.png"];
        cell.topicLabel.text = @"性爱时长";
        //[dic objectForKey:@"gender"]
        NSInteger num = [[dic objectForKey:@"sexual_duration"] integerValue];
        NSNumber * num1 = [NSNumber numberWithInteger:num];
        NSString * sexual_duration = [BasicInformation getSexual_duration:num1];
        NSLog(@"sexual_duration = %@",sexual_duration);
        cell.contenceLabel.text = sexual_duration;
    }
    //性频率
    if (indexPath.row == 6) {
        cell.topicImageView.image = [UIImage imageNamed:@"关于我@2x.png"];
        cell.topicLabel.text = @"性频率";
        NSString * string = [NSString stringWithFormat:@"一周%@次",[dic objectForKey:@"sexual_frequency"]];
        cell.contenceLabel.text = string;
    }
    //性取向
    if (indexPath.row == 7) {
        cell.topicImageView.image = [UIImage imageNamed:@"职业@2x.png"];
        cell.topicLabel.text = @"性取向";
        //[dic objectForKey:@"gender"]
        NSInteger num = [[dic objectForKey:@"sexual_orientation"] integerValue];
        NSLog(@"num = %ld",(long)num);
        NSNumber * num1 = [NSNumber numberWithInteger:num];
        NSLog(@"num1 = %@",num1);
        NSString * sexual_orientation = [BasicInformation getSexual_orientation:num1];
        NSLog(@"sexual_orientation = %@",sexual_orientation);
        
        cell.contenceLabel.text = sexual_orientation;
    }
    //体位
    if (indexPath.row == 8) {
        cell.topicImageView.image = [UIImage imageNamed:@"职业@2x.png"];
        cell.topicLabel.text = @"体位";
        NSInteger num = [[dic objectForKey:@"sexual_position"] integerValue];
        NSLog(@"num = %ld",(long)num);
        NSNumber * num1 = [NSNumber numberWithInteger:num];
        NSLog(@"num1 = %@",num1);
        NSString * sexual_position = [BasicInformation getSexual_position:num1];
        NSLog(@"sexual_orientation = %@",sexual_position);
        
        cell.contenceLabel.text = sexual_position;
    }
    
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, Screen_width - 20, 44)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 44)];
    name.text = @"张三";
    name.textAlignment = NSTextAlignmentLeft;
    [view addSubview:name];
    
    UILabel * age = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width - 100, 0, 100, view.frame.size.height)];
    age.textAlignment = NSTextAlignmentRight;
    age.text = [NSString stringWithFormat:@"25"];
    [view addSubview:age];
    return view;
    
}
//-(void)tuichu:(UIButton *)button
//{
//    NSString * urlStr = [NSString stringWithFormat:@"%@sessions/delete?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid" ]];
//    NSURL * url = [NSURL URLWithString:urlStr];
//    quitRequest = [[ASIFormDataRequest alloc]initWithURL:url];
//    [quitRequest setRequestMethod:@"POST"];
//    [quitRequest setDelegate:self];
//    [quitRequest addRequestHeader:@"Content-Type" value:@"application/json"];
//    NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"session_id" ]];
//    [quitRequest addRequestHeader:@"Authorization" value:Authorization];
//    [quitRequest startAsynchronous];
//    
//}
/**
 *  请求完成
 *
 *  @param request 请求
 */
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    //解析接收回来的数据
    //    NSString *responseString=[request responseString];
    //    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSLog(@"quitViewController responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    NSLog(@"quitViewController statusCode %d",statusCode);
    if (statusCode == 204 ) {
        //提示警告框失败...
        MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"退出成功!";
        // HUD.detailsLabelText =[dic valueForKey:@"return_content"];
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
        HUD.labelText = @"抱歉";
        // HUD.detailsLabelText =[dic valueForKey:@"return_content"];
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
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
