//
//  SelectedViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/13.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SelectedViewController.h"
#import "SelectedTableView.h"
@interface SelectedViewController ()
@property(nonatomic,strong)SelectedTableView *mainTableView;
@end

@implementation SelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //判断是否是从话题跳转过来的
    if (self.apiUrl) {
        [self setNavi];
    }
    [self mainTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mainTableView.contentInset = UIEdgeInsetsMake(35, 0, 108, 0);
}

-(void)setNavi{
    UIBarButtonItem *bt = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrowLeft-gray-32"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackToLast)];
    self.navigationItem.leftBarButtonItem = bt;
    self.title = self.naviTitle;
}

-(void)goBackToLast{
    [self.navigationController popViewControllerAnimated:YES];
}

- (SelectedTableView *)mainTableView {
	if(_mainTableView == nil) {
        _mainTableView = [[SelectedTableView alloc] initWithFrame:CGRectMake(0, 35, SQSW, SQSH) style:UITableViewStylePlain url:self.apiUrl];
        //判断是不是从话题板块跳转过来的
        if (self.apiUrl) {
            _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, -108, 0);

            _mainTableView.frame = self.view.bounds;
        }else{
            _mainTableView.contentInset = UIEdgeInsetsMake(35, 0, 108, 0);
        }
        [self.view addSubview:_mainTableView];
	}
	return _mainTableView;
}

@end
