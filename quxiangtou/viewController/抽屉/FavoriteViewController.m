//
//  FavoriteViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "FavoriteViewController.h"
#import "VistorTableViewCell.h"
#import "CASegmentedControl.h"
#import "VisitorDetailViewController.h"
@interface FavoriteViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,deleteFavoriteFriendDelegate,UIAlertViewDelegate>
{
    UICollectionView * _collectionView;
    NSMutableArray * list;
    CASegmentedControl * control;
    
    NSInteger Page;
    
    ASIFormDataRequest * addMeFavoriteRequest;
    ASIFormDataRequest * meFavoriteRequest;
    ASIFormDataRequest * deleteFavoriteRequest;
    
    BOOL isActivity;
//    BOOL isDelete;
    int index;
    int show;
}


@end

@implementation FavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isActivity = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    list = [[NSMutableArray alloc]init];
    Page = 0;
    index = 0;
    show = 0;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"顶操01@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
    self.navigationItem.title = @"最喜欢";
    self.view.backgroundColor = [UIColor whiteColor];
    
    control = [CASegmentedControl titles:@[@"已加您为最爱",@"你的最爱"] delegate:self];
    [self.view addSubview:control];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(90, 136);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumLineSpacing = 20.0;

    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, control.frame.size.height + control.frame.origin.y + 10, self.view.frame.size.width - 20, Screen_height - 64 - control.frame.size.height - control.frame.origin.y - 10) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[VistorTableViewCell class] forCellWithReuseIdentifier:@"VistorTableViewCell"];
    
}
//-(void)editButton
//{
//    if (isDelete == YES) {
//        isDelete = NO;
//    }else{
//        isDelete = YES;
//    }
//    [_collectionView reloadData];
//}
-(void)requestAddMeFavorite
{
    NSString * urlStr = [NSString stringWithFormat:@"%@favorite/me?udid=%@&page=%d",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ],Page];
    NSLog(@"最爱  urlString %@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    addMeFavoriteRequest = [[ASIFormDataRequest alloc]initWithURL:url];
    [addMeFavoriteRequest setRequestMethod:@"GET"];
    [addMeFavoriteRequest setDelegate:self];
    
    [addMeFavoriteRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    
    NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
    NSLog(@"最爱  Authorization %@",Authorization);
    addMeFavoriteRequest.tag = 100;
    [addMeFavoriteRequest addRequestHeader:@"Authorization" value:Authorization];
    [addMeFavoriteRequest startAsynchronous];
    
    //提示警告框失败...
    MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.tag = 123456;
    HUD.labelText = @"正在获取访客";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2.0);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}
-(void)requestMeFavorite
{
    NSString * urlStr = [NSString stringWithFormat:@"%@favorite?udid=%@&page=%d",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ],Page];
    NSLog(@"最爱  urlString %@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    meFavoriteRequest = [[ASIFormDataRequest alloc]initWithURL:url];
    [meFavoriteRequest setRequestMethod:@"GET"];
    [meFavoriteRequest setDelegate:self];
    
    [meFavoriteRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    
    NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
    NSLog(@"最爱  Authorization %@",Authorization);
    meFavoriteRequest.tag = 101;
    [meFavoriteRequest addRequestHeader:@"Authorization" value:Authorization];
    [meFavoriteRequest startAsynchronous];
    
    //提示警告框失败...
    MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.tag = 123456;
    HUD.labelText = @"正在获取访客";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2.0);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];

}
- (void)requestFinished:(ASIHTTPRequest *)request {
    MBProgressHUD *bd=(MBProgressHUD *)[self.view viewWithTag:123456];
    [bd removeFromSuperview];
    bd=nil;
    
    //解析接收回来的数据
    NSString *responseString=[request responseString];
    NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSDictionary * header = [NSDictionary dictionaryWithDictionary:[request responseHeaders]];
    NSLog(@"%@",header);
    NSLog(@"最爱 responseString %@",[dic objectForKey:@"data"]);
    int statusCode = [request responseStatusCode];
    NSLog(@"最爱 statusCode %d",statusCode);
    if (request.tag == 100) {
        if (statusCode == 200 ) {
            
            if ([[[dic objectForKey:@"data"] objectForKey:@"next_page"] intValue] == 0) {
                NSArray * a = [[dic objectForKey:@"data"] objectForKey:@"list"];
                NSLog(@"a.count = %lu",(unsigned long)a.count);
                if (a.count > 0) {
                    for (NSDictionary * d in a) {
                        [list addObject:d];
                        
                    }
                    [_collectionView reloadData];
                }else{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"还没有人加您为最爱，没关系，继续努力!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag=1001;
                    [alert show];
                    [_collectionView reloadData];
                }
                
                
            }else{
                
                Page = [[[dic objectForKey:@"data"] objectForKey:@"next_page"] intValue];
                for (NSDictionary * d in [[dic objectForKey:@"data"] objectForKey:@"list"]) {
                    [list addObject:d];
                }
                [_collectionView reloadData];

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
    if (request.tag == 101) {
        
        if (statusCode == 200 ) {
            
            if ([[[dic objectForKey:@"data"] objectForKey:@"next_page"] intValue] == 0) {
                NSArray * a = [[dic objectForKey:@"data"] objectForKey:@"list"];
                NSLog(@"a.count = %lu",(unsigned long)a.count);
                if (a.count > 0) {
                    for (NSDictionary * d in a) {
                        [list addObject:d];
                        
                    }
                    [_collectionView reloadData];
                }else{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有最爱的人，没关系，继续努力!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag=1002;
                    [alert show];
                    [_collectionView reloadData];
                }
                
                
            }else{
                
                Page = [[[dic objectForKey:@"data"] objectForKey:@"next_page"] intValue];
                for (NSDictionary * d in [[dic objectForKey:@"data"] objectForKey:@"list"]) {
                    [list addObject:d];
                }
                [_collectionView reloadData];
                
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
    
    //删除最爱的人
    if (request.tag == 110) {
        if (statusCode == 204) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"删除成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag=1009;
            [alert show];
            
        }else{
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:[[dic valueForKey:@"errors"] objectForKey:@"code"]
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil ];
            alert.tag = 1004;
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

-(void)segmentedControl:(CASegmentedControl *)control index:(NSInteger)index
{
    [list removeAllObjects];
    if(index==0)
    {
        Page = 0;
        isActivity = YES;
        [self requestAddMeFavorite];
        
    }else if(index==1)
    {
        Page = 0;
        isActivity = NO;
        [self requestMeFavorite];
//        [self httpList:@"" andCommon:@"1" andCurrpage:@(Page)];
    }
}


-(void)showLeft
{
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
    [dd showLeftController:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (list.count % 3 == 0) {
        NSLog(@"section = %u",list.count/3);
        return list.count/3;
    }else{
        NSLog(@"section = %u",list.count/3 + 1);
        return (list.count/3 + 1);
        
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (list.count % 3 ==0) {
        return 3;
    }else{
        if (section != list.count/3) {
            return 3;
        }else{
            return list.count%3;
        }
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VistorTableViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VistorTableViewCell" forIndexPath:indexPath];

    if (isActivity == NO) {
        cell.deleteDelegate = self;
    }
    
    if ([[[list objectAtIndex:(indexPath.section * 3 + indexPath.row)] objectForKey:@"avatar"] isNotEmpty]) {
        [cell.touxiangImage sd_setImageWithURL:[NSURL URLWithString:[[list objectAtIndex:(indexPath.section * 3 + indexPath.row)] objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
    }else{
        cell.touxiangImage.image = [UIImage imageNamed:@"加载失败图片@3x.png"];
    }
    
    cell.nameLabel.text = [[list objectAtIndex:(indexPath.section * 3 + indexPath.row)] objectForKey:@"nickname"];
    NSArray * arr = [[[list objectAtIndex:(indexPath.section * 3 + indexPath.row)] objectForKey:@"created_at"] componentsSeparatedByString:@" "];
    NSString * timeString = [NSString stringWithString:[arr objectAtIndex:0]];
    cell.timeLabel.text = timeString;

    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VisitorDetailViewController * vdvc = [[VisitorDetailViewController alloc]init];
    vdvc.visitorArray = list;
    vdvc.page = indexPath.section * 3 + indexPath.row;
    [self.navigationController pushViewController:vdvc animated:YES];

}
-(void)deleteFavoriteFriend:(VistorTableViewCell *)cell
{
        NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你是否要删除此用户!" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag=100;
        index = indexPath.row;
        [alert show];


}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            
        }else{
            
            [self deleteMeFavoriteFriend];
        }
    }
    if (alertView.tag == 1009) {
        [list removeAllObjects];
        Page = 0;
        [self requestMeFavorite];
    
    }
}
-(void)deleteMeFavoriteFriend
{
    NSDictionary * user = [[NSDictionary alloc]initWithObjectsAndKeys:[[list objectAtIndex:index] objectForKey:@"uuid"],@"uuid", nil];
    NSLog(@"user = %@",user);
    if ([NSJSONSerialization isValidJSONObject:user]) {
        NSError * error;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:&error];
        NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString * urlStr = [NSString stringWithFormat:@"%@favorite/delete?udid=%@",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ]];
        NSLog(@"删除最爱的人  %@",urlStr);
        NSURL * url = [NSURL URLWithString:urlStr];
        deleteFavoriteRequest = [[ASIFormDataRequest alloc]initWithURL:url];
        
        [deleteFavoriteRequest setRequestMethod:@"POST"];
        
        [deleteFavoriteRequest setDelegate:self];
        
        //1、
        [deleteFavoriteRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //2、header
        NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
        NSLog(@"删除最爱的人 Authorization%@",Authorization);
        [deleteFavoriteRequest addRequestHeader:@"Authorization" value:Authorization];
        
        deleteFavoriteRequest.tag = 110;
        
        [deleteFavoriteRequest setPostBody:tempJsonData];
        [deleteFavoriteRequest startAsynchronous];
    }
 
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [addMeFavoriteRequest cancel];
    [meFavoriteRequest cancel];
    [deleteFavoriteRequest cancel];
    [addMeFavoriteRequest setDelegate:nil];
    [meFavoriteRequest setDelegate:nil];
    [deleteFavoriteRequest setDelegate:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
