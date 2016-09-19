//
//  TopicViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/13.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicTableView.h"
@interface TopicViewController ()
@property(nonatomic,strong)TopicTableView *mainTableView;
@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self mainTableView];
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

- (TopicTableView *)mainTableView {
	if(_mainTableView == nil) {
		_mainTableView = [[TopicTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mainTableView.contentInset = UIEdgeInsetsMake(35, 0, 108, 0);
        _mainTableView.separatorInset = UIEdgeInsetsZero;
       _mainTableView.separatorColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        [self.view addSubview:_mainTableView];
	}
	return _mainTableView;
}

@end
