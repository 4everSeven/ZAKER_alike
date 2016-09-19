//
//  FunViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/8/30.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "FunViewController.h"
#import "HeaderScrollView.h"
//#import "ColumnsTableViewController.h"
#import "FunTableView.h"
#import "WebUtils.h"
#import "FunItems.h"
#import "FunSectionHeaderItem.h"
#import <SVProgressHUD.h>
@interface FunViewController ()

@property(nonatomic,strong)FunTableView *mainTableView;


@end

@implementation FunViewController


#pragma mark - 生命周期 lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];

    //[self mainTableView];
    
    [self setMainTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setMainTableView{
    FunTableView * mainTableView= [[FunTableView alloc] initWithFrame:CGRectMake(0, 0, SQSW, SQSH - 64) style:UITableViewStyleGrouped];
    mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 24, 0);
    mainTableView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:mainTableView];
    self.mainTableView = mainTableView;
}

#pragma mark - 懒加载 lazyLoad
//- (FunTableView *)mainTableView {
//	if(_mainTableView == nil) {
	//	_mainTableView = [[FunTableView alloc] initWithFrame:CGRectMake(0, 0, SQSW, SQSH - 64) style:UITableViewStyleGrouped];
    //    _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 24, 0);
       //_mainTableView.showsVerticalScrollIndicator =NO;
  //      [self.view addSubview:_mainTableView];
        
//	}
//	return _mainTableView;
//}

@end
