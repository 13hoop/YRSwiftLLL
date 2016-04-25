//
//  SeekFriendViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "SeekFriendViewController.h"
#import "SeletionConditionViewController.h"
#import "SeekFriendTableViewCell.h"
#import "VisitorDetailViewController.h"

@interface SeekFriendViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSArray * headerArray;
    NSMutableArray * friendArray;
    UITableView * _tableView;
    BOOL isHandsome;
    BOOL isBeauty;
    UILabel * maxAgeLabel;
    NSInteger carType;
    UISlider * slider;
    int maxAge;
    ASIFormDataRequest * seekFriendRequest;
    
}
@property (nonatomic,strong) NSMutableArray * array_01;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) int page;
@property (nonatomic,assign) int count;

@end

@implementation SeekFriendViewController
- (NSArray *) array_01{
    
    if (_array_01 == nil) {
        
        _array_01 = [NSMutableArray arrayWithObjects:@"1",@"1",nil];
    }
    return _array_01;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    _index = 0;
    carType = 0;
    maxAge = 22;
    friendArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = color(239, 239, 244);
    
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(showSeletionPage)];
    self.navigationItem.title = @"找朋友";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _page = 0;
     _count = 0;
    [friendArray removeAllObjects];
    [self seekFriend];
}
-(void)showLeft
{
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
    [dd showLeftController:YES];
}
-(void)showSeletionPage
{
    SeletionConditionViewController * svc = [[SeletionConditionViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}
#pragma mark - 上拉加载
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
        if (_count == 0) {
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"没有更多符合条件的朋友"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            [alert show];
        }else{
            
            [self seekFriend];
        }
        
        
    }
}
-(void)seekFriend
{
    NSString * urlStr = [NSString stringWithFormat:@"%@users/find_friend?udid=%@&longitude=%@&latitude=%@&page=%d",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ],[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],_page];
    NSLog(@"找朋友 = %@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    seekFriendRequest = [[ASIFormDataRequest alloc]initWithURL:url];
    [seekFriendRequest setRequestMethod:@"GET"];
    
    //1、header
    [seekFriendRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    
    //2、header
    NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
    NSLog(@"找朋友 Authorization%@",Authorization);
    [seekFriendRequest addRequestHeader:@"Authorization" value:Authorization];
    [seekFriendRequest setDelegate:self];
    seekFriendRequest.tag = 100;
    [seekFriendRequest startAsynchronous];

}
#pragma mark - 找朋友响应请求的请求成功回调
//找朋友
- (void)requestFinished:(ASIHTTPRequest *)request {
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic4=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSLog(@"找朋友 dic4 data %@",[dic4 objectForKey:@"data"]);
    int statusCode = [request responseStatusCode];
    //我的中心 获取图片列表 statusCode 204
    NSLog(@"找朋友 statusCode %d",statusCode);
    if (request.tag == 100) {
        if (statusCode == 200 ) {
            int nextPage = [[[dic4 objectForKey:@"data"] objectForKey:@"next_page"] intValue];
            _page = nextPage;
            NSArray * array = [[dic4 objectForKey:@"data"]objectForKey:@"list"];
            if (array.count == 0) {
                 [_tableView reloadData];
                _count = 0;
                MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.labelText = @"温馨提示";
                HUD.detailsLabelText =@"没有相应条件的朋友!";
                HUD.mode = MBProgressHUDModeText;
                [HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(2.0);
                } completionBlock:^{
                    [HUD removeFromSuperview];
                }];
                
            }else if (nextPage == 0){
                for (NSDictionary * dic in array) {
                    [friendArray addObject:dic];
                }
                _count = 0;
                [_tableView reloadData];
            }else{
                for (NSDictionary * dic in array) {
                    [friendArray addObject:dic];
                }
                [_tableView reloadData];
            }
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return friendArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SeekFriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SeekFriendTableViewCell"];
    if (!cell) {
        cell = [[SeekFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SeekFriendTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (friendArray.count == 0) {
        return cell;
    }
    if ([[[friendArray objectAtIndex:indexPath.row] objectForKey:@"avatar"] isNotEmpty]) {
        [cell.avatarImageView sd_setImageWithURL:[[friendArray objectAtIndex:indexPath.row] objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
    }else{
        cell.avatarImageView.image =  [UIImage imageNamed:@"加载失败图片@3x.png"];
    }
//    [cell.avatarImageView sd_setImageWithURL:[[friendArray objectAtIndex:indexPath.row] objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
    cell.nickNameLabel.text = [[friendArray objectAtIndex:indexPath.row] objectForKey:@"nickname"];
    if ([[[friendArray objectAtIndex:indexPath.row] objectForKey:@"gender"]intValue] == 0) {
        cell.genderImageView.image = [UIImage imageNamed:@"性别保密@2x.png"];
    }else if([[[friendArray objectAtIndex:indexPath.row] objectForKey:@"gender"]intValue] == 1){
        cell.genderImageView.image = [UIImage imageNamed:@"男生图标@2x.png"];
    }else{
        cell.genderImageView.image = [UIImage imageNamed:@"女生图标@2x.png"];
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VisitorDetailViewController * vdvc = [[VisitorDetailViewController alloc]init];
    vdvc.visitorArray = friendArray;
    vdvc.page = indexPath.row;
    [self.navigationController pushViewController:vdvc animated:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [seekFriendRequest setDelegate:nil];
    [seekFriendRequest cancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
