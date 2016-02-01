//
//  SearchViewController.m
//  quxiangtou
//
//  Created by mac on 15/12/28.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "SearchViewController.h"
#import "SeekFriendTableViewCell.h"
#import "sendDataViewController.h"

@interface SearchViewController ()<ASIHTTPRequestDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField * searchTextField;
    ASIFormDataRequest * searchFirend;
    ASIFormDataRequest * searchHistory;
    UITableView * _tableView;
    NSMutableArray * pairedArray;
    int page;
    BOOL isHistory;
}
@end

@implementation SearchViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isHistory = YES;
    page = 0;
    pairedArray = [[NSMutableArray alloc]init];
    [self createNav];
   
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,65, Screen_width, Screen_height - 64 - 45) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
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
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.tag = 104;
    [navigationView addSubview:backButton];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, Screen_width, 1)];
    titleLabel.backgroundColor = [UIColor grayColor];
    [navigationView addSubview:titleLabel];
    
    UIButton * searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:16];
    searchButton.frame = CGRectMake(Screen_width - 10- 40, 20, 40, 44);
    //    searchButton.backgroundColor = [UIColor redColor];
    [searchButton addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    searchButton.tag = 105;
    [navigationView addSubview:searchButton];
    
    searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(60, 25, Screen_width - 120, 35)];
    searchTextField.placeholder = @"请输入手机号搜索";
    searchTextField.delegate = self;
    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    searchTextField.font = [UIFont systemFontOfSize:16];
    [navigationView addSubview:searchTextField];
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchClick
{
    if (searchTextField.text.length != 11) {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"手机号位数错误!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
        
    }else if ([ACommenData validatePhone:searchTextField.text]== NO){
        
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"手机号格式不正确!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil ];
        [alert show];
    }else{
        NSDictionary * dic = @{@"mobile":searchTextField.text};
        [[ACommenData sharedInstance].historyArray addObject:[dic objectForKey:@"data"]];
        NSString * urlStr = [NSString stringWithFormat:@"%@pair/search?udid=%@&mobile=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ],searchTextField.text];
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

}
- (void)requestFinished:(ASIHTTPRequest *)request {
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSDictionary * header = [NSDictionary dictionaryWithDictionary:[request responseHeaders]];
    NSLog(@"%@",header);
    NSLog(@"搜索配对用户 responseString %@",[dic objectForKey:@"data"]);
    int statusCode = [request responseStatusCode];
    NSLog(@"搜索配对用户 statusCode %d",statusCode);
    if (statusCode == 200 ) {
        isHistory = NO;
        if (dic.count == 0) {
            
            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"没有[%@]相关的用户",searchTextField.text] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }else{
            [pairedArray removeAllObjects];
            [pairedArray addObject:[dic objectForKey:@"data"]];
            [_tableView reloadData];
            
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pairedArray.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (isHistory == YES) {
        return @"历史搜索";
    }
    return @"搜索结果";
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
 
    [searchTextField resignFirstResponder];
    return YES;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchTextField resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [searchTextField resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    searchTextField.text = @"";
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    isHistory = YES;
    searchTextField.text = @"";
    [pairedArray removeAllObjects];
    [searchHistory cancel];
    [searchFirend cancel];
    searchHistory = nil;
    searchFirend = nil;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
@end
