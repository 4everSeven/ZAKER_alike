//
//  MainNavi.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/8/30.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "MainNavi.h"

@interface MainNavi ()

@end

@implementation MainNavi

//重写初始化方法
-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainRed} forState:UIControlStateSelected];
        [[UINavigationBar appearance]setBarTintColor:MainRed];
        self.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationBar.translucent = NO;
          [[UINavigationBar appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    }
    return self;
}
//重写push的方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.childViewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    [super pushViewController:viewController animated:animated];
}

//-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
//    
//    [super popViewControllerAnimated:animated];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
