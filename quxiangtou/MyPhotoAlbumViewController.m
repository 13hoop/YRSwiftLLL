//
//  MyPhotoAlbumViewController.m
//  quxiangtou
//
//  Created by mac on 15/9/7.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "MyPhotoAlbumViewController.h"
#import "MyAlbumTableViewCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ZXCollectionPhotoController.h"

@interface MyPhotoAlbumViewController ()<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIImage * originImage;
    UIImageView * AvatarImageView;
    UIImagePickerController * addPickerImage;
    NSURLConnection * conn;
    NSMutableData * postData;
    UITableView * tabelView;
    NSArray * _dataSource;
    
    ASIFormDataRequest * GetPicturesRequest;
    CGFloat width;
}
@end

@implementation MyPhotoAlbumViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imageArray = [[NSMutableArray alloc]init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateAvatar:) name:@"updateAvatar" object:nil];
        [_imageArray removeAllObjects];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    width = (Screen_width - 130) / 3;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBar];
    [self createUI];
    tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, AvatarImageView.frame.origin.y + AvatarImageView.frame.size.height + 20, Screen_width, Screen_height - (AvatarImageView.frame.origin.y + AvatarImageView.frame.size.height + 20) - 64) style:UITableViewStylePlain];
    tabelView.delegate = self;
    tabelView.dataSource = self;
    tabelView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tabelView];
}
-(void)createNavigationBar
{
    self.navigationController.navigationBar.translucent = NO;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"顶操04@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
    self.navigationItem.title = @"我的相册";
}
-(void)createUI
{
    UIImageView * DefaultImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 200)];
    [DefaultImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img.quxiangtou.com/thumb/q/31/aa/31aac273c21ce2b28f1cc195e192c0a2.png"] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
    [self.view addSubview:DefaultImageView];
    
    _avatarString = [[NSUserDefaults standardUserDefaults]objectForKey:@"touxiangurl"];
    AvatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, DefaultImageView.frame.size.height + DefaultImageView.frame.origin.y - 40, 80, 80)];
    if ([_avatarString isNotEmpty]) {
        [AvatarImageView sd_setImageWithURL:[NSURL URLWithString:_avatarString] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
    }else{
        AvatarImageView.image = [UIImage imageNamed:@"加载失败图片@3x.png"];
    }
    
    AvatarImageView.layer.cornerRadius = 40;
    AvatarImageView.layer.masksToBounds = YES;
    [self.view addSubview:AvatarImageView];
    
    if ([_pageName isEqualToString:@"mycenter"]) {
        AvatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAvatar:)];
        [AvatarImageView addGestureRecognizer:tapView];
    }
    UILabel * nickName = [[UILabel alloc]initWithFrame:CGRectMake(AvatarImageView.frame.size.width + AvatarImageView.frame.origin.x + 10, AvatarImageView.frame.origin.y + 50, Screen_width - 150, 30)];
    nickName.text = _nickName;
    [self.view addSubview:nickName];
}
-(void)updateAvatar:(NSNotification *)note{
    
    NSString * touxiangurl = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"touxiangurl"]];
    [AvatarImageView sd_setImageWithURL:[NSURL URLWithString:touxiangurl] placeholderImage:[UIImage imageNamed:@"组 2@2x"]];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [_imageArray objectAtIndex:indexPath.row ];
    NSArray * imgArray = [dic objectForKey:@"images"];
    if (imgArray.count / 3 == 0) {
        return  width+ 20;
    }else if (imgArray.count / 3 == 1){
        return  width * 2 + 20;
    }else{
        return  width * 3 + 20;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _imageArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAlbumTableViewCell * cell = [[MyAlbumTableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic = [_imageArray objectAtIndex:indexPath.row ];
    NSString * dateString = [dic objectForKey:@"the_date"];
    NSArray *array = [dateString componentsSeparatedByString:@"-"];
    cell.monthLabel.text = [array objectAtIndex:1];
    cell.dayLabel.text = [array objectAtIndex:2];
    
    NSArray * imageArray = [dic objectForKey:@"images"];
    NSLog(@"count = %d dateString = %@",imageArray.count,dateString);
    cell.numberLabel.text = [NSString stringWithFormat:@"共%d张",imageArray.count];
//    cell.imageArray = imageArray;
    if (imageArray.count == 1) {
        cell.imageView1.hidden = NO;
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
    }else if (imageArray.count == 2){
        cell.imageView2.hidden = NO;
        cell.imageView1.hidden = NO;
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        
    }else if(imageArray.count == 3){
        cell.imageView2.hidden = NO;
        cell.imageView3.hidden = NO;
        cell.imageView1.hidden = NO;
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
    } else if(imageArray.count == 4){
        cell.imageView2.hidden = NO;
        cell.imageView3.hidden = NO;
        cell.imageView1.hidden = NO;
        cell.imageView4.hidden = NO;
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView4 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:3]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        
    }else if(imageArray.count == 5){
        cell.imageView2.hidden = NO;
        cell.imageView3.hidden = NO;
        cell.imageView1.hidden = NO;
        cell.imageView4.hidden = NO;
        cell.imageView5.hidden = NO;
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView4 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:3]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView5 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:4]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        
    }else if(imageArray.count == 6){
        cell.imageView2.hidden = NO;
        cell.imageView3.hidden = NO;
        cell.imageView1.hidden = NO;
        cell.imageView4.hidden = NO;
        cell.imageView5.hidden = NO;
        cell.imageView6.hidden = NO;
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView4 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:3]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView5 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:4]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView6 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:5]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        
    }else if(imageArray.count == 7){
        cell.imageView2.hidden = NO;
        cell.imageView3.hidden = NO;
        cell.imageView1.hidden = NO;
        cell.imageView4.hidden = NO;
        cell.imageView5.hidden = NO;
        cell.imageView6.hidden = NO;
        cell.imageView7.hidden = NO;
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView4 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:3]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView5 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:4]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView6 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:5]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView7 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:6]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        
    }else if(imageArray.count == 8){
        cell.imageView2.hidden = NO;
        cell.imageView3.hidden = NO;
        cell.imageView1.hidden = NO;
        cell.imageView4.hidden = NO;
        cell.imageView5.hidden = NO;
       cell.imageView6.hidden = NO;
        cell.imageView7.hidden = NO;
        cell.imageView8.hidden = NO;
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView4 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:3]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView5 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:4]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView6 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:5]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView7 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:6]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView8 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:7]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
    }else if(imageArray.count >= 9){
        cell.imageView2.hidden = NO;
        cell.imageView3.hidden = NO;
        cell.imageView1.hidden = NO;
        cell.imageView4.hidden = NO;
        cell.imageView5.hidden = NO;
        cell.imageView6.hidden = NO;
        cell.imageView7.hidden = NO;
        cell.imageView8.hidden = NO;
        cell.imageView9.hidden = NO;
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView4 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:3]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView5 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:4]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView6 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:5]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView7 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:6]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView8 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:7]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        [cell.imageView9 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:8]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [_imageArray objectAtIndex:indexPath.row];
    NSArray * imageArray = [dic objectForKey:@"images"];
    [self largeImage:imageArray];
   
}
#pragma mark - 上拉加载
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 80) {
        if (_page == 0) {
            [tabelView reloadData];
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"没有更多图片"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
        }else{
            
            [self getMorePhotos:_page];
        }
       
        
    }
}
-(void)getMorePhotos:(int)page
{
    //_page++;
    NSString * urlStr = [NSString stringWithFormat:@"%@images?udid=%@&page=%@&uuid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ],[NSString stringWithFormat:@"%d",page],[[ACommenData sharedInstance].logDic objectForKey:@"uuid"]];
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
#pragma mark - 更多图片响应请求的请求成功回调
//获取相册
- (void)requestFinished:(ASIHTTPRequest *)request {
    //http://api.quxiangtou.com/v1/users/meet
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic4=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSDictionary * dic3 = [dic4 objectForKey:@"data"];
    NSLog(@"我的相册 获取图片列表 responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    //我的中心 获取图片列表 statusCode 204
    NSLog(@"我的相册 获取图片列表 statusCode %d",statusCode);
    if (request.tag == 105) {
        if (statusCode == 200 ) {
            NSLog(@"next_page = %d",[[dic3 objectForKey:@"next_page"] intValue]);
            NSArray * imageArrayList = [dic3 objectForKey:@"list"];
//            _page = [[dic3 objectForKey:@"next_page"] intValue];
            for (int i = 0; i < imageArrayList.count; i++) {
//                [_imageArray removeAllObjects];
                [_imageArray addObject:[imageArrayList objectAtIndex:i ]];
            }
        
            [tabelView reloadData];
            if ([[dic3 objectForKey:@"next_page"] intValue] == 0) {
                _page = 0;
            }else{
                _page = [[dic3 objectForKey:@"next_page"] intValue];
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

#pragma  mark - 放大图片
//点击放大图片..
-(void)largeImage:(NSArray *)scrollArray{
    // 创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 设置图片浏览器需要显示的所有图片
    int count = scrollArray.count;
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *array1 = [NSMutableArray array];
    for (int i = 0 ; i < count; i++) {
        UIImageView *iamgeView = [[UIImageView alloc]init];
        [iamgeView sd_setImageWithURL:[NSURL URLWithString:[scrollArray objectAtIndex:i ]]];
        [array addObject:iamgeView];
    }
    for (int i = 0; i < count; i ++) {
        // 创建MJPhoto
        MJPhoto *photo = [[MJPhoto alloc] init];
        // NSDictionary *dict = scrollArray[i];
        // 根据IWPhoto的图片地址设置MJPhoto的url
        //        photo.url = [NSURL URLWithString:p.thumbnail_pic];
        photo.url = [NSURL URLWithString:scrollArray[i]];
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


-(void)showLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 更新头像的响应方法
-(void)changeAvatar:(UITapGestureRecognizer *)tap{
    ZXCollectionPhotoController * VC = [[ZXCollectionPhotoController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [GetPicturesRequest setDelegate:nil];
    [GetPicturesRequest cancel];
}
@end
