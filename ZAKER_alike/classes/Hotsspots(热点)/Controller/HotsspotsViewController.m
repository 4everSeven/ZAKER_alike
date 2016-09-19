//
//  HotsspotsViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/8/30.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "HotsspotsViewController.h"
#import "HotTableView.h"
@interface HotsspotsViewController ()
@property(nonatomic,strong)HotTableView *mainTableView;
@end

@implementation HotsspotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mainTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (HotTableView *)mainTableView {
	if(_mainTableView == nil) {
        _mainTableView = [[HotTableView alloc] initWithFrame:CGRectMake(0, 0, SQSW, SQSH - 108) style:UITableViewStylePlain];
        [self.view addSubview:_mainTableView];
	}
	return _mainTableView;
}

@end
