//
//  SeletionConditionViewController.m
//  quxiangtou
//
//  Created by mac on 15/9/26.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "SeletionConditionViewController.h"
#import "BAddressPickerController.h"
@interface SeletionConditionViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
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
    NSString * cityString;
}
@property (nonatomic,strong) NSMutableArray * array_01;
@property (nonatomic,assign) int index;
@property (nonatomic,assign) int who;
@property (nonatomic,assign) int where;

@end

@implementation SeletionConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    cityString = @"";
    firstArray = @[@"我想交新朋友",@"我要结婚",@"我要约会"];
    carType = 0;
    _index = 0;
    _who = 0;
    _where = 0;

    self.view.backgroundColor = color(239, 239, 244);
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setImage:[[UIImage imageNamed:@"顶操04@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 50, 39);
    [backButton addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,btn_right, nil];
    
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

    _who = [[[NSUserDefaults standardUserDefaults] objectForKey:@"genderNumber"] intValue];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"genderNumber"]intValue] != 0) {
        _who = [[[NSUserDefaults standardUserDefaults] objectForKey:@"genderNumber"] intValue];
    }else{
        _who = 0;
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
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"cityString"] isEqual:@""]) {
        cityString = @"";
    }else{
        cityString = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityString"];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"cityID"] isEqual:@""]) {
        _where = 0;
        cityString = @"";
    }else{
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"cityID"] intValue] == 0) {
            _where = 0;
            cityString = @"";
        }else{
            _where = 1;
            cityString = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityString"];
        }
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
    gender = [NSNumber numberWithInt:_who];
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:ageString,@"age",purposeNumber,@"purpose",gender,@"gender",cityString,@"city", nil];
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
            NSNumber * purposeNumber = [NSNumber numberWithInt:_index];
            NSNumber * genderNumber = [NSNumber numberWithInt:_who];
            
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"maxAge"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"purposeNumber"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"genderNumber"];
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:maxAge] forKey:@"maxAge"];
            [[NSUserDefaults standardUserDefaults]setObject:purposeNumber forKey:@"purposeNumber"];
            [[NSUserDefaults standardUserDefaults]setObject:genderNumber forKey:@"genderNumber"];
            [[NSUserDefaults standardUserDefaults]synchronize];
           [self.navigationController popViewControllerAnimated:YES];
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
//    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
//    [bd removeFromSuperview];
//    bd=nil;
    
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
        return 3;
        
    }else if(section == 2){
        return 2;
    }else{
        return 2;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 1) {
        return 60;
    }
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
                cell.textLabel.text = [firstArray objectAtIndex:_index];
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(Screen_width - 25, 25, 10, 10);
                [cell.contentView addSubview:button];
                UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
                imageView.image = [UIImage imageNamed:@"矩形 13 拷贝 2@2x.png"];
                [button addSubview:imageView];
            }else{
                cell.textLabel.text = @"我想交新朋友";
            }
            
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"我要结婚";
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"我要约会";
        }
    }
    if (indexPath.section == 1) {
        // 重用机制，如果选中的行正好要重用
        if (_who == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"男女无所谓";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"和一位帅哥";
            
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"和一位美女";
        }
        
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 74, 34)];
            label1.text = @"显示18到";
            [cell.contentView addSubview:label1];
            
            maxAgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x + label1.frame.size.width, 5, 22,34)];
            maxAgeLabel.textColor = [UIColor redColor];
            maxAgeLabel.text = [NSString stringWithFormat:@"%d",maxAge];
            [cell.contentView addSubview:maxAgeLabel];
            
            UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(maxAgeLabel.frame.size.width + maxAgeLabel.frame.origin.x, 5, 100, 34 )];
            label2.text = @"的会员";
            [cell.contentView addSubview:label2];
            
        }
        if (indexPath.row == 1) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 60)];
            view.userInteractionEnabled = YES;
            [cell.contentView addSubview:view];
            // 滑动条 高是固定的，可以设置宽度。
            slider = [[UISlider alloc] initWithFrame:CGRectMake(15, 20, self.view.frame.size.width - 30, 20)];
            // 设置滑动条的最小值和最大值。
            slider.minimumValue = 0;
            slider.maximumValue = 90;
            // 设置滑块当前的值。
            NSLog(@"maxage = %d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"maxAge"] intValue]);
            NSLog(@"maxAge * 3 = %d",(maxAge - 18) * 3);
            slider.value = (maxAge - 18) * 3;
            NSLog(@"slider.value = %f",slider.value);
            // UISlider是继承与UIControl的，所以可以响应事件(值改变)
            [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
            slider.maximumTrackTintColor = color_alpha(192, 200, 207, 1);
            slider.minimumTrackTintColor = color_alpha(70, 152, 255, 1);
            [slider setThumbImage:[UIImage imageNamed:@"009"] forState:UIControlStateNormal];
            slider.tag = 100;
            [view addSubview:slider];
        }
    }
    if (indexPath.section == 3) {
        // 重用机制，如果选中的行正好要重用
        if (_where == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"附近会员";
//            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.frame = CGRectMake(Screen_width - 25, 25, 10, 10);
//            [cell.contentView addSubview:button];
//            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
//            imageView.image = [UIImage imageNamed:@"矩形 13 拷贝 2@2x.png"];
//            [button addSubview:imageView];
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"城市会员";
            if (![cityString isEqualToString:@""]) {
                cell.detailTextLabel.text = cityString;
            }
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
        NSLog(@"indexPath.row = %ld",(long)indexPath.row);
        _index = indexPath.row;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
    }
    if (indexPath.section == 0) {
        carType = 1;
    }
   
    if (indexPath.section == 1) {
        // 取消前一个选中的，就是单选啦
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_index inSection:0];
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndex];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
        
        // 选中操作
        UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSLog(@"组1 选中%@",cell.textLabel.text);
        // 保存选中的
        NSLog(@"indexPath.row = %ld",(long)indexPath.row);
        _who = indexPath.row;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    if (indexPath.section == 3) {
        // 取消前一个选中的，就是单选啦
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_index inSection:0];
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndex];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
        
        // 选中操作
        UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSLog(@"组1 选中%@",cell.textLabel.text);
        // 保存选中的
        NSLog(@"indexPath.row = %ld",(long)indexPath.row);
        _where = indexPath.row;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"cityID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        cityString = @"";
    }
    if (indexPath.section == 3 && indexPath.row == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"cityID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self getCityLists];
    }else{
        [_tableView reloadData];
    }
    
    
}
-(void)getCityLists
{
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSString * urlString = @"http://api.quxiangtou.com/v1/cities?udid=71B8DC2D-4244-4085-9C35-9A6692B50DDB";
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSDictionary * dic12 = [responseObject objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:dic12 forKey:@"city"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            BAddressPickerController *addressPickerController = [[BAddressPickerController alloc] initWithFrame:self.view.frame];
            addressPickerController.dataSource = self;
            addressPickerController.delegate = self;
            
            [self.navigationController pushViewController:addressPickerController animated:YES];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        }];
}
#pragma mark - BAddressController Delegate
- (NSArray*)arrayOfHotCitiesInAddressPicker:(BAddressPickerController *)addressPicker{
    return @[@"北京",@"上海",@"深圳",@"杭州",@"广州",@"武汉",@"天津",@"重庆",@"成都",@"苏州"];
}


- (void)addressPicker:(BAddressPickerController *)addressPicker didSelectedCity:(NSString *)city{
    NSLog(@"%@",city);
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"cityString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    cityString = city;
    [_tableView reloadData];
}

- (void)beginSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)endSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)valueChanged:(UISlider *)slider1
{
    
    maxAge = 18 + slider1.value / 3;
    NSLog(@"%d",maxAge);
    maxAgeLabel.text = [NSString stringWithFormat:@"%d",maxAge];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"maxAge"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:maxAge] forKey:@"maxAge"];
    [[NSUserDefaults standardUserDefaults]synchronize];
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
