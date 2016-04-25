//
//  TRViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/11.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "TRViewController.h"
#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Model.h"

@interface TRViewController ()<UITextFieldDelegate,UIAlertViewDelegate,ASIHTTPRequestDelegate>
{
    UIButton * newButton;
    int time;
    NSTimer * timer;
    UIButton * agreeImage;
    ASIFormDataRequest * upBackListRequest;
    NSMutableArray *dataSource;
}
@property (nonatomic,strong) UILabel * phoneLabel;
@property (nonatomic,strong) UITextField * yanzmField;
@end

@implementation TRViewController

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
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 30, 50, 25);
    backButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [backButton setTitleColor:color_alpha(47.0, 120.0, 200.0, 1) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width / 2 -40, 30, 80, 30)];
    titleLabel.text = @"通讯录";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navigationView addSubview:titleLabel];
    
}
-(void)createUI
{
    agreeImage = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeImage.frame = CGRectMake(10, 100, 15, 15);
    [agreeImage setImage:[UIImage imageNamed:@"选择框@2x.png"] forState:UIControlStateNormal];
    [agreeImage addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeImage];
    
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(agreeImage.frame.size.width + agreeImage.frame.origin.x + 5, agreeImage.frame.origin.y , Screen_width - (agreeImage.frame.size.width + agreeImage.frame.origin.x + 5) - 5, agreeImage.frame.size.height)];
    [label4 setText:@"通过通讯录阻止您的朋友找到你，保护隐私"];
    [label4 setTextColor:[UIColor grayColor]];
    [label4 setTextAlignment:NSTextAlignmentLeft];
    label4.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label4];
    
    UIButton * tiaoguo = [UIButton buttonWithType:UIButtonTypeCustom];
    tiaoguo.frame = CGRectMake(10, agreeImage.frame.size.height + agreeImage.frame.origin.y + 20, Screen_width - 20, 40);
    [tiaoguo setTitle:@"跳过" forState:UIControlStateNormal];
    [tiaoguo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tiaoguo.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:169.0/255.0 blue:255.0/255.0 alpha:1];
    [tiaoguo addTarget:self action:@selector(tiaoguo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tiaoguo];
}

-(void)backClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)tiaoguo:(UIButton *)button
{
    [SharedAppDelegate showRootViewController];
}
#pragma mark - 获取验证码    tag = 101    验证码登录     tag = 100
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    //移除加载框
//    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
//    [bd removeFromSuperview];
//    bd=nil;
    if (request.tag == 102) {
        int statusCode = [request responseStatusCode];
        NSLog(@"注册上传黑名单 requestFinished statusCode %d",statusCode);
        NSString *responseString=[request responseString];
        NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
        NSLog(@"注册上传黑名单 data = %@",dic);
        if (statusCode == 201) {
            //提示警告框失败...
            [SharedAppDelegate showRootViewController];
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"已将通讯录加入到黑名单中,如想让某人看你，可以到黑名单中将其移除!"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
            agreeImage.enabled = NO;
            
        }else if (statusCode == 400){
            //提示警告框失败...
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:[[dic objectForKey:@"errors"] objectForKey:@"code"]
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
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
//    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
//    [bd removeFromSuperview];
//    bd=nil;
    int statusCode = [request responseStatusCode];
    NSLog(@"注册获取验证码的状态码 requestFailed statusCode %d",statusCode);
    
    //提示警告框失败...
    MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = [request responseString];
    HUD.detailsLabelText = [dic objectForKey:@"error"];
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
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_yanzmField resignFirstResponder];
    [timer invalidate];
    [yzmRequest setDelegate:nil];
    [verityPhoneRequest setDelegate:nil];
    [upBackListRequest setDelegate:nil];
    [yzmRequest cancel];
    [verityPhoneRequest cancel];
    [upBackListRequest cancel];
}

-(void)agreeClick:(UIButton *)btn
{
    NSLog(@"btn = %d",btn.selected);
    btn.selected = !btn.selected;
    if (!btn.selected) {
        [btn setImage:[UIImage imageNamed:@"选择框@2x.png"] forState:UIControlStateNormal];
        
        
    }else{
        [btn setImage:[UIImage imageNamed:@"选中@2x.png"] forState:UIControlStateNormal];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]) {
            [self address];
        }else{
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"请先注册,再上传通讯录信息!"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
        }
        
    }
    
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
#pragma mark - 上传黑名单
-(void)CheckRequest
{
    NSArray * user = [NSArray arrayWithObject:dataSource];
    
    NSLog(@"获取用户黑名单状态 user = %@",user);
    if ([NSJSONSerialization isValidJSONObject:[user firstObject]]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:[user firstObject] options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        
        NSString * urlStr = [NSString stringWithFormat:@"%@blacklist?udid=%@",URL_HOST,[[DeviceInfomationShare share] UUID]];
        NSLog(@"注册将用户添加到黑名单 = %@",urlStr);
        NSURL * url = [NSURL URLWithString:urlStr];
        upBackListRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [upBackListRequest setRequestMethod:@"POST"];
        
        //1、header
        [upBackListRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //2、header
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        NSLog(@"注册将用户添加到黑名单 Authorization%@",Authorization);
        [upBackListRequest addRequestHeader:@"Authorization" value:Authorization];
        [upBackListRequest setDelegate:self];
        [upBackListRequest setPostBody:tempJsonData];
        upBackListRequest.tag = 102;
        [upBackListRequest startAsynchronous];
        
    }
    
}
@end
