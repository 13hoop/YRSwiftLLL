//
//  SeletionConditionViewController.m
//  quxiangtou
//
//  Created by mac on 15/9/26.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "SeletionConditionViewController.h"
@interface SeletionConditionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * headerArray;
    NSMutableArray * titleArray;
    UITableView * _tableView;
    BOOL isHandsome;
    BOOL isBeauty;
    UILabel * maxAgeLabel;
    NSInteger carType;
    UISlider * slider;
    int maxAge;
    NSArray * firstArray;
    ASIFormDataRequest * saveSeletionRequest;
}
@property (nonatomic,strong) NSMutableArray * array_01;
@property (nonatomic,assign) int index;

@end

@implementation SeletionConditionViewController
//- (NSArray *) array_01{
//    
//   
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    firstArray = @[@"交新朋友",@"聊天",@"约会"];
    carType = 0;
    
    self.view.backgroundColor = color(239, 239, 244);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"顶操04@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSeletion)];
    self.navigationItem.title = @"筛选条件";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_array_01 == nil) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"genderNumber"] intValue] == 0) {
            _array_01 = [NSMutableArray arrayWithObjects:@"0",@"0",nil];
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"genderNumber"] intValue] == 1){
            _array_01 = [NSMutableArray arrayWithObjects:@"0",@"1",nil];
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"genderNumber"] intValue] == 2){
            _array_01 = [NSMutableArray arrayWithObjects:@"1",@"0",nil];
        }else{
            _array_01 = [NSMutableArray arrayWithObjects:@"1",@"1",nil];
        }
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"purposeNumber"]intValue] != 0) {
        _index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"purposeNumber"] intValue];
    }else{
        _index = 0;
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"maxAge"] intValue] != 0) {
        maxAge = [[[NSUserDefaults standardUserDefaults] objectForKey:@"maxAge"] intValue];
    }else{
        maxAge = 22;
    }
    [_tableView reloadData];
}
-(void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveSeletion
{
    NSString * ageString = [NSString stringWithFormat:@"18,%d",maxAge];
    NSNumber * purposeNumber = [NSNumber numberWithInt:_index + 1];
    NSLog(@"年龄段 = %@",ageString);
    NSLog(@"目的  = %d",_index + 1);
    NSNumber * gender = nil;
    if ([[_array_01 objectAtIndex:0] intValue] == 0 && [[_array_01 objectAtIndex:1] intValue] == 0) {
        gender = [NSNumber numberWithInt:0];
    }else if ([[_array_01 objectAtIndex:0] intValue] == 0 && [[_array_01 objectAtIndex:1] intValue] == 1){
        gender = [NSNumber numberWithInt:1];
    }else if ([[_array_01 objectAtIndex:0] intValue] == 1 && [[_array_01 objectAtIndex:1] intValue] == 0){
        gender = [NSNumber numberWithInt:2];
    }
    NSLog(@"性别 = %@",_array_01);
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:ageString,@"age",purposeNumber,@"purpose",gender,@"gender", nil];
    NSLog(@"user = %@",user);
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        
        NSString * urlStr = [NSString stringWithFormat:@"%@users/save_filter?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
        NSLog(@"筛选条件 = %@",urlStr);
        NSURL * url = [NSURL URLWithString:urlStr];
        saveSeletionRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [saveSeletionRequest setRequestMethod:@"POST"];
        
        //1、header
        [saveSeletionRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //2、header
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        NSLog(@"更新用户位置 Authorization%@",Authorization);
        [saveSeletionRequest addRequestHeader:@"Authorization" value:Authorization];
        
        [saveSeletionRequest setDelegate:self];
        [saveSeletionRequest setPostBody:tempJsonData];
        saveSeletionRequest.tag = 101;
        [saveSeletionRequest startAsynchronous];
    }

}
#pragma mark - 更多图片响应请求的请求成功回调
//获取黑名单
- (void)requestFinished:(ASIHTTPRequest *)request {
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic4=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSLog(@"我的黑名单 responseString %@",[dic4 objectForKey:@"data"]);
    int statusCode = [request responseStatusCode];
    //我的中心 获取图片列表 statusCode 204
    NSLog(@"我的黑名单 statusCode %d",statusCode);
    if (request.tag == 101) {
        if (statusCode == 201 ) {
            NSNumber * purposeNumber = [NSNumber numberWithInt:_index + 1];
            NSNumber * genderNumber = nil;
            if ([[_array_01 objectAtIndex:0] intValue] == 0 && [[_array_01 objectAtIndex:1] intValue] == 0) {
                genderNumber = [NSNumber numberWithInt:0];
            }else if ([[_array_01 objectAtIndex:0] intValue] == 0 && [[_array_01 objectAtIndex:1] intValue] == 1){
                genderNumber = [NSNumber numberWithInt:1];
            }else if ([[_array_01 objectAtIndex:0] intValue] == 1 && [[_array_01 objectAtIndex:1] intValue] == 0){
                genderNumber = [NSNumber numberWithInt:2];
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:maxAge] forKey:@"maxAge"];
            [[NSUserDefaults standardUserDefaults]setObject:purposeNumber forKey:@"purposeNumber"];
            [[NSUserDefaults standardUserDefaults]setObject:genderNumber forKey:@"genderNumber"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"筛选条件上传成功"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
            
        }else if (statusCode == 400){
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:[[dic4 objectForKey:@"errors"] objectForKey:@"code"]
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
            
        }
        
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        if (carType==0) {
            return 1;
        }else if(carType == 1){   //保养
            return 3;
        }
        return 0;
        
        
    }else if(section==1){
        return 2;
        
    }else if(section == 2){
        return 2;
    }else{
        return 1;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray * array = @[@"我想",@"和谁?",@"年龄",@"在哪里?"];
    return [array objectAtIndex:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 44.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
    if (indexPath.section == 0 ) {
        if (carType== 1) {
            // 重用机制，如果选中的行正好要重用
            if (_index == indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        if (indexPath.row == 0) {
            
            if (carType == 0) {
                if (_index == 0) {
                    cell.textLabel.text = [firstArray objectAtIndex:_index];

                }else{
                    cell.textLabel.text = [firstArray objectAtIndex:_index-1];
                }
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(Screen_width - 25, 25, 10, 10);
                [cell.contentView addSubview:button];
                UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
                imageView.image = [UIImage imageNamed:@"矩形 13 拷贝 2@2x.png"];
                [button addSubview:imageView];
            }else{
                cell.textLabel.text = @"交新朋友";
            }
            
        }
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"交新朋友";
//        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"聊天";
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"约会";
        }
    }
    if (indexPath.section == 1) {
        NSString * cellid = self.array_01[indexPath.row];
        //0  表示选中了   1  表示未选中
        if (![cellid isEqualToString:@"1"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            //没有点中
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"和一位帅哥";
            
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"和一位美女";
        }
        
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 74, 34)];
            label1.text = @"显示18到";
            [cell.contentView addSubview:label1];
            
            maxAgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x + label1.frame.size.width, 5, 22,34)];
            //maxAgeLabel.backgroundColor = [UIColor yellowColor];
            maxAgeLabel.textColor = [UIColor redColor];
            maxAgeLabel.text = [NSString stringWithFormat:@"%d",maxAge];
            [cell.contentView addSubview:maxAgeLabel];
            
            UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(maxAgeLabel.frame.size.width + maxAgeLabel.frame.origin.x, 5, 100, 34 )];
            label2.text = @"的会员";
            [cell.contentView addSubview:label2];
            
        }
        if (indexPath.row == 1) {
            // 滑动条 高是固定的，可以设置宽度。
            slider = [[UISlider alloc] initWithFrame:CGRectMake(15, 10, self.view.frame.size.width - 30, 20)];
            // 设置滑动条的最小值和最大值。
            slider.minimumValue = 0;
            slider.maximumValue = 90;
            // 设置滑块当前的值。
            slider.value = 18+(([[[NSUserDefaults standardUserDefaults] objectForKey:@"maxAge"] intValue] - 18) * 3);
            // UISlider是继承与UIControl的，所以可以响应事件(值改变)
            [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
            slider.maximumTrackTintColor = color_alpha(192, 200, 207, 1);
            slider.minimumTrackTintColor = color_alpha(70, 152, 255, 1);
            [slider setThumbImage:[UIImage imageNamed:@"009"] forState:UIControlStateNormal];
            slider.tag = 100;
            [cell.contentView addSubview:slider];
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"附近会员";
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(Screen_width - 25, 25, 10, 10);
            [cell.contentView addSubview:button];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
            imageView.image = [UIImage imageNamed:@"矩形 13 拷贝 2@2x.png"];
            [button addSubview:imageView];
        }
        
        
    }
    
    return cell;
    
}
-(void)buttonClick:(UIButton *)button
{
    if (button.tag == 1) {
        [button setBackgroundImage:[UIImage imageNamed:@"矩形 13 拷贝@2x.png"] forState:UIControlStateNormal];
    }
    
    NSLog(@"%ld",(long)button.tag);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        carType = 1;
    }
    if (carType == 1 && indexPath.section == 0) {
        // 取消前一个选中的，就是单选啦
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_index inSection:0];
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndex];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
        
        // 选中操作
        UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSLog(@"组1 选中%@",cell.textLabel.text);
        // 保存选中的
        _index = indexPath.row;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
    }
    if (indexPath.section == 1) {
        UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType ==UITableViewCellAccessoryNone){
            NSLog(@"组2 选中%@",cell.textLabel.text);
            self.array_01[indexPath.row] = @"0";
            cell.accessoryType =UITableViewCellAccessoryCheckmark;
        }
        else{
            self.array_01[indexPath.row] = @"1";
            cell.accessoryType =UITableViewCellAccessoryNone;
        }
        
    }
    [_tableView reloadData];
    
}
- (void)valueChanged:(UISlider *)slider1
{
    
    maxAge = 18 + slider1.value / 3;
    NSLog(@"%d",maxAge);
    maxAgeLabel.text = [NSString stringWithFormat:@"%d",maxAge];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [saveSeletionRequest setDelegate:nil];
    [saveSeletionRequest cancel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
