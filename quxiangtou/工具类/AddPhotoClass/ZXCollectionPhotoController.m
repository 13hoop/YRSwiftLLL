//
//  ZXCollectionPhotoController.m
//  ImageViewTest
//
//  Created by ching on 15/12/25.
//  Copyright © 2015年 杭州中新力合-程朋. All rights reserved.
//
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define StatusBarHeight (IOS7==YES ? 0 : 20)
#define BackHeight      (IOS7==YES ? 0 : 15)
#define fNavBarHeigth (IOS7==YES ? 64 : 44)
#define fDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define fDeviceHeight ([UIScreen mainScreen].bounds.size.height)

#import "ZXCollectionPhotoController.h"
#import "ZXCollectionCell.h"
@interface ZXCollectionPhotoController ()<ZXCollectionCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
    ASIFormDataRequest * GetPicturesRequest;
    ASIFormDataRequest * changeAvatarRequest;
    int _page;
    NSInteger number;
}
@property(nonatomic,strong)NSMutableArray * imageArr;

@end

@implementation ZXCollectionPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    _imageArr = [[NSMutableArray alloc]init];
    [self getMorePhotos:_page];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"主页面";

    [self drawUI];
}

-(void)drawUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//不能放init处
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"顶操04@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
    self.navigationItem.title = @"上传头像";
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, fDeviceHeight) collectionViewLayout:flowLayout];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //注册cell和ReusableView（相当于头部）
    [self.collectionView registerClass:[ZXCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    
}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArr.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    ZXCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    [cell.imgView  sd_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
   
    cell.delegate = self;
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((fDeviceWidth-20)/3, (fDeviceWidth-20)/3);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 5, 5);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    number = indexPath.row;
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否要将此照片设为头像" delegate:self cancelButtonTitle:@"再看看"otherButtonTitles:@"设为头像", nil ];
    alert.tag = 100;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:[_imageArr objectAtIndex:number],@"img_url", nil];
            if ([NSJSONSerialization isValidJSONObject:user]) {
                NSError * error;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
                NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
                NSString * urlStr = [NSString stringWithFormat:@"%@images/avatar?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
                NSURL * url = [NSURL URLWithString:urlStr];
                changeAvatarRequest = [[ASIFormDataRequest alloc]initWithURL:url];
                [changeAvatarRequest setRequestMethod:@"POST"];
                [changeAvatarRequest setDelegate:self];
                
                //1、header
                [changeAvatarRequest addRequestHeader:@"Content-Type" value:@"application/json"];
                
                //2、header
                NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
                NSLog(@"Authorization%@",Authorization);
                [changeAvatarRequest addRequestHeader:@"Authorization" value:Authorization];
                changeAvatarRequest.tag = 101;
                [changeAvatarRequest setPostBody:tempJsonData];
                [changeAvatarRequest startAsynchronous];
            }
            
        }

    }
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)getMorePhotos:(int)page
{
    //_page++;
    NSString * urlStr = [NSString stringWithFormat:@"%@images?udid=%@&page=%@&uuid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ],[NSString stringWithFormat:@"%d",page],[[ACommenData sharedInstance].logDic objectForKey:@"uuid"]];
    NSLog(@"更新头像 urlStr = %@",urlStr);
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
#pragma mark - 更多图片响应请求的请求成功回调
//获取相册
- (void)requestFinished:(ASIHTTPRequest *)request {
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic4=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSDictionary * dic3 = [dic4 objectForKey:@"data"];
    NSLog(@"更新头像 获取图片列表 responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    //我的中心 获取图片列表 statusCode 204
    NSLog(@"更新头像 获取图片列表 statusCode %d",statusCode);
    if (request.tag == 105) {
        if (statusCode == 200 ) {
            NSLog(@"next_page = %d",[[dic3 objectForKey:@"next_page"] intValue]);
            NSArray * imageArrayList = [dic3 objectForKey:@"list"];
            for (int i = 0; i < imageArrayList.count; i++) {
                for (NSString * string in [[imageArrayList objectAtIndex:i] objectForKey:@"images"]) {
                    [_imageArr addObject:string];
                }
                
            }
            
            [self.collectionView reloadData];
            if ([[dic3 objectForKey:@"next_page"] intValue] == 0) {
                MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.labelText = @"温馨提示";
                HUD.detailsLabelText =@"相册已加载完成";
                HUD.mode = MBProgressHUDModeText;
                [HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(2.0);
                } completionBlock:^{
                    [HUD removeFromSuperview];
                }];
            }else{
                _page = [[dic3 objectForKey:@"next_page"] intValue];
                [self getMorePhotos:_page];
            }
            
            
        }else if (statusCode == 400){
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:[[dic3 valueForKey:@"errors"] valueForKey:@"code"]
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
            
        }
        
    }
    if (request.tag == 101) {
        if (statusCode == 201) {
             [[NSUserDefaults standardUserDefaults]setObject:[_imageArr objectAtIndex:number] forKey:@"touxiangurl"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateAvatar" object:nil];
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"温馨提示";
            HUD.detailsLabelText =@"设置头像成功";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
                [HUD removeFromSuperview];
            }];
        }else{
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
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
-(void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
