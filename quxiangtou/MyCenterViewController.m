//
//  MyCenterViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "MyCenterViewController.h"
#import "LoginModel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "DPPhotoGroupViewController.h"
#import "MyPhotoAlbumViewController.h"
#import "MyEditViewController.h"
#import "AboutMeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MyCenterTableViewCell.h"
#import "messageOfMeTableViewCell.h"
#import "badgeTableViewCell.h"

#import "ZLPhoto.h"
#import "UIImageView+WebCache.h"

#import "myProgressView.h"

@interface MyCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,DPPhotoGroupViewControllerDelegate,changeMessageDelegate,EditAboutMeDelegate,CLLocationManagerDelegate,editMessageOfMeOneDelegate,editMessageOfMeTwoDelegate,editMessageOfMeThreeDelegate,cancleRequestDelegate>
{
    UITableView * listTable;
    NSDictionary * dic;
    NSString * nickName;
    NSString * ageString;
    UIImagePickerController * addPickerImage;
    NSURLConnection * conn;
    NSMutableData * postData;
    UIImage *originImage;
    int page;
    NSMutableArray * imageArr;
    NSMutableArray * scrollArray;
    NSArray * _dataSource;
    NSArray * titleArray;
    NSTimer * timer;
    
    NSString * genderString;
    NSString * sexual_frequencyString;
    NSString * sexual_durationString;
    NSString * sexual_orientationString;
    NSString * sexual_positionString;
    NSString * purposeString;
    NSString * addressString;
    
    NSNumber * sexual_durationNumber;
    NSNumber * sexual_orientationNumber;
    NSNumber * sexual_positionNumber;
    NSNumber * genderNumber;
    NSNumber * purposeNumber;
    NSNumber * sexual_frequencyNumber;
    
    UILabel * addressLabel;
    
    int number;
    
BOOL isUpdate;
    
    NSArray * basicArray;
    NSArray * PrivacyArray;
    //保存每组的展开还是关闭的状态
    NSMutableArray * statusArray;
}
@property (nonatomic, strong) UIScrollView *showScroll;
@property (nonatomic, strong) CLLocationManager * locMgr;
@property (nonatomic, strong) CLGeocoder * geocoder;  //iOS 5.0 及5.0以上SDK版本使用
@property (nonatomic, strong) CLLocation * meCoordinate;

@property (nonatomic , strong) NSMutableArray *assets;

@property (strong,nonatomic) ZLCameraViewController *cameraVc;

@end

@implementation MyCenterViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        scrollArray = [[NSMutableArray alloc]init];
        dic = [[NSDictionary alloc]init];
       //[self requestUserMessage];
    }
    return self;
}
-(CLLocationManager *)locMgr
{
    if (_locMgr == nil) {
        //1、创建位置管理器（定位用户的位置）
        self.locMgr = [[CLLocationManager alloc]init];
        //2、设置代理
        self.locMgr.delegate = self;
    }
    return _locMgr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;
//    [self createNav];
    self.view.backgroundColor = [UIColor whiteColor];
    statusArray = [[NSMutableArray alloc]init];
    [statusArray addObject:@"YES"];
    [statusArray addObject:@"NO"];
    isUpdate = NO;
    basicArray = @[@"位置",@"徽章",@"关于我",@"恋爱状态",@"性取向",@"外貌",@"居住情况",@"收入",@"健康",@"喝酒情况",@"运动",@"性能力",@"性格"];
    titleArray = @[@"性爱频率",@"性爱时长",@"性取向",@"体位"];
    self.view.backgroundColor = [UIColor whiteColor];
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
    self.navigationItem.title = @"个人中心";

    
}

-(void)viewWillAppear:(BOOL)animated
{
    page = 0;
    [self requestUserMessage];
    [listTable reloadData];
 
}
-(void)showLeft
{
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
    [dd showLeftController:YES];
}

-(void)giveGender:(NSNumber *)gender Gexual_frequencyString:(NSNumber *)sexual_frequencyNumber Sexual_durationString:(NSNumber *)sexual_durationNumber Sexual_orientationString:(NSNumber *)sexual_orientationNumber Sexual_positionString:(NSNumber *)sexual_positionNumber
{
    genderString = [BasicInformation getGender:gender];
    sexual_durationString = [BasicInformation getSexual_duration:sexual_durationNumber];
    sexual_frequencyString = [NSString stringWithFormat:@"一周%@次",sexual_frequencyNumber];
    sexual_orientationString = [BasicInformation getSexual_orientation:sexual_orientationNumber];
    sexual_positionString = [BasicInformation getSexual_position:sexual_positionNumber];
    [listTable reloadData];
}
-(void)changePurpose:(NSNumber *)purposeNumber
{
    purposeString = [BasicInformation getPurpose:purposeNumber];
}
-(void)createUI
{
    listTable=[[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,Screen_height - 64) style:UITableViewStyleGrouped];
    listTable.tableHeaderView = _showScroll;
    listTable.delegate=self;
    listTable.dataSource=self;
    listTable.showsHorizontalScrollIndicator = NO;
    listTable.showsVerticalScrollIndicator = NO;
    listTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:listTable];
    
}
#pragma mark - 显示登录返回的图片
//显示所有图片
-(void)loadAllImage{
    //移除滚动条视图
    if([self.view viewWithTag:3000]){
        [[self.view viewWithTag:3000] removeFromSuperview];
    }
    _showScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, Screen_width,Screen_width-14)];
    _showScroll.showsHorizontalScrollIndicator=NO;
    _showScroll.showsVerticalScrollIndicator=NO;
    _showScroll.scrollEnabled = NO;
    _showScroll.tag=3000;
//    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:scrollArray];
    //显示表视图
    if(scrollArray.count>7){
        [scrollArray removeObjectsInRange:NSMakeRange(7, scrollArray.count-7)];
    }
//    [self.view addSubview:_showScroll];
    int L=scrollArray.count%3;
    if(L>0){
        L=1;
    }
    int index=0;
    int decideR=0;
    int decideL=0;
    float width = (Screen_width - 6)/ 3 ;
    //循环扫描表视图对象..
    for(int i=0;i<3;i++){    //一共多少行..
        for(int j=0;j<3;j++){   //每行三个对象..
            //头像图片...
            UIImageView *photoIg=[[UIImageView alloc]initWithFrame:CGRectMake(5 +width*j,6+width*i, width - 3, width - 6)];
            photoIg.tag=index;
            photoIg.backgroundColor = color(94, 112, 128);
            __weak UIImageView *photoA=photoIg;
            photoA.userInteractionEnabled=YES;
            if (i == 0 && j == 0) {
                UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 57, 57 * 80 / 118)];
                imageView1.image = [UIImage imageNamed:@"相机003@2x.png"];
                imageView1.userInteractionEnabled = YES;
                [photoIg addSubview:imageView1];
                
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView1.frame.origin.y + imageView1.frame.size.height + 10, photoIg.frame.size.width, 30)];
                label.text = @"添加照片";
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [photoIg addSubview:label];
                //给我的相册相片添加手势..
                UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upPhoto:)];
                [photoIg addGestureRecognizer:tapView];
            }else if (i == 2 && j == 2){
                UILabel * label2 = [[UILabel alloc]init];
                label2.frame = CGRectMake(0, photoIg.frame.size.height / 2 - 15, photoIg.frame.size.width, 30);
                label2.textAlignment = NSTextAlignmentCenter;
                label2.text = @"更多照片";
                label2.textColor = [UIColor whiteColor];
                [photoA addSubview:label2];
                //给我的相册相片添加手势..
                UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(morePhoto:)];
                [photoIg addGestureRecognizer:tapView];
                
            }else{
                if (scrollArray.count > 0) {
                    if ((3 * i + j - 1) < scrollArray.count) {
                        [photoA sd_setImageWithURL:[NSURL URLWithString:[scrollArray objectAtIndex:(3 * i + j - 1)] ] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
                        //给我的相册相片添加手势..
                        UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(largeImage:)];
                        [photoIg addGestureRecognizer:tapView];
                    }
                   

                }
                
            }
            
            [_showScroll addSubview:photoA];
            if(decideR>2){
                decideR=0;
                decideL=decideL+1;
            }
            //滚动条的contentSize重新设置一下...
            _showScroll.contentSize=CGSizeMake(self.view.frame.size.width-14, photoIg.frame.origin.y+photoIg.frame.size.height+20);
            
            index=index+1;
        }
    }
//    [scrollArray removeAllObjects];
}

//#pragma mark -DPPhotoGroupViewControllerDelegate   调用上传图片
//- (void)didSelectPhotos:(NSMutableArray *)photos{
//    _dataSource = photos;
//    UIImage * image = [_dataSource objectAtIndex:0];
//    number = 1;
//    [self upImage:image];
//}

#pragma mark - 选择图片  以安卓的形式

-(void)upPhoto:(UITapGestureRecognizer *)tap{
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"打开照相机",@"从手机相册获取",nil];
    myActionSheet.tag = 59;
    [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];

}
#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self openCamera];
            break;
        case 1:  //打开本地相册
            [self openLocalPhoto];
            break;
    }
}
- (void)openCamera{
    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVc.maxCount = 6;
//    __weak typeof(self) weakSelf = self;
    /*
     _dataSource = photos;
     UIImage * image = [_dataSource objectAtIndex:0];
     number = 1;
     [self upImage:image];

     */
    cameraVc.callback = ^(NSArray *cameras){
        NSLog(@"照相机 = %d",cameras.count);
        NSMutableArray * arr1 = [[NSMutableArray alloc]init];
        for (ZLPhotoAssets *asset in cameras) {
            if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                [arr1 addObject:[asset aspectRatioImage]];
            }else if([asset isKindOfClass:[UIImage class]]){
                [arr1 addObject:(UIImage *)asset];
            }else if ([asset isKindOfClass:[ZLCamera class]]){
                [arr1 addObject:[asset thumbImage]];
            }

        }
        _dataSource = arr1;
        myProgressView *vi = [[myProgressView alloc]init];
        vi.delegate = self;
        [vi show];
        UIImage * image = [_dataSource objectAtIndex:0];
        number = 1;
        [self upImage:image];
    };
    [cameraVc showPickerVc:self];
}

- (void)openLocalPhoto{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 最多能选9张图片
    if (self.assets.count > 9) {
        pickerVc.maxCount = 0;
    }else{
        pickerVc.maxCount = 9 - self.assets.count;
    }
    pickerVc.status = PickerViewShowStatusCameraRoll;
    [pickerVc showPickerVc:self];
    
//    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        NSMutableArray * arr1 = [[NSMutableArray alloc]init];
        for (ZLPhotoAssets *asset in assets) {
            if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                [arr1 addObject:[asset aspectRatioImage]];
            }else if([asset isKindOfClass:[UIImage class]]){
                [arr1 addObject:(UIImage *)asset];
            }else if ([asset isKindOfClass:[ZLCamera class]]){
                [arr1 addObject:[asset thumbImage]];
            }
            
        }
        myProgressView *vi = [[myProgressView alloc]init];
        vi.delegate = self;
        [vi show];
        _dataSource = arr1;
        UIImage * image = [_dataSource objectAtIndex:0];
        number = 1;
        [self upImage:image];
        
    };
}
- (void)cancleRequest
{
    [conn cancel];
}
#pragma  mark - 放大图片
//点击放大图片..
-(void)largeImage:(UITapGestureRecognizer *)tap{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)tap;
//    NSLog(@"%d",[singleTap view].tag]);
    NSInteger index = [singleTap view].tag;
    // 创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 设置图片浏览器需要显示的所有图片
    int count = scrollArray.count;
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *array1 = [NSMutableArray array];
    for (int i = 0 ; i < self.showScroll.subviews.count; i++) {
        UIImageView *iamgeView = self.showScroll.subviews[i];
            [array addObject:iamgeView];

    }
    for (int i = 0; i < count; i ++) {
        // 创建MJPhoto
        MJPhoto *photo = [[MJPhoto alloc] init];
        // 根据IWPhoto的图片地址设置MJPhoto的url
        photo.url = [NSURL URLWithString:scrollArray[i]];
        // 设置来源
        photo.srcImageView = array[i];
        // 将MJPhoto添加到数组中
        [array1 addObject:photo];
    }
    browser.photos = array1;
    
    // 告诉图片浏览器当前显示哪张图片
    browser.currentPhotoIndex = index - 1;
    // 显示图片浏览器
    [browser show];
    
}


#pragma mark - 更多图片按钮的响应方法
-(void)morePhoto:(UITapGestureRecognizer *)tap{
    [self getPhoto];
}
#pragma mark - 更多图片响应方法的实现
-(void)getPhoto
{
    NSString * urlStr = [NSString stringWithFormat:@"%@images?udid=%@&page=%@&uuid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ],[NSString stringWithFormat:@"%d",0],[[ACommenData sharedInstance].logDic objectForKey:@"uuid"]];
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
#pragma mark - 获取用户信息
-(void)requestUserMessage
{
    NSString * urlStr = [NSString stringWithFormat:@"%@users/%@?udid=%@",URL_HOST,[[ACommenData sharedInstance].logDic objectForKey:@"uuid" ],[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
    NSLog(@"个人中心 获取用户信息 = %@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    getUserMessageRequest = [[ASIFormDataRequest alloc]initWithURL:url];
    [getUserMessageRequest setRequestMethod:@"GET"];
    
    //1、header
    [getUserMessageRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    
    //2、header
    NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
    NSLog(@"Authorization%@",Authorization);
    [getUserMessageRequest addRequestHeader:@"Authorization" value:Authorization];
    
    [getUserMessageRequest setDelegate:self];
    getUserMessageRequest.tag = 106;
    [getUserMessageRequest startAsynchronous];

}
#pragma mark - 更多图片响应请求的请求成功回调
//获取相册
- (void)requestFinished:(ASIHTTPRequest *)request {
    //http://api.quxiangtou.com/v1/users/meet
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic4=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSDictionary * dic3 = [dic4 objectForKey:@"data"];
    NSLog(@"我的中心 获取图片列表 responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    //我的中心 获取图片列表 statusCode 204
    NSLog(@"我的中心 获取图片列表 statusCode %d",statusCode);
    //获取用户更多照片
    if (request.tag == 105) {
        if (statusCode == 200 ) {
            [imageArr removeAllObjects];
            
            imageArr = [dic3 objectForKey:@"list"];
            page = [[dic3 objectForKey:@"next_page"] intValue];
          
            NSLog(@"LIST %@",[dic3 objectForKey:@"list"]);
            MyPhotoAlbumViewController * mpa = [[MyPhotoAlbumViewController alloc]init];

            mpa.imageArray = imageArr;
            mpa.page = page;
            mpa.pageName = @"mycenter";
            mpa.avatarString = [dic objectForKey:@"avatar"];
            mpa.nickName = [[ACommenData sharedInstance].logDic objectForKey:@"nickname"];
            [self.navigationController pushViewController:mpa animated:YES];
        }else if (statusCode == 400){
            NSLog(@"获取相册 error %@",[[dic3 valueForKey:@"errors"] valueForKey:@"code"]);
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                             message:[[dic3 valueForKey:@"errors"] valueForKey:@"code"]
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];

        }

    }
    //获取用户信息
    if (request.tag == 106) {
        if (statusCode == 200 ) {
            dic = dic3;
            //NSMutableArray * imageArr = [[NSMutableArray alloc]init];
            NSArray * array = [dic3 objectForKey:@"recent_images"];
            [scrollArray removeAllObjects];
            for (int i = 0;i < array.count;i++) {
               NSLog(@"我的中心 获取用户信息 url = %@",[[array objectAtIndex:i] objectForKey:@"url"]);
                [scrollArray addObject:[[array objectAtIndex:i] objectForKey:@"url"]];
            }
            NSLog(@"我的中心 获取用户信息 scrollArray = %@",scrollArray);
            NSLog(@"我的中心 获取用户信息 dic = %@",dic);
            [self loadAllImage];
            [self createUI];
            
        }else{
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                             message:[[dic3 valueForKey:@"errors"] valueForKey:@"code"]
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
            
        }

    }
  

}
-(void)requestFailed:(ASIHTTPRequest *)request
{
//    //去掉加载框
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

#pragma mark - 显示个人的信息
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
        return 4;
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
   
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tag = section+100;
    if (section == 0) {
        [button setTitle:@"基本资料" forState:UIControlStateNormal];
    }
    if (section == 1) {
        [button setTitle:@"隐私资料" forState:UIControlStateNormal];
    }
    button.frame = CGRectMake(10, 7, 100, 30);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    [view addSubview:button];

    return view;
}
#pragma mark - button点击事件处理
-(void)buttonClick:(UIButton *)button {
    NSInteger index = button.tag - 100;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 5) {
        [listTable registerNib:[UINib nibWithNibName:@"messageOfMeTableViewCell" bundle:nil] forCellReuseIdentifier:@"messageOfMeTableViewCell4"];
        messageOfMeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"messageOfMeTableViewCell4"];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tagLabel.text = @"外貌";
        cell.heightLabel.text = @"170cm";
        cell.weightLabel.text = @"60公斤";
        cell.shapeLabel.text = @"标准";
        cell.skinLabel.text = @"超白净";
        cell.titleLabel5.hidden = YES;
        cell.timeLabel.hidden = YES;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 6)
    {
        [listTable registerNib:[UINib nibWithNibName:@"messageOfMeTableViewCell" bundle:nil] forCellReuseIdentifier:@"messageOfMeTableViewCell5"];
        messageOfMeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"messageOfMeTableViewCell5"];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 1)
    {
        [listTable registerNib:[UINib nibWithNibName:@"badgeTableViewCell" bundle:nil] forCellReuseIdentifier:@"badgeTableViewCell"];
        badgeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"badgeTableViewCell"];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tagLabel.text = @"徽章";
        cell.tag1.text = @"性能力强";
        cell.tag2.text = @"颜值高";
        cell.tag3.text = @"多金";
        [cell.tag4Button setTitle:@"......" forState:UIControlStateNormal];
        
        
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 4)
    {
        [listTable registerNib:[UINib nibWithNibName:@"messageOfMeTableViewCell" bundle:nil] forCellReuseIdentifier:@"messageOfMeTableViewCell6"];
        messageOfMeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"messageOfMeTableViewCell6"];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //性别
        NSInteger num = [[dic objectForKey:@"gender"] integerValue];
        genderNumber = [NSNumber numberWithInteger:num];
        genderString = [BasicInformation getGender:genderNumber];
        //体位
        NSInteger num5 = [[dic objectForKey:@"sexual_position"] integerValue];
        sexual_positionNumber = [NSNumber numberWithInteger:num5];
        sexual_positionString = [BasicInformation getSexual_position:sexual_positionNumber];
        //性取向
        NSInteger num6 = [[dic objectForKey:@"sexual_orientation"] integerValue];
        sexual_orientationNumber = [NSNumber numberWithInteger:num6];
        sexual_orientationString = [BasicInformation getSexual_orientation:sexual_orientationNumber];
        //性爱频率
        NSInteger num8 = [[dic objectForKey:@"sexual_frequency"] integerValue];
        sexual_frequencyNumber = [NSNumber numberWithInteger:num8];
        sexual_frequencyString = [NSString stringWithFormat:@"一周%@次",sexual_frequencyNumber];
        //性爱时长
        NSInteger num7 = [[dic objectForKey:@"sexual_duration"] integerValue];
        sexual_durationNumber = [NSNumber numberWithInteger:num7];
        sexual_durationString = [BasicInformation getSexual_duration:sexual_durationNumber];
        
        cell.tagLabel.text = @"性取向";
        cell.titleLabel1.text = @"性别:";
        cell.titleLabel5.text = @"体位:";
        cell.titleLabel3.text = @"性取向:";
        cell.titleLabel4.text = @"性爱频率:";
        cell.titleLabel5.text = @"性爱时长:";
        cell.heightLabel.text = genderString;
        cell.weightLabel.text = sexual_positionString;
        cell.shapeLabel.text = sexual_orientationString;
        cell.skinLabel.text = sexual_frequencyString;
        cell.timeLabel.text = sexual_durationString;
        
        
        return cell;
    }else if (indexPath.section == 0) {
        [listTable registerNib:[UINib nibWithNibName:@"MyCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCenterTableViewCell1"];
        MyCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyCenterTableViewCell1"];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            if ([[dic objectForKey:@"province"] isNotEmpty] && [[dic objectForKey:@"city"] isNotEmpty]) {
                addressString = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"province"],[dic objectForKey:@"city"]];
            }else if ([[dic objectForKey:@"province"] isNotEmpty]){
                addressString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"province"]];
            }else if([[dic objectForKey:@"city"] isNotEmpty]){
                addressString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"city"]];
            }else if(isUpdate == NO){
                addressString = [NSString stringWithFormat:@"%@",@"未填写"];
            }
            cell.tagLabel.text = @"位置";
            cell.contentLabel.text = [NSString stringWithFormat:@"城市:%@;当前位于%@",addressString,[[NSUserDefaults standardUserDefaults] objectForKey:@"MyAddress"]];
        }
        if (indexPath.row == 2) {
            NSInteger num = [[dic objectForKey:@"purpose"] integerValue];
            purposeNumber = [NSNumber numberWithInteger:num];
            NSString * purpose = [BasicInformation getPurpose:purposeNumber];
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
        return cell;
    }
    [listTable registerNib:[UINib nibWithNibName:@"MyCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCenterTableViewCell2"];
    MyCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyCenterTableViewCell2"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    return cell;


    
}
-(void)editMessageOfMeOne:(UITableViewCell *)cell
{
   NSIndexPath *indexPath = [listTable indexPathForCell:cell];
    if (indexPath.section == 0 && indexPath.row == 4) {
        MyEditViewController * me = [[MyEditViewController alloc]init];
        me.genderNumber = genderNumber;
        me.sexual_durationNumber = sexual_durationNumber;
        me.sexual_frequencyNumber = sexual_frequencyNumber;
        me.sexual_orientationNumber = sexual_orientationNumber;
        me.sexual_positionNumber = sexual_positionNumber;
        me.delegate = self;
        [self.navigationController pushViewController:me animated:YES];
    }
}
-(void)editMessageOfMeTwo:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [listTable indexPathForCell:cell];
    if (indexPath.section == 0 && indexPath.row == 4) {
        AboutMeViewController * avc = [[AboutMeViewController alloc]init];
        avc.purposeNumber = purposeNumber;
        avc.delegate = self;
        [self.navigationController pushViewController:avc animated:YES];
    }
}
-(void)editMessageOfMeThree:(UITableViewCell *)cell
{
    
}
-(void)editClick
{
    
}
-(void)EditAboutMe
{
    AboutMeViewController * avc = [[AboutMeViewController alloc]init];
    avc.purposeNumber = purposeNumber;
    avc.delegate = self;
    [self.navigationController pushViewController:avc animated:YES];
}
#pragma mark - 调整图片的大小
-(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            break;
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

#pragma mark - 获取图片后上传图片的方法
-(void)upImage:(UIImage *)headImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *string = [NSString stringWithFormat:@"%@images?udid=%@&type=gallery",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid"]];
        NSLog(@"string = %@",string);
        
        //网络连接
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:string]
                                                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                    timeoutInterval:10.0f];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            NSString * Disposition = [NSString stringWithFormat:@"attachment; filename=\"%@\"/",@"headImage.png"];
            NSLog(@"Disposition = %@",Disposition);
            [request setValue:Disposition forHTTPHeaderField:@"Content-Disposition"];
            NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
            NSLog(@"Authorization = %@",Authorization);
            [request setValue:Authorization forHTTPHeaderField:@"Authorization"];
            [request setHTTPMethod:@"POST"];
            
//            for (UIImage * headImage in dataArray) {
                originImage = headImage;
                originImage=[self image:originImage rotation:originImage.imageOrientation];
                originImage=[self imageWithImageSimple:originImage scaledToSize:CGSizeMake(self.view.frame.size.width,(self.view.frame.size.width*originImage.size.height)/originImage.size.width)];
                //创建可变的二进制数据..
                NSMutableData *myRequestData=[NSMutableData data];
                NSData * imgData = UIImageJPEGRepresentation(originImage, 1.0);
                [myRequestData appendData:imgData];
                [request setHTTPBody:myRequestData];
                conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                [conn start];
        });
    });
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
    
    NSString *responseString=[[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    NSDictionary *dic2=[[NSDictionary alloc]initWithDictionary:[responseString JSONValue]];
   
    
    if([[[dic2 valueForKey:@"errors"] objectForKey:@"code"] isNotEmpty]){
         NSLog(@"添加照片 error dic = %@",[[dic2 valueForKey:@"errors"] objectForKey:@"code"]);
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                         message:[[dic2 valueForKey:@"errors"] valueForKey:@"code"]
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
        
    }else{
        NSDictionary * numDic = @{@"num":[NSString stringWithFormat:@"%d",number],@"totalNumber":[NSString stringWithFormat:@"%d",_dataSource.count]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNumber" object:numDic];
        if (number >= _dataSource.count) {
            [self requestUserMessage];
        }else{
            UIImage * img = [_dataSource objectAtIndex:number];
            number = number + 1;
            [self upImage:img];
        }
        
    }

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [GetPicturesRequest setDelegate:nil];
    [getUserMessageRequest setDelegate:nil];
    [update_locationRequest setDelegate:nil];
    [GetPicturesRequest cancel];
    [getUserMessageRequest cancel];
    [update_locationRequest cancel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
