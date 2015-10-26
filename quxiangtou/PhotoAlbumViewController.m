//
//  PhotoAlbumViewController.m
//  quxiangtou
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "PhotoAlbumViewController.h"
#import "MyAlbumTableViewCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "DPPhotoGroupViewController.h"
@interface PhotoAlbumViewController ()<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,DPPhotoGroupViewControllerDelegate>
{
    UIImage * originImage;
    UIImageView * AvatarImageView;
    UIImagePickerController * addPickerImage;
    NSURLConnection * conn;
    NSMutableData * postData;
    UITableView * tabelView;
    NSArray * _dataSource;
    
    ASIFormDataRequest * GetPicturesRequest;
}


@end

@implementation PhotoAlbumViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imageArray = [[NSMutableArray alloc]init];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (_page == 0) {
    }else{
        [self getMorePhotos:_page];
    }
    
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (Screen_width - 130) / 3 + 20;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_pageName isEqualToString:@"mycenter"]) {
        return _imageArray.count + 1;
    }else{
        return _imageArray.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAlbumTableViewCell * cell = [tabelView dequeueReusableCellWithIdentifier:@"myAlbum"];
    if (!cell) {
        cell = [[MyAlbumTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myAlbum"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([_pageName isEqualToString:@"mycenter"]) {
        if (indexPath.row == 0) {
            cell.dayLabel.hidden = YES;
            cell.monthLabel.hidden = YES;
            cell.todayLabel.hidden = NO;
            cell.imageView2.hidden = YES;
            cell.imageView3.hidden = YES;
            cell.imageView1.backgroundColor = color_alpha(94, 112, 128, 1);
            
            UIImageView * CameraImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (cell.imageView1.frame.size.height - (cell.imageView1.frame.size.width - 20) * 80 / 118) / 2, cell.imageView1.frame.size.width - 20, (cell.imageView1.frame.size.width - 20) * 80 / 118)];
            CameraImageView.image = [UIImage imageNamed:@"相机003@2x.png"];
            CameraImageView.userInteractionEnabled = YES;
            
            [cell.imageView1 addSubview:CameraImageView];
            
        }else{
            cell.dayLabel.hidden = NO;
            cell.monthLabel.hidden = NO;
            cell.todayLabel.hidden = YES;
            NSDictionary * dic = [_imageArray objectAtIndex:(indexPath.row - 1)];
            NSString * dateString = [dic objectForKey:@"the_date"];
            NSArray *array = [dateString componentsSeparatedByString:@"-"];
            cell.monthLabel.text = [array objectAtIndex:1];
            cell.dayLabel.text = [array objectAtIndex:2];
            NSArray * imageArray = [dic objectForKey:@"images"];
            if (imageArray.count == 1) {
                cell.imageView2.hidden = YES;
                cell.imageView3.hidden = YES;
                cell.imageView1.hidden = NO;
                [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
            }else if (imageArray.count == 2){
                cell.imageView2.hidden = NO;
                cell.imageView3.hidden = YES;
                cell.imageView1.hidden = NO;
                [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
                [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
                
            }else if(imageArray.count >= 3){
                cell.imageView2.hidden = NO;
                cell.imageView3.hidden = NO;
                cell.imageView1.hidden = NO;
                [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
                [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
                [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
            }
            
        }
        
    }else{
        cell.dayLabel.hidden = NO;
        cell.monthLabel.hidden = NO;
        cell.todayLabel.hidden = YES;
        NSDictionary * dic = [_imageArray objectAtIndex:indexPath.row ];
        NSString * dateString = [dic objectForKey:@"the_date"];
        NSArray *array = [dateString componentsSeparatedByString:@"-"];
        cell.monthLabel.text = [array objectAtIndex:1];
        cell.dayLabel.text = [array objectAtIndex:2];
        NSArray * imageArray = [dic objectForKey:@"images"];
        if (imageArray.count == 1) {
            cell.imageView2.hidden = YES;
            cell.imageView3.hidden = YES;
            cell.imageView1.hidden = NO;
            [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        }else if (imageArray.count == 2){
            cell.imageView2.hidden = NO;
            cell.imageView3.hidden = YES;
            cell.imageView1.hidden = NO;
            [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
            [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
            
        }else if(imageArray.count >= 3){
            cell.imageView2.hidden = NO;
            cell.imageView3.hidden = NO;
            cell.imageView1.hidden = NO;
            [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
            [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
            [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
        }
        
        
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_pageName isEqualToString:@"mycenter"]) {
        if (indexPath.row == 0) {
            [self upPhoto];
        }else{
            NSDictionary * dic = [_imageArray objectAtIndex:(indexPath.row - 1)];
            NSArray * imageArray = [dic objectForKey:@"images"];
            [self largeImage:imageArray];
        }
        
    }else{
        NSDictionary * dic = [_imageArray objectAtIndex:indexPath.row];
        NSArray * imageArray = [dic objectForKey:@"images"];
        [self largeImage:imageArray];
    }
    
}
#pragma mark - 上拉加载
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
        if (_page == 0) {
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
    NSString * urlStr = [NSString stringWithFormat:@"%@images?udid=%@&page=%@&uuid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ],[NSString stringWithFormat:@"%d",page],_uuid];
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
            NSArray * imageArrayList = [dic3 objectForKey:@"list"];
            _page = [[dic3 objectForKey:@"next_page"] intValue];
            for (int i = 0; i < imageArrayList.count; i++) {
                [_imageArray addObject:[imageArrayList objectAtIndex:i ]];
            }
            [tabelView reloadData];
        }else if (statusCode == 400){
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
    originImage=[self image:originImage rotation:originImage.imageOrientation];
    originImage=[self imageWithImageSimple:originImage scaledToSize:CGSizeMake(self.view.frame.size.width,(self.view.frame.size.width*originImage.size.height)/originImage.size.width)];
    
    [self upAvatar:originImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

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

-(void)upAvatar:(UIImage *)headImage
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
            NSLog(@"更新头像 Authorization %@",Authorization);
            
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
    MBProgressHUD *bd=[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:bd];
    bd.tag=123456;
    bd.dimBackground=YES;
    bd.detailsLabelText=@"正在上传头像,请稍候";
    [bd show:YES];
    
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
    //去掉加载框
    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
    [bd removeFromSuperview];
    bd=nil;
    
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
        NSString *string = [NSString stringWithFormat:@"%@images?udid=%@&type=avatar",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid"]];
        NSURL * url = [NSURL URLWithString:string];
        if ([conn.currentRequest.URL isEqual:url]) {
            [AvatarImageView setImage:originImage];
            [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"] objectForKey:@"url"] forKey:@"touxiangurl"];
            [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"] objectForKey:@"md5"] forKey:@"touxiangMD5"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSLog(@"touxiang = %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"touxiangurl"]);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateAvatar" object:dic];
        }else{
            _page = 0;
            [_imageArray removeAllObjects];
            [self getMorePhotos:_page];
        }
        
        MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"温馨提示";
        HUD.detailsLabelText = @"上传照片成功";
        HUD.mode = MBProgressHUDModeText;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1.0);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
    }
}

#pragma mark -DPPhotoGroupViewControllerDelegate   调用上传图片
- (void)didSelectPhotos:(NSMutableArray *)photos{
    _dataSource = photos;
    [self upImage:_dataSource];
}

#pragma mark - 选择图片  以安卓的形式

-(void)upPhoto{
    DPPhotoGroupViewController *groupVC = [DPPhotoGroupViewController new];
    groupVC.maxSelectionCount = 9;
    groupVC.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:groupVC] animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 获取图片后上传图片的方法
-(void)upImage:(NSArray *)dataArray
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
            
            for (UIImage * headImage in dataArray) {
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
                
            }
            
        });
    });
    //加载框
    MBProgressHUD *bd=[[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:bd];
    bd.tag=123456;
    bd.dimBackground=YES;
    bd.detailsLabelText=@"正在上传照片,请稍候";
    [bd show:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [GetPicturesRequest setDelegate:nil];
    [GetPicturesRequest cancel];
}
@end
