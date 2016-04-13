//
//  BlackListViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "BlackListViewController.h"
#import "MyMailListViewController.h"

@interface BlackListViewController ()<UITableViewDelegate,UITableViewDataSource, SWTableViewCellDelegate>
{
    UITableView * blacktableView;
    int deleteid;
}
@end

@implementation BlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
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
    
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addButton setImage:[[UIImage imageNamed:@"顶操02@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    addButton.frame = CGRectMake(0, 0, 50, 39);
    [addButton addTarget:self action:@selector(clickAdd) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton_right = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    UIBarButtonItem *addButtonSpacer = [[UIBarButtonItem alloc]
                                       
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       
                                       target:nil action:nil];
    addButtonSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addButtonSpacer,addButton_right, nil];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"顶操02@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickAdd)];
    self.navigationItem.title = @"黑名单";
    self.view.backgroundColor = [UIColor whiteColor];
    blacktableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height - 64) style:UITableViewStylePlain];
    blacktableView.showsVerticalScrollIndicator = NO;
    blacktableView.showsHorizontalScrollIndicator = NO;
    blacktableView.delegate = self;
    blacktableView.dataSource = self;
    blacktableView.rowHeight = 50;
    [self.view addSubview:blacktableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    dataSource = [[NSMutableArray alloc]init];
    [self getBlackList];

}
-(void)getBlackList
{
        
        NSString * urlStr = [NSString stringWithFormat:@"%@blacklist?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
        NSLog(@"获取用户黑名单 = %@",urlStr);
        NSURL * url = [NSURL URLWithString:urlStr];
        GetBlackListRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [GetBlackListRequest setRequestMethod:@"GET"];
        
        //1、header
        [GetBlackListRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //2、header
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        NSLog(@"更新用户位置 Authorization%@",Authorization);
        [GetBlackListRequest addRequestHeader:@"Authorization" value:Authorization];
        [GetBlackListRequest setDelegate:self];
        GetBlackListRequest.tag = 100;
        [GetBlackListRequest startAsynchronous];

}
#pragma mark - 更多图片响应请求的请求成功回调
//获取黑名单
- (void)requestFinished:(ASIHTTPRequest *)request {
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic4=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSArray * dataArray = [dic4 objectForKey:@"data"];
    NSLog(@"我的黑名单 responseString %@",[dic4 objectForKey:@"data"]);
    int statusCode = [request responseStatusCode];
    //我的中心 获取图片列表 statusCode 204
    NSLog(@"我的黑名单 statusCode %d",statusCode);
    if (request.tag == 100) {
        if (statusCode == 200 ) {
            if (dataArray.count == 0) {
                MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.labelText = @"温馨提示";
                HUD.detailsLabelText =@"您的黑名单是空的!";
                HUD.mode = MBProgressHUDModeText;
                [HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(2.0);
                } completionBlock:^{
                    [HUD removeFromSuperview];
                }];
            }else{
                for (NSDictionary * dic in dataArray) {
                    [dataSource addObject:dic];
                }
                [blacktableView reloadData];
            }
            
        }
        
    }
    if (request.tag == 101) {
        if (statusCode == 204 ) {
//            [dataSource removeObjectAtIndex:deleteid];
//            [blacktableView reloadData];
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"温馨提示";
            HUD.detailsLabelText =@"黑名单删除成功!";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];

        }else if (statusCode == 400){
            MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"温馨提示";
            HUD.detailsLabelText =[[dic4 objectForKey:@"errors"] objectForKey:@"code"];
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
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
    [dd showLeftController:YES];
}
-(void)clickAdd
{
    MyMailListViewController * mvc = [[MyMailListViewController alloc]init];
    [self.navigationController pushViewController:mvc animated:YES];
    [blacktableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SWTableViewCell * cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"blackList"];
    if (!cell) {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                 title:@"删除"];
        cell = [[SWTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:@"blackList"
                                 containingTableView:blacktableView // Used for row height and selection
                                  leftUtilityButtons:nil
                                 rightUtilityButtons:rightUtilityButtons];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSDictionary * dic = [dataSource objectAtIndex:indexPath.row];
    NSLog(@"name = %@",[dic objectForKey:@"name"]);
    NSLog(@"mobile = %@",[dic objectForKey:@"mobile"]);
    cell.textLabel.text = [dic objectForKey:@"name"];
    cell.detailTextLabel.text = [dic objectForKey:@"mobile"];
    return cell;
}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}
//- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self deleteBlackList:indexPath.row];
//        deleteid = indexPath.row;
//    }
//
//    
//}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scroll view did begin dragging");
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set background color of cell here if you don't want white
}

#pragma mark - SWTableViewDelegate

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSIndexPath *cellIndexPath = [blacktableView indexPathForCell:cell];
            [self deleteBlackList:cellIndexPath.row];
            [dataSource removeObjectAtIndex:cellIndexPath.row];
            [blacktableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
            
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)deleteBlackList:(int)idString
{
    
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:[[dataSource objectAtIndex:idString] objectForKey:@"id"],@"id", nil];
    NSLog(@"user = %@",user);
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        
        NSString * urlStr = [NSString stringWithFormat:@"%@blacklist/delete?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
        NSLog(@"更新用户位置 = %@",urlStr);
        NSURL * url = [NSURL URLWithString:urlStr];
        deleteBlackListRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        [deleteBlackListRequest setRequestMethod:@"POST"];
        
        //1、header
        [deleteBlackListRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //2、header
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        NSLog(@"更新用户位置 Authorization%@",Authorization);
        [deleteBlackListRequest addRequestHeader:@"Authorization" value:Authorization];
        
        [deleteBlackListRequest setDelegate:self];
        [deleteBlackListRequest setPostBody:tempJsonData];
        deleteBlackListRequest.tag = 101;
        [deleteBlackListRequest startAsynchronous];
    }

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [GetBlackListRequest setDelegate:nil];
    [deleteBlackListRequest setDelegate:nil];
    [GetBlackListRequest cancel];
    [deleteBlackListRequest cancel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
