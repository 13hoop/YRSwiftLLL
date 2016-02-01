//
//  DoubleViewController.m
//  quxiangtou
//
//  Created by mac on 15/12/7.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "DoubleViewController.h"
#import "AVOSCloudIM.h"
#import "SeekFriendTableViewCell.h"
#import "SearchViewController.h"
#import "sendDataViewController.h"

@interface DoubleViewController ()<AVIMClientDelegate,ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate>{
    AVIMConversation * mConversation;
    ASIFormDataRequest * searchFirend;
    ASIFormDataRequest * recommendPairFirend;
    int page;
    NSMutableArray * pairedArray;
    UITableView * _tableView;
    UISegmentedControl * sc1;
}

@end

@implementation DoubleViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    sc1.selectedSegmentIndex = 0;//设置为0，表示选中索引为0的段
    page = 0;
    [self seekPairedFriend];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    pairedArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, Screen_width, Screen_height - 64 - 45) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    [self createNav];
   
}
-(void)seekPairedFriend
{
    NSString * urlStr = [NSString stringWithFormat:@"%@pair/history?udid=%@&page=%d",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ],page];
    NSLog(@"配对历史 = %@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    searchFirend = [[ASIFormDataRequest alloc]initWithURL:url];
    [searchFirend setRequestMethod:@"GET"];
    
    //1、header
    [searchFirend addRequestHeader:@"Content-Type" value:@"application/json"];
    
    //2、header
    NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
    NSLog(@"配对历史 Authorization%@",Authorization);
    [searchFirend addRequestHeader:@"Authorization" value:Authorization];
    
    [searchFirend setDelegate:self];
    searchFirend.tag = 100;
    [searchFirend startAsynchronous];
    
}
-(void)RecommendPair
{
    NSString * urlStr = [NSString stringWithFormat:@"%@pair/recommend?udid=%@&page=%d",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ],page];
    NSLog(@"推荐配对 = %@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    recommendPairFirend = [[ASIFormDataRequest alloc]initWithURL:url];
    [recommendPairFirend setRequestMethod:@"GET"];
    
    //1、header
    [recommendPairFirend addRequestHeader:@"Content-Type" value:@"application/json"];
    
    //2、header
    NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
    NSLog(@"推荐配对 Authorization%@",Authorization);
    [recommendPairFirend addRequestHeader:@"Authorization" value:Authorization];
    
    [recommendPairFirend setDelegate:self];
    recommendPairFirend.tag = 101;
    [recommendPairFirend startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSDictionary * header = [NSDictionary dictionaryWithDictionary:[request responseHeaders]];
    NSLog(@"%@",header);
    NSLog(@"配对历史 responseString %@",[dic objectForKey:@"data"]);
    int statusCode = [request responseStatusCode];
    NSLog(@"配对历史 statusCode %d",statusCode);
    if (statusCode == 200 ) {
        
        if ([[header objectForKey:@"X-Total-Count"] intValue] == 0) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"配对历史空空如也!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag=1003;
            [alert show];
            
        }else{
            pairedArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
            NSLog(@"配对历史 array %@",pairedArray);
            page = [[[dic objectForKey:@"data"] objectForKey:@"next_page"] intValue];
            [_tableView reloadData];
//            [self createUI];
        }
        
    }else{
        //提示警告框失败...
        MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"抱歉";
        HUD.detailsLabelText =[dic valueForKey:@"return_content"];
        HUD.mode = MBProgressHUDModeText;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2.0);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pairedArray.count;
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
    if (pairedArray.count == 0) {
        return cell;
    }
    if ([[[pairedArray objectAtIndex:indexPath.row] objectForKey:@"avatar"] isNotEmpty]) {
        [cell.avatarImageView sd_setImageWithURL:[[pairedArray objectAtIndex:indexPath.row] objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
    }else{
        cell.avatarImageView.image =  [UIImage imageNamed:@"加载失败图片@3x.png"];
    }
    cell.nickNameLabel.text = [[pairedArray objectAtIndex:indexPath.row] objectForKey:@"nickname"];
    cell.nickNameLabel.frame = CGRectMake(cell.avatarImageView.frame.size.width + cell.avatarImageView.frame.origin.x + 10, 30, 200, 20);
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sendDataViewController * svc = [[sendDataViewController alloc]init];
    svc.dic = [pairedArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:svc animated:YES];
}
-(void)createNav
{
    UIView * navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64)];
    navigationView.userInteractionEnabled = YES;
    navigationView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    [self.view addSubview:navigationView];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setImage:[[UIImage imageNamed:@"顶操04@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 20, 50, 44);
//    backButton.backgroundColor = [UIColor redColor];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.tag = 104;
    [navigationView addSubview:backButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, Screen_width, 1)];
    titleLabel.backgroundColor = [UIColor grayColor];
    [navigationView addSubview:titleLabel];
    
    UIButton * searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setImage:[[UIImage imageNamed:@"搜索按钮@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    searchButton.frame = CGRectMake(Screen_width - 10- 50, 20, 50, 44);
//    searchButton.backgroundColor = [UIColor redColor];
    [searchButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.tag = 105;
    [navigationView addSubview:searchButton];
    
    //用一个字符串的数组，创建一个分段
    sc1 = [[UISegmentedControl alloc] initWithItems:@[@"配对历史",@"推荐配对"]];
    sc1.center = CGPointMake(Screen_width / 2, 40);
    sc1.tag = 300;
    sc1.selectedSegmentIndex = 0;//设置为0，表示选中索引为0的段
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    sc1.segmentedControlStyle = UISegmentedControlStyleBar;
#endif
    sc1.tintColor = color_alpha(63, 77, 91, 1);
    [sc1 addTarget:self action:@selector(ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [navigationView addSubview:sc1];
    
}
-(void)backClick:(UIButton *)button
{
    if (button.tag == 104) {
        DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
        [dd showLeftController:YES];
    }
    if (button.tag == 105) {
        SearchViewController * sv = [[SearchViewController alloc]init];
        [self.navigationController pushViewController:sv animated:YES];
    }
   
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}
-(void)ValueChanged:(UISegmentedControl *)seg
{
    if (seg.selectedSegmentIndex == 0) {
        page = 0;
        [self seekPairedFriend];
    }
    if (seg.selectedSegmentIndex == 1) {
        page = 0;
        [self RecommendPair];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [searchFirend cancel];
    searchFirend = nil;
    [recommendPairFirend cancel];
    recommendPairFirend = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}
@end
