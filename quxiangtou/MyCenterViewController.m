//
//  MyCenterViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "MyCenterViewController.h"
#import "MyMessageTableViewCell.h"
#import "LoginModel.h"
#import "UIImageView+WebCache.h"
#import "MyCenterCollectionViewCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface MyCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
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
    NSArray * imageArr;

}
@property (nonatomic, strong) UIScrollView *showScroll;


@end

@implementation MyCenterViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page = 0;
    imageArr = [[NSArray alloc]initWithObjects:@"美女01.jpg",@"美女01.jpg",@"美女01.jpg",@"美女01.jpg",@"美女01.jpg",@"美女01.jpg",@"美女01.jpg",@"美女01.jpg",@"美女01.jpg", nil];    self.navigationController.navigationBarHidden = YES;
    dic = [ACommenData sharedInstance].logDic;
    NSLog(@"dic = %@",dic);
    nickName = [dic objectForKey:@"nickname"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(90, 90);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    layout.minimumLineSpacing = 0.0;
    
    [self createNavigationBar];
    [self loadAllImage];
    [self createUI];
}
-(void)createNavigationBar
{
    UIView * navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64)];
    navigationView.userInteractionEnabled = YES;
    navigationView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    [self.view addSubview:navigationView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 25, 35, 35);
    [button setBackgroundImage:[UIImage imageNamed:@"顶操01@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:button];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width / 2 -40, 30, 80, 30)];
    titleLabel.text = @"个人中心";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navigationView addSubview:titleLabel];
    
}
-(void)showLeft
{
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
    [dd showLeftController:YES];
}
-(void)createUI
{
    
    listTable=[[UITableView alloc]initWithFrame:CGRectMake(0,_showScroll.frame.size.height+_showScroll.frame.origin.y, self.view.frame.size.width,Screen_height-_showScroll.frame.size.height-_showScroll.frame.origin.y) style:UITableViewStylePlain];
    listTable.delegate=self;
    listTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    listTable.dataSource=self;
    [self.view addSubview:listTable];
    
}
//显示所有图片
-(void)loadAllImage{
    
    //移除滚动条视图
    if([self.view viewWithTag:3000]){
        [[self.view viewWithTag:3000] removeFromSuperview];
    }
    _showScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(7,64, self.view.frame.size.width-14,320)];
    _showScroll.showsHorizontalScrollIndicator=NO;
    _showScroll.showsVerticalScrollIndicator=NO;
    _showScroll.scrollEnabled = NO;
    _showScroll.tag=3000;
    [self.view addSubview:_showScroll];
    int L=imageArr.count%3;
    if(L>0){
        L=1;
    }
    int lineCount=imageArr.count/3+L;  //得到几行的对象
    int index=0;
    int decideR=0;
    int decideL=0;
    //循环扫描表视图对象..
    for(int i=0;i<lineCount;i++){    //一共多少行..
        
        for(int j=0;j<3;j++){   //每行三个对象..
            
            if(index==imageArr.count){
                break;
            }
            decideR=j+1;
            //头像图片...
            UIImageView *photoIg=[[UIImageView alloc]initWithFrame:CGRectMake(3+102*j,6+106*i, 97, 100)];
            photoIg.tag=index;
            __weak UIImageView *photoA=photoIg;
            photoA.userInteractionEnabled=YES;
            if (i == 0 && j == 0) {
                photoIg.backgroundColor = color_alpha(94, 112, 128, 1);
                UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 57, 57 * 80 / 118)];
                imageView1.image = [UIImage imageNamed:@"相机003@2x.png"];
                imageView1.userInteractionEnabled = YES;
                [photoIg addSubview:imageView1];
                
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView1.frame.origin.y + imageView1.frame.size.height + 10, photoIg.frame.size.width, 30)];
                label.backgroundColor = [UIColor cyanColor];
                label.text = @"添加照片";
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [photoIg addSubview:label];
                //给我的相册相片添加手势..
                UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upPhoto:)];
                [photoIg addGestureRecognizer:tapView];
            }else if (i == 2 && j == 2){
                photoIg.backgroundColor = color_alpha(94, 112, 128, 1);
                
                UILabel * label2 = [[UILabel alloc]init];
                //label2.center = photoIg.center;
                label2.frame = CGRectMake(0, photoIg.frame.size.height / 2 - 15, photoIg.frame.size.width, 30);
                label2.textAlignment = NSTextAlignmentCenter;
                label2.text = @"更多照片";
                label2.textColor = [UIColor whiteColor];
                [photoA addSubview:label2];
                //给我的相册相片添加手势..
                UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(morePhoto:)];
                [photoIg addGestureRecognizer:tapView];
                
            }else{
                photoA.image = [UIImage imageNamed:[imageArr objectAtIndex:index]];
                //给我的相册相片添加手势..
                UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(largeImage:)];
                [photoIg addGestureRecognizer:tapView];
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
}
-(void)upPhoto:(UITapGestureRecognizer *)tap{
    [self addPhoto];
}
//点击放大图片..
-(void)largeImage:(UITapGestureRecognizer *)tap{
    // 创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 设置图片浏览器需要显示的所有图片
    int count = imageArr.count;
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *array1 = [NSMutableArray array];
    for (int i = 0 ; i < self.showScroll.subviews.count; i++) {
        UIImageView *iamgeView = self.showScroll.subviews[i];
        if (iamgeView.frame.size.height == 100) {
            [array addObject:iamgeView];
        }
    }
    for (int i = 0; i < count; i ++) {
        // 创建MJPhoto
        MJPhoto *photo = [[MJPhoto alloc] init];
        // NSDictionary *dict = imageArr[i];
        // 根据IWPhoto的图片地址设置MJPhoto的url
        //        photo.url = [NSURL URLWithString:p.thumbnail_pic];
        photo.url = [NSURL URLWithString:imageArr[i]];
        // 设置来源
        photo.srcImageView = array[i];
        // 将MJPhoto添加到数组中
        [array1 addObject:photo];
    }
    browser.photos = array1;
    
    // 告诉图片浏览器当前显示哪张图片
    browser.currentPhotoIndex = tap.view.tag;
    // 显示图片浏览器
    [browser show];
    
}

-(void)morePhoto:(UITapGestureRecognizer *)tap{
    NSString * urlStr = [NSString stringWithFormat:@"%@users/update?udid=%@&page=%@&uuid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid" ],[NSString stringWithFormat:@"%d",page],[[ACommenData sharedInstance].logDic objectForKey:@"uuid"]];
    NSLog(@"我的中心 urlStr = %@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    GetPicturesRequest = [[ASIFormDataRequest alloc]initWithURL:url];
    [GetPicturesRequest setRequestMethod:@"POST"];
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
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic3=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSLog(@"我的中心 获取图片列表 responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    //我的中心 获取图片列表 statusCode 204
    NSLog(@"我的中心 获取图片列表 statusCode %d",statusCode);
    if (statusCode == 200 ) {
        imageArr = [dic3 objectForKey:@"images"];
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"xiehou"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyMessageTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //当前位置
    if (indexPath.row == 0) {
//        cell.topicImageView.image = [UIImage imageNamed:@"定位@2x.png"];
//        cell.topicLabel.text = @"当前位置";
//        NSString * address = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"province"],[dic objectForKey:@"city"]];
//        cell.detailTextLabel.text = address;
        
        cell.TitleImage.image = [UIImage imageNamed:@"定位@2x.png"];
        cell.TitleLabel.text = @"当前位置";
        cell.AuthorityLabel.text = @"当前位置";

    }
    //生日
    if (indexPath.row == 1) {
//        cell.topicImageView.image = [UIImage imageNamed:@"爱好@2x.png"];
//        cell.topicLabel.text = @"生日";
//        cell.contenceLabel.text = [dic objectForKey:@"birthday"];
        
        cell.TitleImage.image = [UIImage imageNamed:@"爱好@2x.png"];
        cell.TitleLabel.text = @"生日";
        cell.AuthorityLabel.text = @"生日";

    }
    //性别
    if (indexPath.row == 2) {
        cell.TitleImage.image = [UIImage imageNamed:@"关于我@2x.png"];
        cell.TitleLabel.text = @"性别";
        cell.AuthorityLabel.text = @"性别";

    }
    //手机号
    if (indexPath.row == 3) {
        cell.TitleImage.image = [UIImage imageNamed:@"职业@2x.png"];
        cell.TitleLabel.text = @"手机号";
        cell.AuthorityLabel.text = @"手机号";

    }
    //交友目的
    if (indexPath.row == 4) {
        cell.TitleImage.image = [UIImage imageNamed:@"职业@2x.png"];
        cell.TitleLabel.text = @"交友目的";
        cell.AuthorityLabel.text = @"交友目的";

    }
    //性爱时长
    if (indexPath.row == 5) {
        cell.TitleImage.image = [UIImage imageNamed:@"爱好@2x.png"];
        cell.TitleLabel.text = @"性爱时长";
        cell.AuthorityLabel.text = @"性爱时长";

    }
    //性频率
    if (indexPath.row == 6) {
        cell.TitleImage.image = [UIImage imageNamed:@"关于我@2x.png"];
        cell.TitleLabel.text = @"性频率";
        cell.AuthorityLabel.text = @"性频率";

    }
    //性取向
    if (indexPath.row == 7) {
        cell.TitleImage.image = [UIImage imageNamed:@"职业@2x.png"];
        cell.TitleLabel.text = @"性取向";
        cell.AuthorityLabel.text = @"性取向";

    }
    //体位
    if (indexPath.row == 8) {
        cell.TitleImage.image = [UIImage imageNamed:@"职业@2x.png"];
        cell.TitleLabel.text = @"体位";
        cell.AuthorityLabel.text = @"性取向";

    }
    
    return cell;
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
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
        
        NSString *string = [NSString stringWithFormat:@"%@images?udid=%@&type=gallery",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
        NSLog(@"string = %@",string);
        
        //网络连接
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData * imgData = UIImageJPEGRepresentation(headImage, 1.0);
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:string]
                                                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                    timeoutInterval:10.0f];
            //创建可变的二进制数据..
            NSMutableData *myRequestData=[NSMutableData data];
            [myRequestData appendData:imgData];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            NSString * Disposition = [NSString stringWithFormat:@"attachment; filename=\"%@\"/",@"headImage.png"];
            [request setValue:Disposition forHTTPHeaderField:@"Content-Disposition"];
            NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"]];
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
    NSDictionary *dic2=[[NSDictionary alloc]initWithDictionary:[responseString JSONValue]];
    NSLog(@"添加照片  dic = %@",dic2);
    if([[dic2 valueForKey:@"errors"] isNotEmpty]){
        
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                         message:[[dic2 valueForKey:@"errors"] valueForKey:@"code"]
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        alert.tag=1001;
        [alert show];
        
    }else{
         MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"提示";
        HUD.detailsLabelText = @"添加照片成功";
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
