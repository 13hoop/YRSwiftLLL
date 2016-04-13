//
//  HelpViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/7/24.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "HelpViewController.h"
#import "FRegistViewController.h"
#import "loginViewController.h"
#import "DDMenuController.h"

@interface HelpViewController ()<UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
    
    //页面控制视图（小白点）
    UIPageControl * _pageControll;
}

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //创建scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    
    //添加新手帮助图片
    NSArray * imageArrays = @[@"美女01.jpg",@"美女02.jpg",@"美女03.jpg",@"美女04.jpg",@"美女05.jpg"];
    for (int i = 0; i < imageArrays.count;i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*Screen_width, 0, Screen_width, Screen_height)];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:[imageArrays objectAtIndex:i]];
       
        
        [_scrollView addSubview:imageView];
    }
    _scrollView.contentSize = CGSizeMake(imageArrays.count*Screen_width, Screen_height);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    //创建_pageControl
    _pageControll = [[UIPageControl alloc]initWithFrame:CGRectMake(0, Screen_height - 120, Screen_width, 30)];
    //设置有多少个点
    _pageControll.numberOfPages = imageArrays.count;
    _pageControll.hidesForSinglePage = YES;
    _pageControll.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControll.currentPageIndicatorTintColor = [UIColor grayColor];
    [_pageControll addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    //注意，需要添加在self.view之上
    [self.view addSubview:_pageControll];
    
    UIButton * regist = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    regist.frame = CGRectMake(Screen_width/2 - 120, Screen_height - 60, 80, 40);
    [regist setTitle:@"注册" forState:UIControlStateNormal];
    regist.titleLabel.font = [UIFont systemFontOfSize:23.0];
    [regist addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regist];
    
    UIButton * login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    login.frame = CGRectMake(Screen_width / 2 + 40, Screen_height - 60, 80, 40);
    [login setTitle:@"登录" forState:UIControlStateNormal];
    login.titleLabel.font = [UIFont systemFontOfSize:23.0];
    [login addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
    
}
-(void)registerClick:(UIButton *)button
{
    FRegistViewController * frvc = [[FRegistViewController alloc]init];
//    [self.navigationController pushViewController:frvc animated:YES];
    [self presentViewController:frvc animated:YES completion:nil];
}
-(void)loginClick:(UIButton * )button
{
    loginViewController * lvc = [[loginViewController alloc]init];
    [self presentViewController:lvc animated:YES completion:nil];
}
-(void)valueChanged:(UIPageControl *)pc
{
    [_scrollView setContentOffset:CGPointMake(pc.currentPage*Screen_width, 0) animated:YES];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControll.currentPage = scrollView.contentOffset.x/Screen_width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
