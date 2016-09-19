//
//  SearchSelectedViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/15.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SearchSelectedViewController.h"
#import "SearchSelectedTableView.h"
@interface SearchSelectedViewController ()
@property(nonatomic,strong)SearchSelectedTableView *mainTableView;
@end

@implementation SearchSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self mainTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (SearchSelectedTableView *)mainTableView {
	if(_mainTableView == nil) {
		_mainTableView = [[SearchSelectedTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _mainTableView.contentInset = UIEdgeInsetsMake(35, 0, 35, 0);
        [self.view addSubview:_mainTableView];
	}
	return _mainTableView;
}

@end
