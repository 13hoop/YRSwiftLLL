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
#import "LoginModel.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "PhotoAlbumViewController.h"
#import "MyCenterTableViewCell.h"
#import "badgeTableViewCell.h"
#import "messageOfMeTableViewCell.h"

#import "CDUserFactory.h"
#import "LCEChatRoomVC.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView * listTable;
    NSMutableDictionary * dic;
    NSString * nickName;
    int number;
    UILabel * addressLabel;
    UILabel * purposeLabel;
    UILabel * nickNameLabel;
    NSMutableArray * imageArray;
    NSMutableArray * imageArr;
    NSMutableArray * visitUserArray;
    
    NSMutableDictionary * userDic;
    NSString * actionString;
    
    NSTimer * timer;
    NSTimer * timer1;
    
    UIScrollView * _scrollView;
    
    int page;
    BOOL isRefresh;

    UIView * nickView;
    NSArray * basicArray;
    NSArray * PrivacyArray;
    //保存每组的展开还是关闭的状态
    NSMutableArray * statusArray;
    
    UIButton * footButton;
    UIButton * fingerButton;
    UIButton * addFavoriteButton;

}
@end

@implementation ViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        visitUserArray = [[NSMutableArray alloc]init];
        userDic = [[NSMutableDictionary alloc]init];
        _xiehouArray = [[NSMutableArray alloc]init];
        imageArray = [[NSMutableArray alloc]init];
        ACommenData *data=[ACommenData sharedInstance];
        [[CDChatManager manager] openWithClientId:[data.logDic objectForKey:@"uuid"] ClientDic:(NSDictionary *)data.logDic callback: ^(BOOL succeeded, NSError *error) {
            if (error) {
                DLog(@"%@", error);
            }
            else {
                NSString * a = [AVIMClient defaultClient].clientId;
                NSLog(@"聊天登录成功");
            }
        }];
        
     NSLog(@"聊天登录成功 = %@",[AVIMClient defaultClient].clientId);
        

        [self UploadData];
        timer = [NSTimer scheduledTimerWithTimeInterval:60 * 10 target:self selector:@selector(UploadData) userInfo:nil repeats:YES];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    statusArray = [[NSMutableArray alloc]init];
    [statusArray addObject:@"YES"];
    [statusArray addObject:@"NO"];
    basicArray = @[@"位置",@"徽章",@"关于我",@"恋爱状态",@"性取向",@"外貌",@"居住情况",@"收入",@"健康",@"喝酒情况",@"运动",@"性能力",@"性格"];
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setImage:[[UIImage imageNamed:@"顶操01@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 50, 39);
    [backButton addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,btn_right, nil];

    self.navigationItem.title = @"首页";
    isRefresh = YES;
    page = 0;
    number = 0;
    actionString = @"0";
    [self xiuhouRequest];
    
    timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(xiuhouRequest) userInfo:nil repeats:YES];
    self.view.backgroundColor = [UIColor whiteColor];

}

-(void)createScrollImageView
{
    // 先移除，后添加
    [[_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //创建scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_width)];
    _scrollView.backgroundColor = [UIColor blackColor];
    for(UIView *view in [_scrollView subviews])
    {
        [view removeFromSuperview];
    }
    if (imageArray.count == 0) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_width)];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"加载失败图片@3x" ofType:@"png"];
        NSData *image = [NSData dataWithContentsOfFile:filePath];
        imageView.image = [UIImage imageWithData:image];
        imageView.tag = 0;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(largeImage:)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
    }else{
        for (int i = 0; i < imageArray.count;i++) {
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*Screen_width, 0, Screen_width, Screen_width)];
            imageView.userInteractionEnabled = YES;
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"加载失败图片@3x" ofType:@"png"];
            NSData *image = [NSData dataWithContentsOfFile:filePath];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]
                                           ] placeholderImage:[UIImage imageWithData:image]];
            imageView.tag = i;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(largeImage:)];
            [imageView addGestureRecognizer:tap];
            [_scrollView addSubview:imageView];
        }
    }
    
    _scrollView.contentSize = CGSizeMake(imageArray.count*Screen_width, Screen_width);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = YES;
    _scrollView.delegate = self;
    
    listTable=[[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,Screen_height-65) style:UITableViewStyleGrouped];
    listTable.delegate=self;
    listTable.tableHeaderView = _scrollView;
    listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    listTable.showsHorizontalScrollIndicator = NO;
    listTable.showsVerticalScrollIndicator = NO;
    listTable.dataSource=self;
    [self.view addSubview:listTable];
    
    UIImageView * cameraButton = [[UIImageView alloc]initWithFrame:CGRectMake(10, _scrollView.frame.origin.y + _scrollView.frame.size.height - 105 + 64, 36.5, 25)];
    cameraButton.userInteractionEnabled = YES;
    cameraButton.image = [UIImage imageNamed:@"相机 00@2x.png"];
    [listTable addSubview:cameraButton];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoAlbum)];
    [cameraButton addGestureRecognizer:tap];
    
    fingerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fingerButton.frame = CGRectMake(Screen_width / 2 - 70, _scrollView.frame.size.height - 70 , 60, 60);
    [fingerButton setImage:[[UIImage imageNamed:@"未操作喜欢@2x.png"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [fingerButton setImage:[[UIImage imageNamed:@"已操作喜欢@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    [fingerButton setImage:[[UIImage imageNamed:@"已操作喜欢@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [fingerButton addTarget:self action:@selector(fingerClick) forControlEvents:UIControlEventTouchUpInside];
    [listTable addSubview:fingerButton];
    
    footButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footButton.frame = CGRectMake(Screen_width / 2 + 10,_scrollView.frame.size.height - 70 , 60, 60);
    [footButton setImage:[[UIImage imageNamed:@"未操作不喜欢@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [footButton setImage:[[UIImage imageNamed:@"已操作不喜欢@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    [footButton setImage:[[UIImage imageNamed:@"已操作不喜欢@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateReserved];
    [footButton addTarget:self action:@selector(footClick) forControlEvents:UIControlEventTouchUpInside];
    
    [listTable addSubview:footButton];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)xiuhouRequest
{
    if (_xiehouArray.count >= 151 ) {
//        number = 0;
        [timer1 invalidate];
        [self updateLocationRequest];
    }
    
    NSString * urlStr = [NSString stringWithFormat:@"%@users/meet?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid"]];
    NSLog(@"udid = %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"udid"]);
    NSURL * url = [NSURL URLWithString:urlStr];
    xiehouRequest = [[ASIFormDataRequest alloc]initWithURL:url];
    
    [xiehouRequest setRequestMethod:@"GET"];
    [xiehouRequest setDelegate:self];
    
    [xiehouRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
    [xiehouRequest addRequestHeader:@"Authorization" value:Authorization];
    
    xiehouRequest.tag = 100;
    
    [xiehouRequest startAsynchronous];
 
}
-(void)updateLocationRequest
{
    NSNumber * lon = [[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"];
    NSNumber * lat = [[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"];
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:lon,@"longitude",lat,@"latitude", nil];
    NSLog(@"user = %@",user);
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        
        NSString * urlStr = [NSString stringWithFormat:@"%@users/update_location?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
        NSLog(@"更新用户位置 = %@",urlStr);
        NSURL * url = [NSURL URLWithString:urlStr];
        update_locationRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [update_locationRequest setRequestMethod:@"POST"];
        
        //1、header
        [update_locationRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //2、header
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        NSLog(@"更新用户位置 Authorization%@",Authorization);
        [update_locationRequest addRequestHeader:@"Authorization" value:Authorization];
        
        [update_locationRequest setDelegate:self];
        [update_locationRequest setPostBody:tempJsonData];
        update_locationRequest.tag = 107;
        [update_locationRequest startAsynchronous];
    }
}

#pragma mark - 上传数据的请求  tag = 110
-(void)UploadData
{
    if (visitUserArray.count == 0) {
        return;
    }
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:visitUserArray,@"data",nil];
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString * urlStr = [NSString stringWithFormat:@"%@users/visit_log?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid"]];
        NSURL * url = [NSURL URLWithString:urlStr];
        UploadDataRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [UploadDataRequest setRequestMethod:@"POST"];
        [UploadDataRequest setDelegate:self];
        
        [UploadDataRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        [UploadDataRequest addRequestHeader:@"Authorization" value:Authorization];
        
        UploadDataRequest.tag = 110;
        [UploadDataRequest setPostBody:tempJsonData];
        [UploadDataRequest startAsynchronous];
    }
    
    
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    //移除加载框
    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
    [bd removeFromSuperview];
    bd=nil;
    
    NSString *responseString=[request responseString];
    NSDictionary *dic2=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSLog(@"邂逅 获取信息 dic %@=====",dic2);
    /*------------获取邂逅信息的请求---------------*/
    if (request.tag == 100) {
        //解析接收回来的数据
        int statusCode = [request responseStatusCode];
        NSLog(@"邂逅  请求成功 statusCode %d",statusCode);
        if (statusCode == 200) {
            NSArray * array1 = [dic2 objectForKey:@"data"];
            for (int i = 0; i < array1.count; i++) {
                [_xiehouArray addObject:[[dic2 objectForKey:@"data"] objectAtIndex:i]];
            }
            NSLog(@"数组的个数%d",_xiehouArray.count);
            if (number == 0) {
                dic = [ _xiehouArray objectAtIndex:number] ;
                [imageArray removeAllObjects];
                NSArray * array = [dic objectForKey:@"recent_images"];
                for (int i = 0; i < array.count; i++) {
                    [imageArray addObject:[[array objectAtIndex:i] objectForKey:@"url"]];
                }
                [self createScrollImageView];
                [self createUI];
                [listTable reloadData];
                number = number + 1;
            }
            
        }
    }
    
    if (request.tag == 102) {
        int statusCode = [request responseStatusCode];
        NSString *responseString=[request responseString];
        NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
        NSLog(@"邂逅  请求成功 statusCode %d",statusCode);
        if (statusCode == 201) {
            
            NSLog(@"  %@",request.responseData);
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"温馨提示";
            HUD.detailsLabelText =@"头像上传成功!";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[[dic valueForKey:@"errors"] valueForKey:@"code"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag=1003;
            [alert show];
            
        }
        
    }
    
    /*------------上传用户数据-------------*/
    if (request.tag == 110) {
        int statusCode = [request responseStatusCode];
        NSLog(@"邂逅  请求成功 statusCode %d",statusCode);
        if (statusCode == 201) {
            [visitUserArray removeAllObjects];
            
        }else{
            
        }
        
    }
    
    //获取用户照片
    if (request.tag == 105) {
        int statusCode = [request responseStatusCode];
        NSLog(@"邂逅界面获取用户相册 %@",dic2);
        if (statusCode == 200 ) {
            [imageArr removeAllObjects];
    
            imageArr = [[dic2 objectForKey:@"data"] objectForKey:@"list"];
            page = [[[dic2 objectForKey:@"data"] objectForKey:@"next_page"] intValue];
            NSLog(@"LIST %@",[[dic2 objectForKey:@"data"] objectForKey:@"list"]);
            PhotoAlbumViewController * mpa = [[PhotoAlbumViewController alloc]init];
            mpa.page = page;
            mpa.imageArray = imageArr;
            mpa.pageName = @"view";
            mpa.avatarString = [dic objectForKey:@"avatar"];
            mpa.uuid = [dic objectForKey:@"uuid"];
            NSLog(@"uuid = %@",[dic objectForKey:@"uuid"]);
            mpa.nickName = [dic objectForKey:@"nickname"];
            [self.navigationController pushViewController:mpa animated:YES];
        }else if (statusCode == 400){
            NSLog(@"获取相册 error %@",[[dic2 valueForKey:@"errors"] valueForKey:@"code"]);
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                             message:[[dic2 valueForKey:@"errors"] valueForKey:@"code"]
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
            
        }
        
    }
    /* ===========================更新位置信息==========================*/
    if (request.tag == 107) {
        int statusCode = [request responseStatusCode];
        if (statusCode == 204 ) {

        }else if(statusCode == 400){

            
        }
        
    }
    
    if (request.tag == 108) {
        int statusCode = [request responseStatusCode];
        if (statusCode == 201) {
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"温馨提示";
            HUD.detailsLabelText =@"您已将此人添加为最爱!";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
        }else{
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"温馨提示";
            HUD.detailsLabelText =[[dic2 valueForKey:@"errors"] objectForKey:@"code"];
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
            
        }
    }
}


-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"邂逅 请求失败 responseString %@",[request responseString]);
    
    int statusCode = [request responseStatusCode];
    NSLog(@"邂逅 请求失败 statusCode %d",statusCode);
    
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

-(void)showLeft
{
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
    [dd showLeftController:YES];
}
-(void)createUI
{
   
    
}
-(void)largeImage:(UITapGestureRecognizer *)tap{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)tap;
    NSInteger index = [singleTap view].tag;
    // 创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 设置图片浏览器需要显示的所有图片
    int count = imageArray.count;
    if (count == 0) {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"该用户最近没有上传照片"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *array1 = [NSMutableArray array];
    for (int i = 0 ; i < count; i++) {
        UIImageView *iamgeView = [[UIImageView alloc]init];
        [iamgeView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i ]]];
        [array addObject:iamgeView];
    }
    for (int i = 0; i < count; i ++) {
        // 创建MJPhoto
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:imageArray[i]];
        // 设置来源
        photo.srcImageView = array[i];
        // 将MJPhoto添加到数组中
        [array1 addObject:photo];
    }
    browser.photos = array1;
    
    // 告诉图片浏览器当前显示哪张图片
    browser.currentPhotoIndex = index;
    // 显示图片浏览器
    [browser show];
    
}
-(void)photoAlbum
{
    [self getPhoto];
}
#pragma mark - 更多图片响应方法的实现   tag = 105
-(void)getPhoto
{
    NSString * urlStr = [NSString stringWithFormat:@"%@images?udid=%@&page=%@&uuid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ],[NSString stringWithFormat:@"%d",0],[dic objectForKey:@"uuid"]];
    NSLog(@"我的中心 urlStr = %@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    GetPicturesRequest = [[ASIFormDataRequest alloc]initWithURL:url];
    [GetPicturesRequest setRequestMethod:@"GET"];
    [GetPicturesRequest setDelegate:self];
    
    //1、header
    [GetPicturesRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    
    //2、header
    NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
    NSLog(@"Authorization%@",Authorization);
    [GetPicturesRequest addRequestHeader:@"Authorization" value:Authorization];
    
    GetPicturesRequest.tag = 105;
    [GetPicturesRequest startAsynchronous];
}
-(void)addPhoto
{
    
}
-(void)messageClick
{

    [[CDChatManager manager] fetchConvWithOtherId : [dic objectForKey:@"uuid"] callback : ^(AVIMConversation *conversation, NSError *error) {
        if (error) {
            DLog(@"%@", error);
        }
        else {
            LCEChatRoomVC *chatRoomVC = [[LCEChatRoomVC alloc] initWithConv:conversation];
            chatRoomVC.hidesBottomBarWhenPushed = YES;
            chatRoomVC.dic = dic;
            [self.navigationController pushViewController:chatRoomVC animated:YES];
        }
    }];
}
-(void)fingerClick
{
    [fingerButton setImage:[[UIImage imageNamed:@"已操作喜欢@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    userDic = [[NSMutableDictionary alloc]init];
    [userDic setObject:[dic objectForKey:@"uuid"] forKey:@"uuid"];
    actionString = @"1";
    [userDic setObject:actionString forKey:@"action"];
    NSLog(@"date = %f",[[NSDate date] timeIntervalSince1970]);
    NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    [userDic setObject:dateString forKey:@"dateline"];
     [visitUserArray addObject:userDic];
    NSLog(@"number = %d",number);
    
    if (number == _xiehouArray.count - 1) {
        NSLog(@"_xiehouArray.count - 1 = %d",_xiehouArray.count - 1);
        number = 0;
    }else{
        number = number + 1;
    }
    
    dic = [ _xiehouArray objectAtIndex:number];
    [imageArray removeAllObjects];
    NSArray * array = [dic objectForKey:@"recent_images"];
    for (int i = 0; i < array.count; i++) {
        [imageArray addObject:[[array objectAtIndex:i] objectForKey:@"url"]];
    }
    [self createScrollImageView];
    [self createUI];
    [listTable reloadData];

}
-(void)footClick
{
    [footButton setImage:[[UIImage imageNamed:@"已操作不喜欢@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
//    footButton.image = [UIImage imageNamed:@"已操作不喜欢@2x.png"];
    userDic = [[NSMutableDictionary alloc]init];
    [userDic setObject:[dic objectForKey:@"uuid"] forKey:@"uuid"];
    actionString = @"2";
    [userDic setObject:actionString forKey:@"action"];
     NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    [userDic setObject:dateString forKey:@"dateline"];
    [visitUserArray addObject:userDic];
    if (number == _xiehouArray.count - 1) {
        number = 0;
    }else{
        number = number + 1;
    }
    
    dic = [ _xiehouArray objectAtIndex:number];
    [imageArray removeAllObjects];
    NSArray * array = [dic objectForKey:@"recent_images"];
    for (int i = 0; i < array.count; i++) {
        [imageArray addObject:[[array objectAtIndex:i] objectForKey:@"url"]];
    }
    [self createScrollImageView];
    [self createUI];
    [listTable reloadData];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[statusArray objectAtIndex:section] isEqualToString:@"YES"] && section == 0) {
        return 13;
    }
    
    if ([[statusArray objectAtIndex:section] isEqualToString:@"YES"] && section == 1) {
        if ([[dic objectForKey:@"is_favorite"] intValue] == 1) {
            return 4;
        }else{
            UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"只有我喜欢你的时候才会告诉你哦!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
        }
        
        
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 4) {
        return 163;
    }
    if (indexPath.section == 0 && indexPath.row == 5){
        return 140;
    }
    if (indexPath.section == 0 && indexPath.row == 6) {
        return 105;
    }
    return 70;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 0)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    if (section == 0) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, view.frame.size.width - 10 - 20 - 30, 30)];
        NSString * age = nil;
        if ([[dic objectForKey:@"birthday"] isEqualToString:@""]) {
            age = [NSString stringWithFormat:@"%@",@"0"];
        }else{
            NSDateFormatter * formater = [[NSDateFormatter alloc]init];
            [formater setDateFormat:@"yyyy-MM-dd"];
            NSDate * date = [formater dateFromString:[dic objectForKey:@"birthday"]];
            NSTimeInterval dateDiff = [date timeIntervalSinceNow];
            int age1=trunc(dateDiff/(60*60*24))/365;
            NSString * ageString = [NSString stringWithFormat:@"%d",age1];
            NSLog(@"agestring = %@",ageString);
            NSArray * array12 = [ageString componentsSeparatedByString:@"-"];
            if (array12.count == 1) {
                age = [NSString stringWithFormat:@"%@",[array12 objectAtIndex:0]];
            }else{
                age = [NSString stringWithFormat:@"%@",[array12 objectAtIndex:1]];
            }
            
            NSLog(@"age = %@",age);
        }
        label.text = [NSString stringWithFormat:@"%@,%@",[dic objectForKey:@"nickname"],age];
        [view addSubview:label];
        
//       addFavoriteButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        addFavoriteButton.tag = section+100 + 2;
//        if ([[dic objectForKey:@"is_favorite"] intValue] == 0) {
//            [addFavoriteButton setImage:[[UIImage imageNamed:@"添加最爱@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        }else{
//            [addFavoriteButton setImage:[[UIImage imageNamed:@"已添加最爱@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        }
//        
//        addFavoriteButton.frame = CGRectMake(view.frame.size.width - 20 - 30, 7, 30, 30);
//        [addFavoriteButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        addFavoriteButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//        [addFavoriteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        addFavoriteButton.showsTouchWhenHighlighted = YES;
//        [view addSubview:addFavoriteButton];
    }
    if (section == 1) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = section+100;
       [button setTitle:@"隐私资料" forState:UIControlStateNormal];
        button.frame = CGRectMake(10, 7, 100, 30);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.showsTouchWhenHighlighted = YES;
        [view addSubview:button];
    }
    
    
    return view;
}
#pragma mark - button点击事件处理
-(void)buttonClick:(UIButton *)button {
    NSInteger index = button.tag - 100;
    {
        if ([[statusArray objectAtIndex:index] isEqualToString:@"YES"]) {
            [statusArray replaceObjectAtIndex:index withObject:@"NO"];
            //在这里改变按钮的标题是没有意义的，因为刷新的时候也要重新刷新按钮标题
        } else {
            [statusArray replaceObjectAtIndex:index withObject:@"YES"];
        }
        //因为已经显示完成tableView了，所以，对于按钮的点击来说，仅仅是改变了一个数组一个字符串的值。并不会去让tableView调用。。。方法
        //我们需要做的就是通知tableView需要去刷新了
        //    [_tableView reloadData];//重新加载数据
        //对于上面的刷新来说，太重了，我们只是一组收起或展开，并不影响其他组，没必要整个表格都刷新
        
        //<#(NSIndexSet *)#>是一个数字的集合类
        NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:index];//用一个index来创建一个集合，这个集合里只有一个数就是index
        //刷新indexSet里面的分组，第二个参数为动画效果
        [listTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 && indexPath.row == 5) {
        [listTable registerNib:[UINib nibWithNibName:@"messageOfMeTableViewCell" bundle:nil] forCellReuseIdentifier:@"messageOfMeTableViewCell1"];
        messageOfMeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"messageOfMeTableViewCell1"];
        if (!cell) {
            cell = [[messageOfMeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageOfMeTableViewCell1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tagLabel.text = @"外貌";
        cell.heightLabel.text = @"170cm";
        cell.weightLabel.text = @"60公斤";
        cell.shapeLabel.text = @"标准";
        cell.skinLabel.text = @"超白净";
        cell.titleLabel5.hidden = YES;
        cell.timeLabel.hidden = YES;
        cell.editButton.hidden = YES;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 6)
    {
        [listTable registerNib:[UINib nibWithNibName:@"messageOfMeTableViewCell" bundle:nil] forCellReuseIdentifier:@"messageOfMeTableViewCell2"];
        messageOfMeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"messageOfMeTableViewCell2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[messageOfMeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageOfMeTableViewCell2"];
        }
        cell.tagLabel.text = @"居住情况";
        cell.titleLabel1.text = @"住房:";
        cell.titleLabel2.text = @"和谁住:";
        cell.titleLabel3.text = @"车子:";
        cell.heightLabel.text = @"自有住房有贷款";
        cell.weightLabel.text = @"和同学一起住";
        cell.shapeLabel.text = @"有车 现代悦翔V7";
        cell.skinLabel.hidden = YES;
        cell.titleLabel4.hidden = YES;
        cell.titleLabel5.hidden = YES;
        cell.timeLabel.hidden = YES;
        cell.editButton.hidden = YES;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 1)
    {
        [listTable registerNib:[UINib nibWithNibName:@"badgeTableViewCell" bundle:nil] forCellReuseIdentifier:@"badgeTableViewCell"];
        badgeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"badgeTableViewCell"];
        if (!cell) {
            cell = [[badgeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"badgeTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tagLabel.text = @"徽章";
        cell.tag1.text = @"性能力强";
        cell.tag2.text = @"颜值高";
        cell.tag3.text = @"多金";
        [cell.tag4Button setTitle:@"......" forState:UIControlStateNormal];
        
        
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 4)
    {
        [listTable registerNib:[UINib nibWithNibName:@"messageOfMeTableViewCell" bundle:nil] forCellReuseIdentifier:@"messageOfMeTableViewCell3"];
        messageOfMeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"messageOfMeTableViewCell3"];
        if (!cell) {
            cell = [[messageOfMeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageOfMeTableViewCell3"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //性别
        NSInteger num = [[dic objectForKey:@"gender"] integerValue];
        NSNumber * num1 = [NSNumber numberWithInteger:num];
        NSString * gender = [BasicInformation getGender:num1];
        //体位
        NSInteger num2 = [[dic objectForKey:@"sexual_position"] integerValue];
        NSNumber * num3 = [NSNumber numberWithInteger:num2];
        NSString * sexual_position = [BasicInformation getSexual_position:num3];
        //性取向
        NSInteger num4 = [[dic objectForKey:@"sexual_orientation"] integerValue];
        NSNumber * num5 = [NSNumber numberWithInteger:num4];
        NSString * sexual_orientation = [BasicInformation getSexual_orientation:num5];
        //性爱频率
        NSString * string = [NSString stringWithFormat:@"一周%@次",[dic objectForKey:@"sexual_frequency"]];
       //性爱时长
        NSInteger num6 = [[dic objectForKey:@"sexual_duration"] integerValue];
        NSNumber * num7 = [NSNumber numberWithInteger:num6];
        NSString * sexual_duration = [BasicInformation getSexual_duration:num7];

        cell.tagLabel.text = @"性取向";
        cell.titleLabel1.text = @"性别:";
        cell.titleLabel5.text = @"体位:";
        cell.titleLabel3.text = @"性取向:";
        cell.titleLabel4.text = @"性爱频率:";
        cell.titleLabel5.text = @"性爱时长:";
        cell.heightLabel.text = gender;
        cell.weightLabel.text = sexual_position;
        cell.shapeLabel.text = sexual_orientation;
        cell.skinLabel.text = string;
        cell.timeLabel.text = sexual_duration;
        cell.editButton.hidden = YES;
        
        return cell;
    }else{
        [listTable registerNib:[UINib nibWithNibName:@"MyCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCenterTableViewCell"];
        MyCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyCenterTableViewCell"];
        if (!cell) {
            cell = [[MyCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCenterTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.editButton.hidden = YES;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                NSString * addressString = [[NSString alloc]init];
                if ([[dic objectForKey:@"province"] isNotEmpty] && [[dic objectForKey:@"city"] isNotEmpty]) {
                    addressString = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"province"],[dic objectForKey:@"city"]];
                }else if ([[dic objectForKey:@"province"] isNotEmpty]){
                    addressString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"province"]];
                }else if([[dic objectForKey:@"city"] isNotEmpty]){
                    addressString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"city"]];
                }else{
                    addressString = [NSString stringWithFormat:@"%@",@"未填写"];
                }

                cell.tagLabel.text = @"位置";
                cell.contentLabel.text = addressString;
            }
            if (indexPath.row == 2) {
                NSInteger num = [[dic objectForKey:@"purpose"] integerValue];
                NSNumber * num1 = [NSNumber numberWithInteger:num];
                NSString * purpose = [BasicInformation getPurpose:num1];
                NSString * purposeString = nil;
                if ([purpose isEqualToString:@"未填写"]) {
                    purposeString = [NSString stringWithFormat:@"%@",purpose];
                }else{
                    purposeString = [NSString stringWithFormat:@"我想%@",purpose];
                }

                cell.tagLabel.text = @"关于我";
                cell.contentLabel.text = purposeString;
            }
            if (indexPath.row == 3) {
                cell.tagLabel.text = @"恋爱状态";
                cell.contentLabel.text = @"单不单不影响交友";
            }
            
            if (indexPath.row == 7) {
                cell.tagLabel.text = @"收入";
                cell.contentLabel.text = @"5万-10万";
            }
            if (indexPath.row == 8) {
                cell.tagLabel.text = @"健康";
                cell.contentLabel.text = @"2根/天";
            }
            if (indexPath.row == 9) {
                cell.tagLabel.text = @"喝酒情况";
                cell.contentLabel.text = @"不喜欢喝但身不由己";
            }
            if (indexPath.row == 10) {
                cell.tagLabel.text = @"运动";
                cell.contentLabel.text = @"规律运动";
            }
            if (indexPath.row == 11) {
                cell.tagLabel.text = @"性能力";
                cell.contentLabel.text = @"一般（详细部分在隐私资料）";
            }
            if (indexPath.row == 12) {
                cell.tagLabel.text = @"性格";
                cell.contentLabel.text = @"很有自己的想法，特立独行";
            }
            
        }
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.tagLabel.text = @"我交往过的女朋友个数";
                cell.contentLabel.text = @"3个";
            }
            if (indexPath.row == 1) {
                cell.tagLabel.text = @"我最长的一次性爱时间";
                cell.contentLabel.text = @"3个";
            }
            if (indexPath.row == 2) {
                cell.tagLabel.text = @"我最短的一次性爱时间";
                cell.contentLabel.text = @"3个";
            }
            if (indexPath.row == 3) {
                cell.tagLabel.text = @"我最爱的性爱伴侣";
                cell.contentLabel.text = @"3个";
            }
        }
        return cell;
    }

}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)dealloc
{
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [super viewWillDisappear:animated];
    if ([actionString isEqualToString:@"1"] && [actionString isEqualToString:@"2"]) {
        userDic = [[NSMutableDictionary alloc]init];
        [userDic setObject:[dic objectForKey:@"uuid"] forKey:@"uuid"];
        actionString = @"0";
        [userDic setObject:actionString forKey:@"action"];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormatter stringFromDate:[NSDate date]];
        [userDic setObject:dateString forKey:@"dateline"];
        
    }
    [self UploadData];
    [timer invalidate];
    [timer1 invalidate];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [update_locationRequest setDelegate:nil];
    [xiehouRequest setDelegate:nil];
    [GetPicturesRequest setDelegate:nil];
    [UploadDataRequest setDelegate:nil];
    [addFavoriteFriendRequest setDelegate:nil];
    [update_locationRequest cancel];
    [xiehouRequest cancel];
    [GetPicturesRequest cancel];
    [UploadDataRequest cancel];
    [addFavoriteFriendRequest cancel];
    
}
- (void)setBadgeWithTotalUnreadCount:(NSInteger)totalUnreadCount {
    if (totalUnreadCount > 0) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)totalUnreadCount];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:totalUnreadCount];
    }
    else {
        self.tabBarItem.badgeValue = nil;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}
-(void)addFavorite:(id)sender
{
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:[dic objectForKey:@"uuid"],@"uuid", nil];
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString * urlStr = [NSString stringWithFormat:@"%@favorite?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
        NSLog(@"添加最爱的人  %@",urlStr);
        NSURL * url = [NSURL URLWithString:urlStr];
        addFavoriteFriendRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        
        [addFavoriteFriendRequest setRequestMethod:@"POST"];
        
        [addFavoriteFriendRequest setDelegate:self];
        
        //1、
        [addFavoriteFriendRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //2、header
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        NSLog(@"找朋友 Authorization%@",Authorization);
        [addFavoriteFriendRequest addRequestHeader:@"Authorization" value:Authorization];
        
        addFavoriteFriendRequest.tag = 108;
        
        [addFavoriteFriendRequest setPostBody:tempJsonData];
        [addFavoriteFriendRequest startAsynchronous];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
