//
//  CustomTabBar ViewController.m
//  StarDoctor1
//
//  Created by mac on 15/8/24.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.

//

#import "CustomTabBarViewController.h"

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController : UITabBarController
@synthesize currentSelectedIndex,buttons;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.currentSelectedIndex=1000;
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //创建背景图片
    if([self.view viewWithTag:1000]){
        
    }else{
        [self hideRealTabBar];
        [self customTabBar];
    }
}
- (void)hideRealTabBar{
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[UITabBar class]]){
            view.hidden = YES;
            break;
        }
    }
}
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated
{
	if (yesOrNO == YES)
	{
		if (self.tabBar.frame.origin.y == self.view.frame.size.height)
		{
			return;
		}
	}
	else
	{
		if (self.tabBar.frame.origin.y == self.view.frame.size.height - 49)
		{
			return;
		}
	}
	
	if (animated == YES)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		if (yesOrNO == YES)
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + 49, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		else
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - 49, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		[UIView commitAnimations];
	}
	else
	{
		if (yesOrNO == YES)
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + 49, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		else
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - 49, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
	}
}
- (void)customTabBar{
    
    NSArray *allStateImg=[NSArray arrayWithObjects:@"设备1@2x.png",@"自娱自乐1@2x.png",@"双人娱乐1@2x.png",@"商城1@2x.png",nil];
    NSArray *allSelectIg=[NSArray arrayWithObjects:@"设备选中1@2x.png",@"自娱自乐选中1@2x.png",@"双人娱乐选中1@2x.png",@"商城选中1@2x.png",nil];
    //创建按钮
    int viewCount = allSelectIg.count;
    float _width = Screen_width / viewCount;
    float _height = self.tabBar.frame.size.height;
    for (int i = 0; i < viewCount; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backIg=[UIImage imageNamed:[allStateImg objectAtIndex:i]];
        btn.frame = CGRectMake(i*_width,self.tabBar.frame.origin.y, _width, _height);
        [btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+1000;
        [btn setBackgroundImage:backIg forState:UIControlStateNormal];
        [self.view  addSubview:btn];
        
        if(btn.tag==1000){
            [btn setBackgroundImage:[UIImage imageNamed:[allSelectIg objectAtIndex:i]] forState:UIControlStateNormal];
            saveBtn=btn;
        }
    }
}
- (void)selectedTab:(UIButton *)button{
    NSArray *allStateImg=[NSArray arrayWithObjects:@"设备1@2x.png",@"自娱自乐1@2x.png",@"双人娱乐1@2x.png",@"商城1@2x.png",nil];
    NSArray *allSelectIg=[NSArray arrayWithObjects:@"设备选中1@2x.png",@"自娱自乐选中1@2x.png",@"双人娱乐选中1@2x.png",@"商城选中1@2x.png",nil];
    if (self.currentSelectedIndex != button.tag) {
        [saveBtn setBackgroundImage:[UIImage imageNamed:[allStateImg objectAtIndex:self.currentSelectedIndex-1000]] forState:UIControlStateNormal];
    }
    [button setBackgroundImage:[UIImage imageNamed:[allSelectIg objectAtIndex:button.tag-1000]] forState:UIControlStateNormal];
    self.currentSelectedIndex = button.tag;
    saveBtn=button;
    self.selectedIndex = button.tag-1000;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

-(void)dealloc{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
