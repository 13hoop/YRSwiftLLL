//
//  MyMailListViewController.m
//  quxiangtou
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "MyMailListViewController.h"
#import "BlackListDetailTableViewCell.h"
@interface MyMailListViewController ()<UITableViewDelegate,UITableViewDataSource,BlackListDetailDelegate>
{
    UITableView * blacktableView;
    NSArray * checkArray;
}
//@property (nonatomic,strong) NSMutableArray * array_01;

@end

@implementation MyMailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self address];
    checkArray = [[NSArray alloc]init];

    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"顶操04@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
    self.navigationItem.title = @"我的通讯录";
    self.view.backgroundColor = [UIColor whiteColor];
    blacktableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height - 64) style:UITableViewStylePlain];
    blacktableView.showsVerticalScrollIndicator = NO;
    blacktableView.showsHorizontalScrollIndicator = NO;
    blacktableView.delegate = self;
    blacktableView.dataSource = self;
    [self.view addSubview:blacktableView];
}
-(void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 添加黑名单
-(void)upBackList:(NSDictionary *)dic
{
    NSMutableArray * mutable = [[NSMutableArray alloc]initWithObjects:dic, nil];
    NSArray * user = [NSArray arrayWithArray:mutable];
    NSLog(@"需要添加到黑名单的用户  user = %@",user);
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
      
        NSString * urlStr = [NSString stringWithFormat:@"%@blacklist?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
        NSLog(@"添加黑名单 = %@",urlStr);
        NSURL * url = [NSURL URLWithString:urlStr];
        upBackListRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [upBackListRequest setRequestMethod:@"POST"];
        
        //1、header
        [upBackListRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //2、header
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        NSLog(@"添加黑名单 Authorization%@",Authorization);
        [upBackListRequest addRequestHeader:@"Authorization" value:Authorization];
        [upBackListRequest setDelegate:self];
        [upBackListRequest setPostBody:tempJsonData];
        upBackListRequest.tag = 100;
        [upBackListRequest startAsynchronous];

    }

}
#pragma mark - 更多图片响应请求的请求成功回调
//获取黑名单
- (void)requestFinished:(ASIHTTPRequest *)request {
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic4=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    int statusCode = [request responseStatusCode];
    //我的中心 获取图片列表 statusCode 204
    NSLog(@"我的黑名单 statusCode %d",statusCode);
    
    if (request.tag == 100) {
        if (statusCode == 201 ) {
            NSLog(@"添加黑名单 data %@",[dic4 objectForKey:@"data"]);
            [self CheckRequest];
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"已成功上传黑名单"
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
    if (request.tag == 101) {
        if (statusCode == 200) {
            NSLog(@"获取黑名单的状态 data %@",[dic4 objectForKey:@"data"]);
            checkArray = [dic4 objectForKey:@"data"];
            [blacktableView reloadData];
            
        }else if (statusCode == 400){
            
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

#pragma mark - 获取通讯录里联系人姓名和手机号
- (void)address
{
    dataSource = [[NSMutableArray alloc] init];
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    //判断是否在ios6.0版本以上
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0){
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        CFErrorRef* error=nil;
        addressBooks = ABAddressBookCreateWithOptions(NULL, error);
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        NSMutableDictionary *addressBook = [[NSMutableDictionary alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        }else {
            if ((__bridge id)abLastName != nil){
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        [addressBook setObject:nameString forKey:@"name"];
        //        addressBook.recordID = (int)ABRecordGetRecordID(person);
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                
                switch (j) {
                    case 0: {// Phone number
                        NSString * valueString = (__bridge NSString*)value;
                        valueString = [valueString stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        NSLog(@"valueString = %@",valueString);
                        [addressBook setObject:valueString forKey:@"mobile"];
                        break;
                    }
                        
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [dataSource addObject:addressBook];
        
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    if (dataSource.count == 0) {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"您的通讯录没有联系人!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];

    }else{
        [self CheckRequest];
    }
    
}
#pragma mark - 获取用户的状态
-(void)CheckRequest
{
    NSArray * user = [NSArray arrayWithObject:dataSource];

    NSLog(@"获取用户黑名单状态 user = %@",user);
    if ([NSJSONSerialization isValidJSONObject:[user firstObject]]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:[user firstObject] options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        
        NSString * urlStr = [NSString stringWithFormat:@"%@blacklist/check?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
        NSLog(@"获取用户黑名单状态 = %@",urlStr);
        NSURL * url = [NSURL URLWithString:urlStr];
        CheckListRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [CheckListRequest setRequestMethod:@"POST"];
        
        //1、header
        [CheckListRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //2、header
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        NSLog(@"获取用户黑名单状态 Authorization%@",Authorization);
        [CheckListRequest addRequestHeader:@"Authorization" value:Authorization];
        [CheckListRequest setDelegate:self];
        [CheckListRequest setPostBody:tempJsonData];
        CheckListRequest.tag = 101;
        [CheckListRequest startAsynchronous];
        
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return checkArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlackListDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"black"];
    if (cell == nil) {
        cell = [[BlackListDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"black"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary * model = [checkArray objectAtIndex:indexPath.row];
    if ([[model objectForKey:@"exist"] intValue] == 0) {
        cell.UpBlackListButton.hidden = NO;
        cell.NOClickButton.hidden = YES;
    }else{
        cell.UpBlackListButton.hidden = YES;
        cell.NOClickButton.hidden = NO;
    }
    cell.nameLabel.text = [model objectForKey:@"name"];
    cell.mobileLabel.text = [NSString stringWithFormat:@"手机号:%@",[model objectForKey:@"mobile"]];
    cell.nickNameLabel.text = [NSString stringWithFormat:@"昵称:%@",[model objectForKey:@"nickname"]];
    return cell;
}
-(void)didClickUpBlackListWithCell:(BlackListDetailTableViewCell *)cell
{
    NSIndexPath *indexPath = [blacktableView indexPathForCell:cell];
    
    if (indexPath != nil)
    {
        NSDictionary *fileInfo = [dataSource objectAtIndex:indexPath.row];
        NSLog(@"添加到黑名单的用户 fileInfo = %@ ",fileInfo);
        [self upBackList:fileInfo];
    }

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [dataSource removeAllObjects];
    [upBackListRequest setDelegate:nil];
    [CheckListRequest setDelegate:nil];
    [upBackListRequest cancel];
    [CheckListRequest cancel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
