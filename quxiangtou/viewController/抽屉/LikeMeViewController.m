//
//  LikeMeViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "LikeMeViewController.h"
#import "VistorTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "VisitorDetailViewController.h"

@interface LikeMeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView * _collectionView;
    int page;
    ASIFormDataRequest * loginRequest;
    NSArray * vistorArray;
}
@end

@implementation LikeMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;

    self.view.backgroundColor = [UIColor whiteColor];
//    [self createNavigationBar];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"顶操01@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
    self.navigationItem.title = @"喜欢您";
    [self loadLikeMe];
}

-(void)loadLikeMe
{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@users/like?udid=%@&page=%d",URL_HOST,[[NSUserDefaults standardUserDefaults] objectForKey:@"udid" ],page];
    NSLog(@"访客  urlString %@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    loginRequest = [[ASIFormDataRequest alloc]initWithURL:url];
    [loginRequest setRequestMethod:@"GET"];
    [loginRequest setDelegate:self];
    
    [loginRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    
    NSString * Authorization = [NSString stringWithFormat:@"Qxt %@",[[ACommenData sharedInstance].logDic objectForKey:@"auth_token"]];
    NSLog(@"访客  Authorization %@",Authorization);
    [loginRequest addRequestHeader:@"Authorization" value:Authorization];
    [loginRequest startAsynchronous];
    
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
    NSLog(@"喜欢您 responseString %@",[request responseString]);
    int statusCode = [request responseStatusCode];
    NSLog(@"喜欢您 statusCode %d",statusCode);
    if (statusCode == 200 ) {
        
        if ([[header objectForKey:@"X-Total-Count"] intValue] == 0) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"没有人喜欢您，没关系，继续努力!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag=1003;
            [alert show];
            
        }else{
            vistorArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
            NSLog(@"喜欢您 array %@",vistorArray);
            page = [[[dic objectForKey:@"data"] objectForKey:@"next_page"] intValue];
            [self createUI];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //    NSLog(@"%d",vistorArray.count);
    //    NSLog(@"%d",vistorArray.count/3);
    if (vistorArray.count % 3 == 0) {
        NSLog(@"section = %d",vistorArray.count/3);
        return vistorArray.count/3;
    }else{
        NSLog(@"section = %d",vistorArray.count/3 + 1);
        return (vistorArray.count/3 + 1);
        
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (vistorArray.count % 3 ==0) {
        return 3;
    }else{
        if (section != vistorArray.count/3) {
            return 3;
        }else{
            return vistorArray.count%3;
        }
    }
    
    //return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VistorTableViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VistorTableViewCell" forIndexPath:indexPath];
    NSLog(@"头像 url %@",[[vistorArray objectAtIndex:(indexPath.section * 3 + indexPath.row)] objectForKey:@"avatar"]);
    
    if ([[[vistorArray objectAtIndex:(indexPath.section * 3 + indexPath.row)] objectForKey:@"avatar"] isNotEmpty]) {
        [cell.touxiangImage sd_setImageWithURL:[NSURL URLWithString:[[vistorArray objectAtIndex:(indexPath.section * 3 + indexPath.row)] objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"加载失败图片@3x.png"]];
    }else{
        cell.touxiangImage.image = [UIImage imageNamed:@"加载失败图片@3x.png"];
    }
    
    
    cell.nameLabel.text = [[vistorArray objectAtIndex:(indexPath.section * 3 + indexPath.row)] objectForKey:@"nickname"];
    cell.timeLabel.text = [[vistorArray objectAtIndex:(indexPath.section * 3 + indexPath.row)] objectForKey:@"visited_at"];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VisitorDetailViewController * vdvc = [[VisitorDetailViewController alloc]init];
    vdvc.visitorArray = vistorArray;
    vdvc.page = indexPath.section * 3 + indexPath.row;
    [self.navigationController pushViewController:vdvc animated:YES];
}
-(void)createUI
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(90, 136);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    layout.minimumLineSpacing = 20.0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, Screen_height - 64) collectionViewLayout:layout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[VistorTableViewCell class] forCellWithReuseIdentifier:@"VistorTableViewCell"];
    
    
}

-(void)showLeft
{
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
    [dd showLeftController:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [loginRequest setDelegate:nil];
    [loginRequest cancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
