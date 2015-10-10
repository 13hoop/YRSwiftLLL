//
//  MyEditViewController.m
//  quxiangtou
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "MyEditViewController.h"

@interface MyEditViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    // 保存每一组的展开还是关闭的状态
    NSMutableArray *_statusArray;
//    NSNumber * genderNumber;
//    NSNumber * sex_positionNumber;
//    NSNumber * sex_orientionNumber;
//    NSNumber * sex_frequencyNumber;
//    NSNumber * sex_dureationNumber;
    UILabel * label2;
    UILabel * label3;
    UILabel * label4;
    UILabel * label5;
    UILabel * label6;
   
}



@end

@implementation MyEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = color_alpha(229, 230, 231, 1);
    self.navigationController.navigationBar.translucent = NO;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"顶操04@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(updateMessage)];
    self.navigationItem.title = @"性信息编辑";
    
    [self createUI];
}

-(void)createUI
{
    _dataArray = [[NSMutableArray alloc] init];
    // 创建数组的时候，同时创建，记录每组状态的数组。
    _statusArray = [[NSMutableArray alloc] init];
    NSArray * arr1 = @[@"未填写",@"男",@"女"];
    NSArray * arr4 = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    NSArray * arr3 = @[@"未填写",@"我爱同性",@"我爱异性",@"我男女都爱"];
    NSArray * arr2 = @[@"未填写",@"男上",@"女上",@"后入",@"侧卧"];
    NSArray * arr5 = @[@"未填写",@"5分钟",@"15分钟",@"30分钟",@"45分钟",@"60分钟",@"120分钟"];
    [_dataArray addObject:arr1];
    [_dataArray addObject:arr2];
    [_dataArray addObject:arr3];
    [_dataArray addObject:arr4];
    [_dataArray addObject:arr5];
    [_statusArray addObject:@"NO"];
    [_statusArray addObject:@"NO"];
    [_statusArray addObject:@"NO"];
    [_statusArray addObject:@"NO"];
    [_statusArray addObject:@"NO"];
 


    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *status = [_statusArray objectAtIndex:section];
    if ([status isEqualToString:@"YES"]) {
        NSArray *subArray = [_dataArray objectAtIndex:section];
        return subArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *userCell = @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:userCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSMutableArray *subArray = [_dataArray objectAtIndex:indexPath.section];
    
    if (indexPath.section == 3) {
        NSString * string = [NSString stringWithFormat:@"一周%@次",[subArray objectAtIndex:indexPath.row]];
        cell.textLabel.text = string;
    }else{
       cell.textLabel.text = [subArray objectAtIndex:indexPath.row];
    }
    return cell;
}

// 设置组头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}


// 设置组头的视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *array = @[@"性别",  @"体位", @"性取向",@"性爱频率", @"性爱时长"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 44)];
    view.backgroundColor = color_alpha(229, 230, 231, 1);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    button.tag = section+100;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width - 20, 25, 10, 10)];
    imageView1.image = [UIImage imageNamed:@"矩形 13 拷贝 2@2x.png"];
    imageView1.userInteractionEnabled = YES;
    [view addSubview:imageView1];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 80, 30)];
    label1.text =  [array objectAtIndex:section];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.textColor = [UIColor blackColor];
    [button addSubview:label1];
    
    
    if (section == 0) {
        label2 = [[UILabel alloc]initWithFrame:CGRectMake(120, 7, 100, 30)];
        label2.textColor = [UIColor blueColor];
        label2.text = [BasicInformation getGender:_genderNumber];
        [view addSubview:label2];
    }else if (section == 1){
        label3 = [[UILabel alloc]initWithFrame:CGRectMake(120, 7, 100, 30)];
        label3.textColor = [UIColor blueColor];
        label3.text = [BasicInformation getSexual_position:_sexual_positionNumber];
        [view addSubview:label3];
    }else if (section == 2){
        label4 = [[UILabel alloc]initWithFrame:CGRectMake(120, 7, 100, 30)];
        label4.textColor = [UIColor blueColor];
        label4.text = [BasicInformation getSexual_orientation:_sexual_orientationNumber];
        [view addSubview:label4];
    }else if (section == 3){
        label5 = [[UILabel alloc]initWithFrame:CGRectMake(120, 7, 100, 30)];
        label5.textColor = [UIColor blueColor];
        NSString * string = [NSString stringWithFormat:@"一周%@次",_sexual_frequencyNumber];
        label5.text = string;
        [view addSubview:label5];
    }else{
        label6 = [[UILabel alloc]initWithFrame:CGRectMake(120, 7, 100, 30)];
        label6.textColor = [UIColor blueColor];
       label6.text = [BasicInformation getSexual_duration:_sexual_durationNumber];
        [view addSubview:label6];
    }
    
    return view;
}

- (void)buttonClick:(UIButton *)button
{
    NSInteger index = button.tag-100;
    if ([[_statusArray objectAtIndex:index] isEqualToString:@"YES"]) {
        [_statusArray replaceObjectAtIndex:index withObject:@"NO"];
    } else {
        [_statusArray replaceObjectAtIndex:index withObject:@"YES"];
    }
    // NSIndexSet 是一个数字的集合类。(保存的就是一个个的数字)
    // 用一个index，来创建一个集合。这个集合里，只有一个数，就是index!
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    // 这个方法，只刷新组(一个或多个组)，对于我们这个例子，只需要刷新index对应的组，就可以了! 方法的第二个参数，是刷新动画。
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

// 这个方法是tableView被选中的时候调用的方法。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section == 0) {
         label2.textColor = [UIColor redColor];
        _genderNumber = [NSNumber numberWithInteger:indexPath.row];
        label2.text= [BasicInformation getGender:_genderNumber];
        NSLog(@"genderNumber%@",_genderNumber);
    }
    if (indexPath.section == 1){
         label3.textColor = [UIColor redColor];
        _sexual_positionNumber = [NSNumber numberWithInteger:indexPath.row];
        label3.text = [BasicInformation getSexual_position:_sexual_positionNumber];
        NSLog(@"sex_positionNumber%@",_sexual_positionNumber);
    }
    if (indexPath.section == 2){
         label4.textColor = [UIColor redColor];
        _sexual_orientationNumber = [NSNumber numberWithInteger:indexPath.row];
        label4.text = [BasicInformation getSexual_orientation:_sexual_orientationNumber];
        NSLog(@"sex_orientionNumber%@",_sexual_orientationNumber);
    }
    if (indexPath.section == 3){
         label5.textColor = [UIColor redColor];
        _sexual_frequencyNumber = [NSNumber numberWithInteger:indexPath.row];
        NSString * string = [NSString stringWithFormat:@"一周%ld次",(long)indexPath.row];
        label5.text = string;
    }
    if (indexPath.section == 4){
         label6.textColor = [UIColor redColor];
        if (indexPath.row == 0) {
            _sexual_durationNumber = [NSNumber numberWithInteger:0];
        }else if (indexPath.row == 1){
            _sexual_durationNumber = [NSNumber numberWithInteger:5];
        }else if (indexPath.row == 2){
            _sexual_durationNumber = [NSNumber numberWithInteger:15];
        }else if (indexPath.row == 3){
            _sexual_durationNumber = [NSNumber numberWithInteger:30];
        }else if (indexPath.row == 4){
            _sexual_durationNumber = [NSNumber numberWithInteger:45];
        }else if (indexPath.row == 5){
            _sexual_durationNumber = [NSNumber numberWithInteger:60];
        }else if (indexPath.row == 6){
            _sexual_durationNumber = [NSNumber numberWithInteger:120];
        }
        
        label6.text = [BasicInformation getSexual_duration:_sexual_durationNumber];
        NSLog(@"sex_dureationNumber%@",_sexual_durationNumber);
    }
    

}
-(void)updateMessage
{
     NSDictionary * user1 = [[NSDictionary alloc]initWithObjectsAndKeys:_genderNumber,@"gender",_sexual_positionNumber,@"sexual_position",
        _sexual_orientationNumber,@"sexual_orientation",
        _sexual_frequencyNumber ,@"sexual_frequency",
        _sexual_durationNumber,@"sexual_duration",
                            nil];
    
    NSLog(@"性信息 编辑 user = %@",user1);
    if ([NSJSONSerialization isValidJSONObject:user1]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user1 options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString * urlStr = [NSString stringWithFormat:@"%@users/update?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
        NSURL * url = [NSURL URLWithString:urlStr];
        updataMessageRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [updataMessageRequest setRequestMethod:@"POST"];
        [updataMessageRequest setDelegate:self];
        [updataMessageRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        [updataMessageRequest addRequestHeader:@"Authorization" value:Authorization];
        [updataMessageRequest setPostBody:tempJsonData];
        [updataMessageRequest startAsynchronous];
    }

}
- (void)requestFinished:(ASIHTTPRequest *)request {
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSLog(@"编辑性信息 responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    NSLog(@"编辑性信息 statusCode %d",statusCode);
    if (statusCode == 201 ) {
        ACommenData *data=[ACommenData sharedInstance];
        data.logDic = nil;
        NSLog(@"编辑性信息 data.logDic 1 = %@",data.logDic);
        data.logDic=[dic valueForKey:@"data"]; //将登陆返回的数据存到一个字典对象里面...
        NSLog(@"编辑性信息 data.logDic 2 = %@",data.logDic);
        if ([_delegate respondsToSelector:@selector(giveGender:Gexual_frequencyString:Sexual_durationString:Sexual_orientationString:Sexual_positionString:)]) {
            [_delegate giveGender:_genderNumber Gexual_frequencyString:_sexual_frequencyNumber Sexual_durationString:_sexual_durationNumber Sexual_orientationString:_sexual_orientationNumber Sexual_positionString:_sexual_positionNumber];
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

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
-(void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [updataMessageRequest setDelegate:nil];
    [updataMessageRequest cancel];
}


@end
