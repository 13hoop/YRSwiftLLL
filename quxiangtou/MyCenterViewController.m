//
//  MyCenterViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "MyCenterViewController.h"
#import "XieHouTableViewCell.h"
#import "LoginModel.h"
#import "UIImageView+WebCache.h"

@interface MyCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * listTable;
    NSMutableDictionary * dic;
}


@end

@implementation MyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    dic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"loginModel"] objectForKey:@"meet"];
    NSLog(@"dic = %@",dic);
    self.navigationController.navigationBarHidden = YES;
   
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    [self createNavigationBar];
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
    titleLabel.text = @"个人中心";
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
    UIImageView * topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, 144)];
    NSLog(@"topImage%@",[dic objectForKey:@"avatar"]);
    //[topImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]]];
    [topImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"美女01.jpg"]];
    [self.view addSubview:topImage];
    
    listTable=[[UITableView alloc]initWithFrame:CGRectMake(0,topImage.frame.size.height + 64, self.view.frame.size.width,Screen_height-topImage.frame.size.height-65) style:UITableViewStyleGrouped];
    listTable.delegate=self;
    listTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    listTable.dataSource=self;
    [self.view addSubview:listTable];
    //[listTable registerClass:[XieHouTableViewCell class] forCellWithReuseIdentifier:@"XieHouTableViewCell"];
    
    
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
    return 20;
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
    if (indexPath.row == 0) {
        cell.topicImageView.image = [UIImage imageNamed:@"关于我@2x.png"];
        cell.topicLabel.text = @"关于我";
        
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, Screen_width - 20, 44)];
    view.backgroundColor = [UIColor yellowColor];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
