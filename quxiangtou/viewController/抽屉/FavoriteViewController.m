//
//  FavoriteViewController.m
//  quxiangtou
//
//  Created by wei feng on 15/8/12.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import "FavoriteViewController.h"
#import "VistorTableViewCell.h"

@interface FavoriteViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView * _collectionView;
    NSMutableArray * AddMeArray;
    NSMutableArray * MyArray;
    int  buttonState;
    UIView * view;
}


@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"顶操01@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
    self.navigationItem.title = @"最喜欢";
    self.view.backgroundColor = [UIColor whiteColor];
    //[self createUI];
}

-(void)showLeft
{
    DDMenuController * dd = (DDMenuController *)[[[[UIApplication sharedApplication] delegate] window]rootViewController];
    [dd showLeftController:YES];
}
-(void)createUI
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(90, 136);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumLineSpacing = 20.0;
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect ];
    button1.frame = CGRectMake(15, 6, (Screen_width - 30) / 2, 30);
    [button1 setTitle:@"已加您为最爱" forState:UIControlStateNormal];
    button1.tag = 1;
    button1.titleLabel.font = [UIFont systemFontOfSize:20];
    button1.backgroundColor = [UIColor blueColor];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect ];
    button2.frame = CGRectMake(button1.frame.size.width + button1.frame.origin.x, button1.frame.origin.y, (Screen_width - 30) / 2, 30);
    [button2 setTitle:@"您的最爱" forState:UIControlStateNormal];
    button2.tag = 2;
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor blueColor];
    button2.titleLabel.font = [UIFont systemFontOfSize:20];
    [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, button1.frame.size.height + button1.frame.origin.y + 10, self.view.frame.size.width - 20, Screen_height - 64 - button1.frame.size.height - button1.frame.origin.y - 10) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[VistorTableViewCell class] forCellWithReuseIdentifier:@"VistorTableViewCell"];
}
-(void)buttonClick:(UIButton *)button
{
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 8;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VistorTableViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VistorTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
