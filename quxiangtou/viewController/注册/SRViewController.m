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

@interface SRViewController ()<setDe,setSex,setSexDe,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    sexViewController * svc;
    sexDViewController * svcd;
    DViewController * dv;
    UIImagePickerController * addPickerImage;
    UIImageView * touxiang;
    NSURLConnection * conn;
    NSMutableData * postData;
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
@property (nonatomic,strong) NSString * genderString;
@property (nonatomic,strong) NSString * sexual_orientationString;
@property (nonatomic,strong) NSString * purposeString;
@property (nonatomic,strong) NSNumber * genderNumber;
@property (nonatomic,strong) NSNumber * sexual_orientationNumber;
@property (nonatomic,strong) NSNumber * purposeNumber;



@end

@implementation SRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _array = @[@"性别",@"性取向",@"交友目的"];
//     _array1 = @[@"男",@"女"];
//    _array2 = @[@"男",@"女",@"无所谓"];
//    _array3 = @[@"交朋友",@"约会"];
    _genderString = @"男";
    _sexual_orientationString = @"我爱异性";
    _purposeString = @"交新朋友";

    [self createNav];
    [self createUI];

}
-(void)createNav
{
    UIView * navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64)];
    navigationView.userInteractionEnabled = YES;
    navigationView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    [self.view addSubview:navigationView];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 30, 50, 25);
    backButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [backButton setTitleColor:[UIColor colorWithRed:47.0/255.0 green:120.0/255.0 blue:200.0/255.0 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
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
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto)];
//    [touxiang addGestureRecognizer:tap];
    
    self.view.backgroundColor = color(239, 239, 244);
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,touxiang.frame.origin.y+touxiang.frame.size.height, Screen_width, 280) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =  color(239, 239, 244);
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(_tableView.separatorInset.top, 0, _tableView.separatorInset.bottom, 0);
    }

    [self.view addSubview:_tableView];

    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, _tableView.frame.origin.y+_tableView.frame.size.height, Screen_width - 20, 40);
    button.backgroundColor = color_alpha(87.0, 169.0, 255.0, 1);
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20.0];
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)addPhoto
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选取",@"拍照",nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }else{
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选取",nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}
//点击选择视图的方法..
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    addPickerImage=[[UIImagePickerController alloc]init];
    addPickerImage.delegate=self;
    //addPickerImage.allowsEditing=YES;
   // addPickerImage.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    touxiang.image=image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self upImage:image];
//    [self performSelector:@selector(upImage:) withObject:nil afterDelay:2];
}
//上传头像的请求..
-(void)upImage:(UIImage *)headImage{
    NSString *url = [NSString stringWithFormat:@"%@images?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
    NSLog(@"url=%@",url);
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *realPath = [documentPath stringByAppendingPathComponent:@"headImage.png"];
    NSData *imgData = UIImagePNGRepresentation(headImage);
    //分界线标示符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:10.0f];
    //分界线 --AaB03x
    NSString *MPboundary = [[NSString alloc] initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary = [[NSString alloc] initWithFormat:@"%@--",MPboundary];
    //可变数组..
    NSMutableString *body = [[NSMutableString alloc]init];
    [body appendFormat:@"%@\r\n",MPboundary];
    [body appendFormat:@"Content-Disposition: form-data; name=\"mainimg\"; filename=\"%@\"\r\n",realPath];
    [body appendFormat:@"Content-Type: image/pjpeg\r\n\r\n"];
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //创建可变的二进制数据..
    NSMutableData *myRequestData=[NSMutableData data];
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:imgData];
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *content=[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    [request setValue:content forHTTPHeaderField:@"Content-Disposition"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"]];
    NSLog(@"session_id = %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"]);
    [request addValue:Authorization forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:myRequestData];
    [request setHTTPMethod:@"POST"];
    //网络连接
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
    //加载框
    MBProgressHUD *bd=[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:bd];
    bd.tag=123456;
    bd.dimBackground=YES;
    bd.detailsLabelText=@"正在加载,请稍后";
    [bd show:YES];

    
    
    
//    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:@"avatar",@"type", nil];
//    NSMutableData * imageData = UIImagePNGRepresentation(headImage);
//    if ([NSJSONSerialization isValidJSONObject:user]) {
//        NSError * error;
//        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
//        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
//        NSString * urlStr = [NSString stringWithFormat:@"%@images?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
//        NSLog(@"======= url = %@",urlStr);
//        NSURL * url = [NSURL URLWithString:urlStr];
//        UpPhotoRequest = [[ASIFormDataRequest alloc]initWithURL:url];
//        [UpPhotoRequest setRequestMethod:@"POST"];
//        [UpPhotoRequest setDelegate:self];
//        UpPhotoRequest.tag = 101;
//        [UpPhotoRequest addRequestHeader:@"Content-Type" value:@"application/json"];
//        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"]];
//        NSLog(@"session_id = %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"]);
//        [UpPhotoRequest addRequestHeader:@"Authorization" value:Authorization];
////        NSString * photoName = [NSString stringWithFormat:@"attachment; filename=\"%@\"/",touxiang.image];
////        NSLog(@"touxiang.image = %@",touxiang.image);
////        NSLog(@"photoname %@",photoName);
//        [UpPhotoRequest addRequestHeader:@"Content-Disposition" value:@"头像.png"];
//        [UpPhotoRequest setPostBody:tempJsonData];
//        [UpPhotoRequest setPostBody:imageData];
//        [UpPhotoRequest startAsynchronous];
//    }
//    
//    
//    //加载框
//    MBProgressHUD *bd=[[MBProgressHUD alloc]initWithView:self.view];
//    [self.view addSubview:bd];
//    bd.tag=123456;
//    bd.dimBackground=YES;
//    bd.detailsLabelText=@"正在加载,请稍候";
//    [bd show:YES];
}
-(void)backClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)registerClick:(UIButton *)button
{

    _genderNumber = [BasicInformation getNumberGender:_genderString];
    
    _sexual_orientationNumber = [BasicInformation getNumberSexual_orientation:_sexual_orientationString];
   _purposeNumber = [BasicInformation getNumberPurpose:_purposeString];
    NSLog(@"注册第二页 _genderNumber%@  _genderString = %@",_genderNumber,_genderString );
    NSLog(@"注册第二页 _sexual_orientationNumber%@  _sexual_orientationString = %@",_sexual_orientationNumber,_sexual_orientationString);
    NSLog(@"注册第二页 _purposeNumber%@  _purposeString = %@",_purposeNumber,_purposeString);
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:_nickField.text,@"nickname",_genderNumber,@"gender",_sexual_orientationNumber,@"sexual_orientation",_purposeNumber,@"purpose", nil];
    NSLog(@"注册第二页 NSDictionary user数据 %@",user);
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString * urlStr = [NSString stringWithFormat:@"%@users/update?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
        NSLog(@"注册第二页 url = %@",urlStr);
        NSURL * url = [NSURL URLWithString:urlStr];
        messageRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [messageRequest setRequestMethod:@"POST"];
        [messageRequest setDelegate:self];
        messageRequest.tag = 100;
        [messageRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"]];
        [messageRequest addRequestHeader:@"Authorization" value:Authorization];
        [messageRequest setPostBody:tempJsonData];
        [messageRequest startAsynchronous];
    }

   
    //加载框
    MBProgressHUD *bd=[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:bd];
    bd.tag=123456;
    bd.dimBackground=YES;
    bd.detailsLabelText=@"正在加载,请稍候";
    [bd show:YES];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [postData appendData:data];
}
//网络请求收到响应的时候..
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    postData=[NSMutableData data];
}
//`syscheck` int(1) NOT NULL COMMENT '0为审核中，1为通过审核',
//网络请求完成的时候
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //取消网络请求
    [conn cancel];
    //去掉加载框
    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
    [bd removeFromSuperview];
    bd=nil;
    
    NSString *responseString=[[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:[responseString JSONValue]];
    //如果返回值是错误的话
    NSLog(@"dic=%@",dic);
    if([dic valueForKey:@"error"]){
        MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"图片上传成功";
        HUD.detailsLabelText =[dic valueForKey:@"error"];
        HUD.mode = MBProgressHUDModeText;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2.0);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
    }else{
        MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"图片上传失败";
        HUD.detailsLabelText =[dic valueForKey:@"error"];
        HUD.mode = MBProgressHUDModeText;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2.0);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //取消网络请求
    [conn cancel];
    //去掉加载框
    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
    [bd removeFromSuperview];
    bd=nil;
    
    //提示警告框失败...
    MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"抱歉";
    HUD.detailsLabelText = @"请检查网络连接";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.0);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    //移除加载框
    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
    [bd removeFromSuperview];
    bd=nil;
    if (request.tag == 100) {
        //解析接收回来的数据
        int statusCode = [request responseStatusCode];
       // NSLog(@"注册第二页 请求成功 返回数据 %@",[request responseData]);
        NSLog(@"注册第二页  请求成功 statusCode %d",statusCode);
        if (statusCode == 204) {
            //CE7A1A9E-D269-B243-AE28-8629650F48C7  session_id
            /*
            [[NSUserDefaults standardUserDefaults]setObject:_nickField.text forKey:@"nickname"];
            [[NSUserDefaults standardUserDefaults]setObject:_genderNumber forKey:@"gender"];
            [[NSUserDefaults standardUserDefaults]setObject:_sexual_orientationNumber forKey:@"sexual_orientation"];
            [[NSUserDefaults standardUserDefaults]setObject:_purposeNumber forKey:@"purpose"];
             */
            LoginModel * mod = [XMShareView sharedInstance].loginModel;
            mod.nickname = _nickField.text;
            mod.gender = _genderNumber;
            mod.sexual_orientation = _sexual_orientationNumber;
            mod.purpose = _purposeNumber;
            mod.mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"];
            [[LIUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
            [LIUserDefaults userDefaultObject:[mod dictionaryFromModelData] key:@"user"];
            
            NSLog(@"注册第二页 系统单例 user %@",mod);
            NSLog(@"注册第二页 系统单例 user %@",mod.mobile);
            NSLog(@"注册第二页 系统单例 user %@",mod.gender);
            NSLog(@"注册第二页 系统单例 user mod.sexual_orientation%@",mod.sexual_orientation);
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
            //提示警告框失败...
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"抱歉";
            //HUD.detailsLabelText =[dic valueForKey:@"return_content"];
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
        }
    }
    
/*
    if (request.tag == 101) {
        //解析接收回来的数据
        NSString *responseString=[request responseString];
        NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
        //{"data":"F5505E7C-EA53-56A1-EFE0-CBC0D568BA13"}
        NSLog(@"SRViewController responseString %@",[request responseString]);
        //解析接收回来的数据
        int statusCode = [request responseStatusCode];
        NSLog(@"SRViewController requestFinished statusCode %d",statusCode);
        if (statusCode == 204) {
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"头像上传成功";
            //HUD.detailsLabelText =[dic valueForKey:@"return_content"];
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1.0);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
            
//            TRViewController * trv = [[TRViewController alloc]init];
//            [self presentViewController:trv animated:YES completion:nil];
            
        }else{
            //提示警告框失败...
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"抱歉";
            //HUD.detailsLabelText =[dic valueForKey:@"return_content"];
            HUD.mode = MBProgressHUDModeText;
            HUD.detailsLabelText = [dic objectForKey:@"error"];
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
        }
    }
*/
        
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"注册第二页 请求失败 responseString %@",[request responseString]);

    int statusCode = [request responseStatusCode];
    NSLog(@"注册第二页 请求失败 statusCode %d",statusCode);
    //去掉加载框
    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
    [bd removeFromSuperview];
    bd=nil;
    
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
        NSArray * array = @[@"",@"     4-30个字符，支持中英文，数字"];
        return [array objectAtIndex:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        if (section == 0) {
            return 0;
        }else{
            return 20.0;
        }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
    if (indexPath.section == 0&&indexPath.row == 0) {
        _nickField = [[UITextField alloc]initWithFrame:CGRectMake(20, 4, Screen_width - 50 , 36)];
        _nickField.backgroundColor = [UIColor whiteColor];
        _nickField.placeholder = @"请输入您的昵称";
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
            svc = [[sexViewController alloc]init];
            svc.delegate = self;
            [self presentViewController:svc animated:YES completion:nil];
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
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_nickField resignFirstResponder];
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
