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
    
    
}
@end

@implementation VisitorDetailViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userDic = [[NSMutableDictionary alloc]init];
        
//        [self UploadData];
//        timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(UploadData) userInfo:nil repeats:YES];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
//    leftButton.backgroundColor = [[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"顶操04@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
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
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_width - 50)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    for(UIView *view in [_scrollView subviews])
    {
        [view removeFromSuperview];
    }
    if (imageArray.count == 0) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_width - 50)];
        imageView.image = [UIImage imageNamed:@"加载失败图片@3x.png"];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(largeImage)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
    }else{
        for (int i = 0; i < imageArray.count;i++) {
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*Screen_width, 0, Screen_width, Screen_width - 50)];
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]
                                           ] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(largeImage)];
            [imageView addGestureRecognizer:tap];
            [_scrollView addSubview:imageView];
        }
    }
    
    _scrollView.contentSize = CGSizeMake(imageArray.count*Screen_width, 184);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    UIImageView * cameraButton = [[UIImageView alloc]initWithFrame:CGRectMake(10, _scrollView.frame.origin.y + _scrollView.frame.size.height - 100 + 64, 36.5, 25)];
    cameraButton.userInteractionEnabled = YES;
    cameraButton.image = [UIImage imageNamed:@"相机 00@2x.png"];
    [self.view addSubview:cameraButton];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoAlbum)];
    [cameraButton addGestureRecognizer:tap];
    
    UIImageView * messageButton = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width - 25 - 10, _scrollView.frame.origin.y + _scrollView.frame.size.height - 100 + 64, 27, 25)];
    messageButton.userInteractionEnabled = YES;
    messageButton.image = [UIImage imageNamed:@"信息@2x.png"];
    [self.view addSubview:messageButton];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(messageClick)];
    [messageButton addGestureRecognizer:tap2];
    
    UIImageView * fingerButton = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width / 2 - 70, _scrollView.frame.size.height - 70 , 60, 60)];
    fingerButton.userInteractionEnabled = YES;
    fingerButton.image = [UIImage imageNamed:@"点赞@2x.png"];
    [self.view addSubview:fingerButton];
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fingerClick)];
    [fingerButton addGestureRecognizer:tap3];
    
    UIImageView * footButton = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_width / 2 + 10,_scrollView.frame.size.height - 70 , 60, 60)];
    footButton.userInteractionEnabled = YES;
    footButton.image = [UIImage imageNamed:@"踩@2x.png"];
    [self.view addSubview:footButton];
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(footClick)];
    [footButton addGestureRecognizer:tap4];
    
    UIView * nickView = [[UIView alloc]initWithFrame:CGRectMake(0, _scrollView.frame.size.height + 64, Screen_width, 40)];
    nickView.userInteractionEnabled = YES;
    nickView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nickView];
    
    nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, Screen_width - 10 - 100, 40)];
    nickNameLabel.text = [dic objectForKey:@"nickname"];
    nickNameLabel.textAlignment = NSTextAlignmentLeft;
    nickNameLabel.font = [UIFont boldSystemFontOfSize:20];
    [nickView addSubview:nickNameLabel];
    
    UILabel * ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width - 10 - 80, 0, 80, 40)];
    if ([[dic objectForKey:@"birthday"] isEqualToString:@""]) {
        ageLabel.text = [NSString stringWithFormat:@"%@",@"未填写"];
    }else{
        NSDateFormatter * formater = [[NSDateFormatter alloc]init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        NSDate * date = [formater dateFromString:[dic objectForKey:@"birthday"]];
        NSTimeInterval dateDiff = [date timeIntervalSinceNow];
        int age=trunc(dateDiff/(60*60*24))/365;
        NSString * ageString = [NSString stringWithFormat:@"%d",age];
        NSArray * array = [ageString componentsSeparatedByString:@"-"];
        if (array.count == 2) {
            ageLabel.text = [NSString stringWithFormat:@"%@",[array objectAtIndex:1]];
        }else{
            ageLabel.text = [NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
        }
        
    }
    
    ageLabel.textAlignment = NSTextAlignmentRight;
    ageLabel.textColor = color_alpha(255, 26, 63, 1);
    [nickView addSubview:ageLabel];
    
    listTable=[[UITableView alloc]initWithFrame:CGRectMake(0,_scrollView.frame.size.height, self.view.frame.size.width,Screen_height-_scrollView.frame.size.height-65) style:UITableViewStyleGrouped];
    listTable.delegate=self;
    listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    listTable.dataSource=self;
    listTable.tableHeaderView = nickView;
    [self.view addSubview:listTable];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
#pragma mark - 上传数据的请求  tag = 110
-(void)UploadData
{
    if (visitUserArray.count == 0) {
        return;
    }
    //    [visitUserArray removeAllObjects];
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
            [visitUserArray removeAllObjects];
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
-(void)largeImage{
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
    browser.currentPhotoIndex = 0;
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
-(void)fingerClick
{
    userDic = [[NSMutableDictionary alloc]init];
    [userDic setObject:[dic objectForKey:@"uuid"] forKey:@"uuid"];
    actionString = @"1";
    [userDic setObject:actionString forKey:@"action"];
    NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    [userDic setObject:dateString forKey:@"dateline"];
    [visitUserArray addObject:userDic];
    NSLog(@"fingerClick  visitUserArray = %@ ",visitUserArray);
    [self UploadData];
    _page = _page + 1;
    if (_page == _visitorArray.count) {
        _page = 0;
    }
    dic = [ _visitorArray objectAtIndex:_page];
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
    
    userDic = [[NSMutableDictionary alloc]init];
    [userDic setObject:[dic objectForKey:@"uuid"] forKey:@"uuid"];
    actionString = @"2";
    [userDic setObject:actionString forKey:@"action"];
    NSString *dateString = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    [userDic setObject:dateString forKey:@"dateline"];
    [visitUserArray addObject:userDic];
    NSLog(@"footClick  visitUserArray = %@ ",visitUserArray);
    [self UploadData];
    _page = _page + 1;
    if (_page == _visitorArray.count) {
        _page = 0;
    }
    dic = [ _visitorArray objectAtIndex:_page];
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
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return 5;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
        imageView.image = [UIImage imageNamed:@"定位@2x.png"];
        [view addSubview:imageView];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width + 10 + 20, 5, Screen_width - imageView.frame.size.width - 30, 20)];
        [label setText:@"当前位置"];
        label.textAlignment = NSTextAlignmentLeft;
        [view addSubview:label];
    }else if (section == 1) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
        imageView.image = [UIImage imageNamed:@"爱好@2x.png"];
        [view addSubview:imageView];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width + 10 + 20, 5, Screen_width - imageView.frame.size.width - 30, 20)];
        [label setText:@"爱好"];
        label.textAlignment = NSTextAlignmentLeft;
        [view addSubview:label];
        
    }else if (section == 2) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
        imageView.image = [UIImage imageNamed:@"个人资料—关于我@2x.png"];
        [view addSubview:imageView];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width + 10 + 20, 5, Screen_width - imageView.frame.size.width - 30, 20)];
        [label setText:@"关于我"];
        label.textAlignment = NSTextAlignmentLeft;
        [view addSubview:label];
        
    }else if (section == 3) {
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
        imageView.image = [UIImage imageNamed:@"个人资料—性信息@2x.png"];
        [view addSubview:imageView];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width + 10 + 20, 5, Screen_width - imageView.frame.size.width - 85, 20)];
        [label setText:@"性信息"];
        label.textAlignment = NSTextAlignmentLeft;
        [view addSubview:label];
        
    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array = @[@"xiehouaddress",@"xiehouLike",@"xiehoume",@"xiehousex"];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[array objectAtIndex:indexPath.section]];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[array objectAtIndex:indexPath.section]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 1, cell.frame.size.height)];
    line.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:line];
    //当前位置
    if (indexPath.section == 0 && indexPath.row == 0) {
        
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
        addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, Screen_width - 60, 30)];
        addressLabel.textAlignment = NSTextAlignmentLeft;
        addressLabel.text = addressString;
        [cell.contentView addSubview:addressLabel];
        
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        for (int i = 0; i < 3; i++) {
            UILabel * Likelabel1 = [[UILabel alloc]initWithFrame:CGRectMake(50 + i * 80, 5, 70, 30)];
            Likelabel1.backgroundColor = [UIColor redColor];
            Likelabel1.text = @"羽毛球";
            Likelabel1.textAlignment = NSTextAlignmentCenter;
            Likelabel1.layer.cornerRadius = 5;
            Likelabel1.layer.masksToBounds = YES;
            [cell.contentView addSubview:Likelabel1];
        }
        
        
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        NSInteger num = [[dic objectForKey:@"purpose"] integerValue];
        NSNumber * num1 = [NSNumber numberWithInteger:num];
        NSString * purpose = [BasicInformation getPurpose:num1];
        NSString * purposeString = [NSString stringWithFormat:@"我想%@",purpose];
        purposeLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, Screen_width - 70, 40)];
        purposeLabel.text = purposeString;
        [cell.contentView addSubview:purposeLabel];
        
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 70, 30)];
            label3.text = @"性爱频率";
            label3.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:label3];
            UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(label3.frame.size.width + label3.frame.origin.x + 10, 5, 150, 30)];
            //label2.backgroundColor = [UIColor yellowColor];
            label4.textAlignment = NSTextAlignmentLeft;
            
            NSString * string = [NSString stringWithFormat:@"一周%@次",[dic objectForKey:@"sexual_frequency"]];
            label4.text = string;
            [cell.contentView addSubview:label4];
        }else if (indexPath.row == 1) {
            UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 70, 30)];
            label3.text = @"性爱时长";
            label3.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:label3];
            UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(label3.frame.size.width + label3.frame.origin.x + 10, 5, 150, 30)];
            //label2.backgroundColor = [UIColor yellowColor];
            label4.textAlignment = NSTextAlignmentLeft;
            
            NSInteger num = [[dic objectForKey:@"sexual_duration"] integerValue];
            NSNumber * num1 = [NSNumber numberWithInteger:num];
            NSString * sexual_duration = [BasicInformation getSexual_duration:num1];
            label4.text = sexual_duration;
            [cell.contentView addSubview:label4];
        }else if (indexPath.row == 2) {
            UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 70, 30)];
            label3.text = @"性取向";
            label3.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:label3];
            UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(label3.frame.size.width + label3.frame.origin.x + 10, 5, 150, 30)];
            //label2.backgroundColor = [UIColor yellowColor];
            label4.textAlignment = NSTextAlignmentLeft;
            
            NSInteger num = [[dic objectForKey:@"sexual_orientation"] integerValue];
            NSNumber * num1 = [NSNumber numberWithInteger:num];
            NSString * sexual_orientation = [BasicInformation getSexual_orientation:num1];
            label4.text = sexual_orientation;
            [cell.contentView addSubview:label4];
        }else if (indexPath.row == 3) {
            UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 70, 30)];
            label3.text = @"体位";
            label3.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:label3];
            UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(label3.frame.size.width + label3.frame.origin.x + 10, 5, 150, 30)];
            //label2.backgroundColor = [UIColor yellowColor];
            label4.textAlignment = NSTextAlignmentLeft;
            
            NSInteger num = [[dic objectForKey:@"sexual_position"] integerValue];
            NSNumber * num1 = [NSNumber numberWithInteger:num];
            NSString * sexual_position = [BasicInformation getSexual_position:num1];
            label4.text = sexual_position;
            [cell.contentView addSubview:label4];
        }else if (indexPath.row == 4) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 70, 30)];
            label.text = @"性别";
            label.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:label];
            UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.size.width + label.frame.origin.x + 10, 5, 150, 30)];
            //label2.backgroundColor = [UIColor yellowColor];
            label4.textAlignment = NSTextAlignmentLeft;
            
            NSInteger num = [[dic objectForKey:@"gender"] integerValue];
            NSNumber * num1 = [NSNumber numberWithInteger:num];
            NSString * sexual_orientation = [BasicInformation getGender:num1];
            label4.text = sexual_orientation;
            [cell.contentView addSubview:label4];
        }
        
    }
    return cell;
    
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
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UploadDataRequest cancel];
    [xiehouRequest cancel];
    [GetPicturesRequest cancel];
    [UploadDataRequest setDelegate:nil];
    [xiehouRequest setDelegate:nil];
    [GetPicturesRequest setDelegate:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
