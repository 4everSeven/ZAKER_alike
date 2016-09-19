//
//  MainTabBarController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/8/30.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "MainTabBarController.h"
#import "Titles.h"
#import "MainNavi.h"
#import "CummunityViewController.h"
#import "FunViewController.h"
#import "HotsspotsViewController.h"
//#import "LBSViewController.h"
#import "SubscribeViewController.h"

@interface MainTabBarController ()
@property(nonatomic,strong)NSArray *titles;
@end

@implementation MainTabBarController


#pragma mark - 生命周期 lifeCircle
-(instancetype)init{
    self = [super init];
    if (self) {
        self.tabBar.tintColor = MainRed;
        self.tabBar.translucent = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAllNavi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置方法 methods
//设置所有的tabbar子视图
-(void)setAllNavi{
    SubscribeViewController *sub = [SubscribeViewController new];
    MainNavi *subNavi = [[MainNavi alloc]initWithRootViewController:sub];
    sub.title = @"订阅";
    [self addChildViewController:subNavi];
    subNavi.tabBarItem.image = [UIImage imageNamed:@"DashboardTabBarItemSubscription"];
    
    HotsspotsViewController *hot = [HotsspotsViewController new];
    MainNavi *hotNavi = [[MainNavi alloc]initWithRootViewController:hot];
    hot.title = @"热点";
    [self addChildViewController:hotNavi];
    hotNavi.tabBarItem.image = [UIImage imageNamed:@"DashboardTabBarItemDailyHot"];
    
//    LBSViewController *local = [LBSViewController new];
//    MainNavi *localNavi = [[MainNavi alloc]initWithRootViewController:local];
//    local.title = @"当地";
//    [self addChildViewController:localNavi];
//    localNavi.tabBarItem.image = [UIImage imageNamed:@"DashboardTabbarLife"];
    
    
    FunViewController *fun = [FunViewController new];
    MainNavi *funNavi = [[MainNavi alloc]initWithRootViewController:fun];
    fun.title = @"玩乐";
    [self addChildViewController:funNavi];
    funNavi.tabBarItem.image = [UIImage imageNamed:@"star"];
    CummunityViewController *cum = [CummunityViewController new];
    MainNavi *cumNavi = [[MainNavi alloc]initWithRootViewController:cum];
    cum.title = @"社区";
    [self addChildViewController:cumNavi];
    cumNavi.tabBarItem.image = [UIImage imageNamed:@"DashboardTabBarItemDiscussion"];
}

//设置图片不被渲染(目前不需要)
-(UIImage *)setImageRenderWithImage:(UIImage*)image{
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
