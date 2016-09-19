//
//  SearchChanelViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/15.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SearchChanelViewController.h"
#import "SearchChannelTableView.h"
@interface SearchChanelViewController ()
@property(nonatomic,strong)SearchChannelTableView *mainTableView;
@end

@implementation SearchChanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self mainTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (SearchChannelTableView *)mainTableView {
	if(_mainTableView == nil) {
		_mainTableView = [[SearchChannelTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mainTableView.contentInset = UIEdgeInsetsMake(35, 0, 64, 0);
        [self.view addSubview:_mainTableView];
	}
	return _mainTableView;
}

@end
