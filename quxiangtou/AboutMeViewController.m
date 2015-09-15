//
//  AboutMeViewController.m
//  quxiangtou
//
//  Created by mac on 15/9/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSArray * purposeArray;
    ASIFormDataRequest * EditAboutMeRequest;
}
@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = color_alpha(229, 230, 231, 1);
    self.navigationController.navigationBar.translucent = NO;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"顶操04@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(updateMessage)];
    self.navigationItem.title = @"性信息编辑";
    
    purposeArray = @[@"未填写",@"交新朋友",@"聊天",@"约会"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}
-(void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return purposeArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *userCell = @"EditAboutMe";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:userCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", @"未填写"];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"我想%@", [purposeArray objectAtIndex:indexPath.row]];

    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    _purposeNumber = [NSNumber numberWithInt:indexPath.row];
}
-(void)updateMessage
{
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:_purposeNumber,@"purpose",nil];
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString * urlStr = [NSString stringWithFormat:@"%@users/update?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
        NSURL * url = [NSURL URLWithString:urlStr];
        EditAboutMeRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [EditAboutMeRequest setRequestMethod:@"POST"];
        [EditAboutMeRequest setDelegate:self];
        [EditAboutMeRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        [EditAboutMeRequest addRequestHeader:@"Authorization" value:Authorization];
        [EditAboutMeRequest setPostBody:tempJsonData];
        [EditAboutMeRequest startAsynchronous];
    }

    
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSLog(@"编辑关于我时 responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    NSLog(@"编辑关于我时 statusCode %d",statusCode);
    if (statusCode == 201 ) {
        ACommenData *data=[ACommenData sharedInstance];
        data.logDic = nil;
        NSLog(@"编辑关于我时 data.logDic 1 = %@",data.logDic);
        data.logDic=[dic valueForKey:@"data"]; //将登陆返回的数据存到一个字典对象里面...
        NSLog(@"编辑关于我时 data.logDic 2 = %@",data.logDic);
        if ([_delegate respondsToSelector:@selector(changePurpose:)]) {
            [_delegate changePurpose:_purposeNumber];
        }
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"用户信息更新成功"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
