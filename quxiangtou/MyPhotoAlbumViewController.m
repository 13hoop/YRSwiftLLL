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
@interface MyPhotoAlbumViewController ()<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIImage * originImage;
    UIImageView * imageView2;
    UIImagePickerController * addPickerImage;
    NSURLConnection * conn;
    NSMutableData * postData;
    UITableView * tabelView;
    
}
@end

@implementation MyPhotoAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBar];
    [self createUI];
    tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, imageView2.frame.origin.y + imageView2.frame.size.height + 20, Screen_width, Screen_height - (imageView2.frame.origin.y + imageView2.frame.size.height + 20) - 64) style:UITableViewStylePlain];
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"顶操04@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
    self.navigationItem.title = @"我的相册";
}
-(void)createUI
{
    UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 200)];
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:@"http://img.quxiangtou.com/thumb/q/31/aa/31aac273c21ce2b28f1cc195e192c0a2.png"] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
    [self.view addSubview:imageView1];
    
    imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, imageView1.frame.size.height + imageView1.frame.origin.y - 40, 80, 80)];
    [imageView2 sd_setImageWithURL:[NSURL URLWithString:_avatarString] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
    imageView2.layer.cornerRadius = 40;
    imageView2.layer.masksToBounds = YES;
    [self.view addSubview:imageView2];
    imageView2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAvatar:)];
    [imageView2 addGestureRecognizer:tapView];
    
    UILabel * nickName = [[UILabel alloc]initWithFrame:CGRectMake(imageView2.frame.size.width + imageView2.frame.origin.x + 10, imageView2.frame.origin.y + 50, Screen_width - 150, 30)];
    nickName.text = [[ACommenData sharedInstance].logDic objectForKey:@"nickname"];
    [self.view addSubview:nickName];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (Screen_width - 130) / 3 + 20;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _imageArray.count + 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAlbumTableViewCell * cell = [tabelView dequeueReusableCellWithIdentifier:@"myAlbum"];
    if (!cell) {
        cell = [[MyAlbumTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myAlbum"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        cell.dayLabel.hidden = YES;
        cell.monthLabel.hidden = YES;
        cell.todayLabel.hidden = NO;
        cell.imageView2.hidden = YES;
        cell.imageView3.hidden = YES;
        cell.imageView1.backgroundColor = color_alpha(94, 112, 128, 1);
        UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, (cell.imageView1.frame.size.height - (cell.imageView1.frame.size.width - 20) * 80 / 118) / 2, cell.imageView1.frame.size.width - 20, (cell.imageView1.frame.size.width - 20) * 80 / 118)];
        imageView1.image = [UIImage imageNamed:@"相机003@2x.png"];
        imageView1.userInteractionEnabled = YES;
        [cell.imageView1 addSubview:imageView1];
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
            [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]]];
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
    if (indexPath.row == 0) {
        
    }else{
        NSDictionary * dic = [_imageArray objectAtIndex:(indexPath.row - 1)];
        NSArray * imageArray = [dic objectForKey:@"images"];
        [self largeImage:imageArray];
    }
    
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
#pragma mark - 更多图片按钮的响应方法
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
    
    [self upImage:originImage];
    
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
            //创建可变的二进制数据..
            NSMutableData *myRequestData=[NSMutableData data];
            [myRequestData appendData:imgData];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            NSString * Disposition = [NSString stringWithFormat:@"attachment; filename=\"%@\"/",@"headImage.png"];
            [request setValue:Disposition forHTTPHeaderField:@"Content-Disposition"];
            NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]];
            [request setValue:Authorization forHTTPHeaderField:@"Authorization"];
            
            
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
        [imageView2 setImage:originImage];
    
        [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"] objectForKey:@"url"] forKey:@"touxiangurl"];
        [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"] objectForKey:@"md5"] forKey:@"touxiangMD5"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"touxiang = %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"touxiangurl"]);
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
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
