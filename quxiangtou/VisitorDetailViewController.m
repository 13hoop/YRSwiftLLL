//
//  VisitorDetailViewController.m
//  quxiangtou
//
//  Created by mac on 15/9/16.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "VisitorDetailViewController.h"
#import "LoginModel.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "PhotoAlbumViewController.h"
#import "LCEChatRoomVC.h"

#import "MyCenterTableViewCell.h"
#import "badgeTableViewCell.h"
#import "messageOfMeTableViewCell.h"

@interface VisitorDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView * listTable;
    NSMutableDictionary * dic;
    NSString * nickName;
    UILabel * addressLabel;
    UILabel * purposeLabel;
    UILabel * nickNameLabel;
    NSMutableArray * imageArray;
    NSMutableArray * imageArr;
    NSMutableArray * visitUserArray;
    NSMutableDictionary * userDic;
    NSString * actionString;
    
    NSTimer * timer;
    
    UIScrollView * _scrollView;
    int pageImage;
    BOOL isRefresh;
    
    NSArray * basicArray;
    
    UIImageView * footButton;
    UIImageView * fingerButton;
    UIButton * addFavoriteButton;
    
    
}
@end

@implementation VisitorDetailViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userDic = [[NSMutableDictionary alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFavoriteChangeImage:) name:@"deleteFavorite" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFavoriteChangeImage:) name:@"addFavorite" object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    basicArray = @[@"位置",@"徽章",@"关于我",@"性取向"];
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64);
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
    pageImage = 0;
    isRefresh = YES;
    actionString = @"0";
    imageArray  = [[NSMutableArray alloc]init];
    visitUserArray = [[NSMutableArray alloc]init];
    dic = [_visitorArray objectAtIndex:_page];
    [imageArray removeAllObjects];
    NSArray * array = [dic objectForKey:@"recent_images"];
    for (int i = 0; i < array.count; i++) {
        [imageArray addObject:[[array objectAtIndex:i] objectForKey:@"url"]];
    }
    self.navigationItem.title = @"详细信息";
    [self createScrollImageView];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)createScrollImageView
{
    //创建scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_width)];
    _scrollView.backgroundColor = [UIColor blackColor];
    for(UIView *view in [_scrollView subviews])
    {
        [view removeFromSuperview];
    }
    if (imageArray.count == 0) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_width)];
        imageView.image = [UIImage imageNamed:@"加载失败图片@3x.png"];
        imageView.tag = 0;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(largeImage:)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
    }else{
        for (int i = 0; i < imageArray.count;i++) {
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*Screen_width, 0, Screen_width, Screen_width)];
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]
                                           ] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
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
    
    listTable=[[UITableView alloc]initWithFrame:CGRectMake(0,0, Screen_width,Screen_height-65) style:UITableViewStyleGrouped];
    listTable.delegate=self;
    listTable.tableHeaderView = _scrollView;
    listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    listTable.showsHorizontalScrollIndicator = NO;
    listTable.showsVerticalScrollIndicator = NO;
    listTable.dataSource=self;
    [self.view addSubview:listTable];
    
    UIImageView * cameraButton = [[UIImageView alloc]initWithFrame:CGRectMake(10, _scrollView.frame.origin.y + _scrollView.frame.size.height - 100 + 64, 36.5, 25)];
    cameraButton.userInteractionEnabled = YES;
    cameraButton.image = [UIImage imageNamed:@"相机 00@2x.png"];
    [listTable addSubview:cameraButton];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoAlbum)];
    [cameraButton addGestureRecognizer:tap];
    
    fingerButton = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width / 2 - 70, _scrollView.frame.size.height - 70 , 60, 60)];
    fingerButton.userInteractionEnabled = YES;
    if ([[dic objectForKey:@"feeling"]intValue] == 0) {
        //白心
        fingerButton.image = [UIImage imageNamed:@"未操作喜欢@2x.png"];
        UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addLike)];
        [fingerButton addGestureRecognizer:tap4];
    }else if ([[dic objectForKey:@"feeling"]intValue] == 1){
        //红心
        fingerButton.image = [UIImage imageNamed:@"已操作喜欢@2x.png"];
    }else if ([[dic objectForKey:@"feeling"]intValue] == 2){
        //白心
        fingerButton.image = [UIImage imageNamed:@"未操作喜欢@2x.png"];
        UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addLike)];
        [fingerButton addGestureRecognizer:tap4];
    }
    [listTable addSubview:fingerButton];

    footButton = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width / 2 + 10,_scrollView.frame.size.height - 70 , 60, 60)];
    footButton.userInteractionEnabled = YES;
    footButton.image = [UIImage imageNamed:@"喜欢聊天@2x.png"];
    [listTable addSubview:footButton];
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(messageClick)];
    [footButton addGestureRecognizer:tap4];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)addLike
{
    [self UploadData];
}
#pragma mark - 上传数据的请求  tag = 110
-(void)UploadData
{
    userDic = [[NSMutableDictionary alloc]init];
    [userDic setObject:[dic objectForKey:@"uuid"] forKey:@"uuid"];
    actionString = @"1";
    [userDic setObject:actionString forKey:@"action"];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormatter stringFromDate:[NSDate date]];
    [userDic setObject:dateString forKey:@"dateline"];
    [visitUserArray addObject:userDic];
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
          /*------------上传用户数据-------------*/
    if (request.tag == 110) {
        int statusCode = [request responseStatusCode];
      
        if (statusCode == 201) {
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"温馨提示";
            HUD.detailsLabelText =@"您已喜欢TA!";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
            [visitUserArray removeAllObjects];
            fingerButton.image = [UIImage imageNamed:@"已操作喜欢@2x.png"];
            fingerButton.userInteractionEnabled = NO;
        }else{
            
        }
        
    }
    
    if (request.tag == 105) {
        int statusCode = [request responseStatusCode];
        NSLog(@"邂逅界面获取用户相册 %@",dic2);
        if (statusCode == 200 ) {
            [imageArr removeAllObjects];
            
            imageArr = [[dic2 objectForKey:@"data"] objectForKey:@"list"];
            pageImage = [[dic2 objectForKey:@"next_page"] intValue];
            NSLog(@"LIST %@",[[dic2 objectForKey:@"data"] objectForKey:@"list"]);
            PhotoAlbumViewController * mpa = [[PhotoAlbumViewController alloc]init];
            mpa.page = pageImage;
            mpa.imageArray = imageArr;
            mpa.pageName = @"view";
            mpa.uuid = [dic objectForKey:@"uuid"];
            mpa.avatarString = [dic objectForKey:@"avatar"];
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
    if (request.tag == 108) {
        int statusCode = [request responseStatusCode];
        if (statusCode == 201) {
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"温馨提示";
            if ([[dic objectForKey:@"is_favorite"] intValue] == 1) {
                HUD.detailsLabelText =@"您已将此人添加为最爱!";
            }else{
                HUD.detailsLabelText =@"成功取消最爱!";
            }
            
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
    
    if (request.tag == 109) {
        int statusCode = [request responseStatusCode];
        if (statusCode == 204) {
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"温馨提示";
            HUD.detailsLabelText =@"成功取消最爱!";
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
    NSLog(@"访客详细页 请求失败 responseString %@",[request responseString]);
    
    int statusCode = [request responseStatusCode];
    NSLog(@"访客详细页 请求失败 statusCode %d",statusCode);
    
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
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark - 更多图片响应方法的实现
-(void)getPhoto
{
    NSString * urlStr = [NSString stringWithFormat:@"%@images?udid=%@&page=%@&uuid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ],[NSString stringWithFormat:@"%d",pageImage],[dic objectForKey:@"uuid"]];
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
            chatRoomVC.dic = dic;
            chatRoomVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatRoomVC animated:YES];
        }
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    return basicArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 3) {
        return 163;
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
//        age = [NSString stringWithFormat:@"%@",[array12 objectAtIndex:1]];
        NSLog(@"age = %@",age);
    }
    label.text = [NSString stringWithFormat:@"%@,%@",[dic objectForKey:@"nickname"],age];
    [view addSubview:label];
    
    addFavoriteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addFavoriteButton.tag = section+100 + 2;
    if ([[dic objectForKey:@"is_favorite"] intValue] == 0) {
        [addFavoriteButton setImage:[[UIImage imageNamed:@"添加最爱@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        [addFavoriteButton setImage:[[UIImage imageNamed:@"已添加最爱@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    
    addFavoriteButton.frame = CGRectMake(view.frame.size.width - 20 - 30, 7, 30, 30);
    [addFavoriteButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    addFavoriteButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [addFavoriteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addFavoriteButton.showsTouchWhenHighlighted = YES;
    [view addSubview:addFavoriteButton];
    
    return view;
}
#pragma mark - button点击事件处理
-(void)buttonClick:(UIButton *)button {
    NSInteger index = button.tag - 100;
    if (index == 2) {
        if ([[dic objectForKey:@"is_favorite"] intValue] == 0) {
            [self addFavorite:button];
            if (!button.selected) {
                [addFavoriteButton setImage:[[UIImage imageNamed:@"已添加最爱@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }else{
                [addFavoriteButton setImage:[[UIImage imageNamed:@"添加最爱@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }
        }else{
            [self deleteFavorite:button];
            if (!button.selected) {
                [addFavoriteButton setImage:[[UIImage imageNamed:@"添加最爱@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }else{
                [addFavoriteButton setImage:[[UIImage imageNamed:@"已添加最爱@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }
        }
        NSString * favorite = nil;
        if ([[dic objectForKey:@"is_favorite"] intValue] == 0) {
            favorite = @"1";
        }else{
            favorite = @"0";
        }
        [dic removeObjectForKey:@"is_favorite"];
        NSLog(@"删除后 dic = %@",dic);
        [dic setObject:favorite forKey:@"is_favorite"];
        NSLog(@"添加后 dic = %@",dic);
        
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 1)
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
    }else if (indexPath.row == 3)
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
//    if ([actionString isEqualToString:@"1"] && [actionString isEqualToString:@"2"]) {
//        userDic = [[NSMutableDictionary alloc]init];
//        [userDic setObject:[dic objectForKey:@"uuid"] forKey:@"uuid"];
//        actionString = @"0";
//        [userDic setObject:actionString forKey:@"action"];
//        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *dateString=[dateFormatter stringFromDate:[NSDate date]];
//        [userDic setObject:dateString forKey:@"dateline"];
//        
//    }
//    [self UploadData];
    [timer invalidate];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UploadDataRequest cancel];
    [xiehouRequest cancel];
    [GetPicturesRequest cancel];
    [addFavoriteFriendRequest setDelegate:nil];
    [UploadDataRequest setDelegate:nil];
    [xiehouRequest setDelegate:nil];
    [GetPicturesRequest setDelegate:nil];
    [addFavoriteFriendRequest cancel];
    
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
-(void)deleteFavorite:(id)sender
{
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:[dic objectForKey:@"uuid"],@"uuid", nil];
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString * urlStr = [NSString stringWithFormat:@"%@favorite/delete?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
        NSLog(@"添加最爱的人  %@",urlStr);
        NSURL * url = [NSURL URLWithString:urlStr];
        deleteFavoriteFriendRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        
        [deleteFavoriteFriendRequest setRequestMethod:@"POST"];
        
        [deleteFavoriteFriendRequest setDelegate:self];
        
        //1、
        [deleteFavoriteFriendRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //2、header
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        NSLog(@"找朋友 Authorization%@",Authorization);
        [deleteFavoriteFriendRequest addRequestHeader:@"Authorization" value:Authorization];
        
        deleteFavoriteFriendRequest.tag = 109;
        
        [deleteFavoriteFriendRequest setPostBody:tempJsonData];
        [deleteFavoriteFriendRequest startAsynchronous];
    }
    
    
}
-(void)deleteFavoriteChangeImage:(NSNotification *)noti
{
    [addFavoriteButton setImage:[[UIImage imageNamed:@"添加最爱@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}
-(void)addFavoriteChangeImage:(NSNotification *)noti
{
//    NSDictionary * dic = noti.object;
//    NSString * string = [dic objectForKey:@"favorite"];
    [addFavoriteButton setImage:[[UIImage imageNamed:@"已添加最爱@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
