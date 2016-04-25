//
//  SRViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/7/24.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "SRViewController.h"
#import "TRViewController.h"
#import "sexDViewController.h"
#import "sexViewController.h"
#import "DViewController.h"
#import "LoginModel.h"


@interface SRViewController ()<setDe,setSex,setSexDe,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    sexViewController * svc;
    sexDViewController * svcd;
    DViewController * dv;
    UIImagePickerController * addPickerImage;
    UIImageView * touxiang;
    NSURLConnection * conn;
    NSMutableData * postData;
    UIImage *originImage;
    int number;
}
@property (nonatomic,strong) UITextField * nickField;
@property (nonatomic,strong) UILabel * sexLabel;
@property (nonatomic,strong) UILabel * sexDirectoryLabel;
@property (nonatomic,strong) UILabel * destionLabel;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * array;
@property (nonatomic,strong) NSArray * array1;
@property (nonatomic,strong) NSArray * array2;
@property (nonatomic,strong) NSArray * array3;
@property (nonatomic,strong) NSString * nickName;
@property (nonatomic,strong) NSString * genderString;
@property (nonatomic,strong) NSString * sexual_orientationString;
@property (nonatomic,strong) NSString * purposeString;
@property (nonatomic,strong) NSNumber * genderNumber;
@property (nonatomic,strong) NSNumber * sexual_orientationNumber;
@property (nonatomic,strong) NSNumber * purposeNumber;

//@property (nonatomic, strong) MCPhotographyHelper *photographyHelper;


@end

@implementation SRViewController

- (void)viewDidLoad {
    //http://img.quxiangtou.com/thumb/q/84/f7/84f7895881c8d6a7ba0bdf471ee0a365.png
    [super viewDidLoad];
    number = 0;
    _array = @[@"性别",@"性取向",@"交友目的"];
    _genderString = @"男";
    _sexual_orientationString = @"我爱异性";
    _purposeString = @"我想交新朋友";
    _nickName = @"请输入您的昵称";
    
    [self createNav];
    [self createUI];
    
}
-(void)createNav
{
    UIView * navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64)];
    navigationView.userInteractionEnabled = YES;
    navigationView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    [self.view addSubview:navigationView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width / 2 -60, 30, 120, 30)];
    titleLabel.text = @"完善个人资料";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navigationView addSubview:titleLabel];
    
}
-(void)createUI
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, Screen_width, 40)];
    label.text = @"设置头像和昵称方便朋友认出你";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    touxiang = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width/2 - 40, label.frame.size.height + label.frame.origin.y + 10, 80, 80)];
    touxiang.layer.cornerRadius = 40;
    touxiang.layer.masksToBounds = YES;
    touxiang.backgroundColor = [UIColor redColor];
    touxiang.image = [UIImage imageNamed:@"组 2@2x"];
    touxiang.userInteractionEnabled = YES;
    [self.view addSubview:touxiang];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto)];
    [touxiang addGestureRecognizer:tap];
    
    self.view.backgroundColor = color(239, 239, 244);
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, _tableView.frame.origin.y+_tableView.frame.size.height, Screen_width - 20, 40);
    button.backgroundColor = color_alpha(87.0, 169.0, 255.0, 1);
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20.0];
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,touxiang.frame.origin.y+touxiang.frame.size.height, Screen_width, 320) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =  color(239, 239, 244);
    //_tableView.showsVerticalScrollIndicator = YES;
    _tableView.scrollEnabled = YES;
    _tableView.tableFooterView = button;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(_tableView.separatorInset.top, 0, _tableView.separatorInset.bottom, 0);
    }
    
    [self.view addSubview:_tableView];
    
    
}
-(void)addPhoto
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选取",@"拍照",nil];
        [sheet showInView:self.view];
    }else{
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选取",nil];
        [sheet showInView:self.view];
    }
}
//点击选择视图的方法..
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    addPickerImage=[[UIImagePickerController alloc]init];
    addPickerImage.delegate=self;
    addPickerImage.allowsEditing=YES;
    addPickerImage.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        switch (buttonIndex) {
            case 0:{
                addPickerImage.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:addPickerImage animated:YES completion:nil];
                break;
            }
            case 1:{
                addPickerImage.sourceType=UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:addPickerImage animated:YES completion:nil];
                break;
            }
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0:{
                addPickerImage.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:addPickerImage animated:YES completion:nil];
                break;
            }
            default:
                break;
        }
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    originImage=(UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    //设置图像的方向，UIImage 有个只读属性imageOrientation
    originImage=[self image:originImage rotation:originImage.imageOrientation];
    originImage=[self imageWithImageSimple:originImage scaledToSize:CGSizeMake(self.view.frame.size.width,(self.view.frame.size.width*originImage.size.height)/originImage.size.width)];
    [self upImage:originImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    switch (orientation) {
            //逆时针旋转90度
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            break;
            //顺时针旋转90度
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            break;
            //旋转180度
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

//简化UIImageSize尺寸
-(UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(void)upImage:(UIImage *)headImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *string = [NSString stringWithFormat:@"%@images?udid=%@&type=avatar",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid"]];
        NSLog(@"string = %@",string);
        
        //网络连接
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData * imgData = UIImageJPEGRepresentation(headImage, 1.0);
            //            //分界线标示符
            //            NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:string]
                                                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                    timeoutInterval:10.0f];
            //header 1
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            //header 2
            NSString * Disposition = [NSString stringWithFormat:@"attachment; filename=\"%@\"/",@"headImage.png"];
            [request setValue:Disposition forHTTPHeaderField:@"Content-Disposition"];
            
            //header 3
            NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
            [request setValue:Authorization forHTTPHeaderField:@"Authorization"];
            
            //创建可变的二进制数据..
            NSMutableData *myRequestData=[NSMutableData data];
            [myRequestData appendData:imgData];
            [request setHTTPBody:myRequestData];
            [request setHTTPMethod:@"POST"];
            
            conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
        });
    });
    //加载框
//    MBProgressHUD *bd=[[MBProgressHUD alloc]initWithView:self.view];
//    [self.view addSubview:bd];
//    bd.tag=123456;
//    bd.dimBackground=YES;
//    bd.detailsLabelText=@"正在上传头像,请稍候";
//    [bd show:YES];
    
}
//接收二进制数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [postData appendData:data];
}
//网络请求收到响应的时候..
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    postData=[NSMutableData data];
}
//网络请求完成的时候
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //取消网络请求
    [conn cancel];
//    //去掉加载框
//    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
//    [bd removeFromSuperview];
//    bd=nil;
    
    NSString *responseString=[[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:[responseString JSONValue]];
    NSLog(@"上传头像  dic = %@",dic);
    if([[dic valueForKey:@"errors"] isNotEmpty]){
        
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                         message:[[dic valueForKey:@"errors"] valueForKey:@"code"]
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        alert.tag=1001;
        [alert show];
        
    }else{
        
        [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"] objectForKey:@"url"] forKey:@"touxiangurl"];
        [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"] objectForKey:@"md5"] forKey:@"touxiangMD5"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateAvatar" object:dic];
        
        MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"提示";
        HUD.detailsLabelText = @"上传头像成功";
        HUD.mode = MBProgressHUDModeText;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1.0);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
        touxiang.image=originImage;
    }
}

//-(void)backClick:(UIButton *)button
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
-(void)registerClick:(UIButton *)button
{
    
    if([_nickField.text isEqualToString:@"请输入您的昵称"] || [_nickField.text isEqualToString:@""] )
    {
        MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"温馨提示";
        HUD.detailsLabelText =@"请输入您的昵称!";
        HUD.mode = MBProgressHUDModeText;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1.0);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
        
    }else{
        _genderNumber = [BasicInformation getNumberGender:_genderString];
        
        _sexual_orientationNumber = [BasicInformation getNumberSexual_orientation:_sexual_orientationString];
        _purposeNumber = [BasicInformation getNumberPurpose:_purposeString];
        NSDictionary * user = nil;
        user = [[NSDictionary alloc]initWithObjectsAndKeys:_nickField.text,@"nickname",_genderNumber,@"gender",_sexual_orientationNumber,@"sexual_orientation",_purposeNumber,@"purpose", nil];
        NSLog(@"注册第二页 请求的JSON 数据 %@",user);
        if ([NSJSONSerialization isValidJSONObject:user]) {
            NSError * error;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
            NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
            NSString * urlStr = [NSString stringWithFormat:@"%@users/update?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid"]];
            NSLog(@"注册第二页 url = %@",urlStr);
            NSURL * url = [NSURL URLWithString:urlStr];
            messageRequest = [[ASIFormDataRequest alloc]initWithURL:url];
            [messageRequest setRequestMethod:@"POST"];
            [messageRequest setDelegate:self];
            messageRequest.tag = 100;
            [messageRequest addRequestHeader:@"Content-Type" value:@"application/json"];
            NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
            [messageRequest addRequestHeader:@"Authorization" value:Authorization];
            [messageRequest setPostBody:tempJsonData];
            [messageRequest startAsynchronous];
        }
    }
    
    
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSLog(@"注册第二页 更新用户信息 dic %@=====",dic);
    //移除加载框
//    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
//    [bd removeFromSuperview];
//    bd=nil;
    //更新用户信息
    if (request.tag == 100) {
        
        //解析接收回来的数据
        int statusCode = [request responseStatusCode];
        NSLog(@"注册第二页  请求成功 statusCode %d",statusCode);
        if (statusCode == 201) {
            ACommenData *data=[ACommenData sharedInstance];
            data.logDic=[dic valueForKey:@"data"]; //将登陆返回的数据存到一个字典对象里面...
            
            [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"] objectForKey:@"auth_token"] forKey:@"auth_token"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"完善信息成功";
            //HUD.detailsLabelText =[dic valueForKey:@"return_content"];
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1.0);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
            
            TRViewController * trv = [[TRViewController alloc]init];
            [self presentViewController:trv animated:YES completion:nil];
            
        }else{
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:[[dic objectForKey:@"errors"] objectForKey:@"code"]
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];        }
    }
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"注册第二页 请求失败 responseString %@",[request responseString]);
    
    int statusCode = [request responseStatusCode];
    NSLog(@"注册第二页 请求失败 statusCode %d",statusCode);
    
    //去掉加载框
//    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
//    [bd removeFromSuperview];
//    bd=nil;
    
    //提示警告框失败...
    MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"请检查网络连接";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2.0);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray * array = @[@"",@"     2~10个字符，支持中英文，数字，禁止使用色情/政治等敏感词汇"];
    return [array objectAtIndex:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        return 30.0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
    if (indexPath.section == 0&&indexPath.row == 0) {
        _nickField = [[UITextField alloc]initWithFrame:CGRectMake(20, 4, Screen_width - 50 , 36)];
        _nickField.backgroundColor = [UIColor whiteColor];
        if ([_nickName isEqualToString:@"请输入您的昵称"]) {
            _nickField.textColor = [UIColor grayColor];
            
        }else{
            _nickField.textColor = [UIColor blackColor];
            
        }
        _nickField.text = _nickName;
        _nickField.delegate = self;
        [cell.contentView addSubview:_nickField];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            
            cell.textLabel.text=@"性别";
            cell.textLabel.textColor=[UIColor grayColor];
            cell.textLabel.font=[UIFont systemFontOfSize:17];
            cell.detailTextLabel.text=_genderString;
            cell.detailTextLabel.textColor=[UIColor grayColor];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:17];
            
        }else if (indexPath.row == 1){
            cell.textLabel.text=@"性取向";
            cell.textLabel.textColor=[UIColor grayColor];
            cell.textLabel.font=[UIFont systemFontOfSize:17];
            cell.detailTextLabel.text=_sexual_orientationString;
            cell.detailTextLabel.textColor=[UIColor grayColor];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:17];
            
        }else{
            cell.textLabel.text=@"目的";
            cell.textLabel.textColor=[UIColor grayColor];
            cell.textLabel.font=[UIFont systemFontOfSize:17];
            cell.detailTextLabel.text=_purposeString;
            cell.detailTextLabel.textColor=[UIColor grayColor];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:17];
            
        }
        
    }
    return cell;
    
}
-(void)setSexString:(NSString *)sex{
    number = number + 1;
    _genderString = sex;
    [_tableView reloadData];
}
-(void)setSexDeString:(NSString *)sex
{
    _sexual_orientationString = sex;
    [_tableView reloadData];
    
}
-(void)setDeString:(NSString *)sex{
    _purposeString = sex;
    [_tableView reloadData];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (number == 1) {
                
            }else{
                UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"性别一经设定，不可更改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                al.tag = 100;
                [al show];
                
            }
            
        }else if (indexPath.row == 1){
            svcd = [[sexDViewController alloc]init];
            svcd.delegate = self;
            [self presentViewController:svcd animated:YES completion:nil];
        }else{
            dv = [[DViewController alloc]init];
            dv.delegate = self;
            [self presentViewController:dv animated:YES completion:nil];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_nickField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_nickField resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _nickField.text = @"";
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==_nickField)
    {
        BOOL result = [self VerificationNickName:_nickField.text];
        if (result) {
            
        }else{
            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"2~10个字符，支持中英文，数字，禁止使用色情/政治等敏感词汇" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            av.tag = 56;
            [av show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 56) {
        _nickField.text = @"";
    }
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            svc = [[sexViewController alloc]init];
            svc.delegate = self;
            [self presentViewController:svc animated:YES completion:nil];
        }
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _nickName = _nickField.text;
    [messageRequest setDelegate:nil];
    [UpPhotoRequest setDelegate:nil];
    [messageRequest cancel];
    [UpPhotoRequest cancel];
}
-(BOOL)VerificationNickName:(NSString *)nickname
{
    //[\u4e00-\u9fa5a-zA-Z0-9_]{2,10}
    BOOL result = false;
    if ([nickname length] >= 2){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"[\u4e00-\u9fa5a-zA-Z0-9_]{2,10}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:nickname];
    }
    return result;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
