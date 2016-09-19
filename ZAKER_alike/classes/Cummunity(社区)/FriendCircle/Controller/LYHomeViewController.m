//
//  LYHomeViewController.m
//  ITSNS
//
//  Created by Ivan on 16/1/9.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "TRDetailViewController.h"
#import "LYHomeCell.h"
#import "Bmob.h"
#import "LYHomeViewController.h"
#import "AppDelegate.h"
#import "TRITObject.h"
#import "SVPullToRefresh.h"
@interface LYHomeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *itObjs;
@end

@implementation LYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
 
    
    //要在下拉刷新事件之前添加 让内容往下显示
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    
    [tableView registerNib:[UINib nibWithNibName:@"LYHomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    //添加刷新事件
    [tableView addPullToRefreshWithActionHandler:^{
       
        [self loadObjs];
        
    }];
    

    
    //触发下拉刷新事件
    [tableView triggerPullToRefresh];
    
    //添加 上拉加载事件
    [tableView addInfiniteScrollingWithActionHandler:^{
        [self loadMoreObjs];
    }];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.itObjs.count==0) {
        [self.tableView triggerPullToRefresh];
    }
    
    
    //实现浏览量功能 返回页面时刷新选中的某一行
    //判断是否有选中
    if (self.tableView.indexPathForSelectedRow) {
        
        [self.tableView reloadRowsAtIndexPaths:@[self.tableView.indexPathForSelectedRow] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }
}

-(void)loadMoreObjs{
    BmobQuery *query = [BmobQuery queryWithClassName:@"ITObject"];
    //设置查询条件为 type = 0
    [query whereKey:@"type" equalTo:@(self.type).stringValue];
    //跳过已有数据的个数
    query.skip = self.itObjs.count;
    //设置请求条数
    query.limit = 10;
    
    //设置排序
    switch (self.type) {
        case 0:
            [query orderByDescending:@"createdAt"];
            break;
        case 1://问题
            [query orderByDescending:@"showCount"];
            break;
        case 2://项目
            [query orderByDescending:@"commentCount"];
            break;
    }
    
    //    设置包含user
    [query includeKey:@"user"];
    
    
    //查询指定某个用户的
    if (self.user) {
        
        [query whereKey:@"user" equalTo:self.user];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        
 
        
        for (BmobObject *bObj in array) {
            TRITObject *itObj = [[TRITObject alloc]initWithBmobObject:bObj];
            [self.itObjs addObject:itObj];
        }
        
        [self.tableView reloadData];
        
        //结束动画
        [self.tableView.infiniteScrollingView stopAnimating];
        
    }];

}
-(void)loadObjs{
   
   
    

    BmobQuery *query = [BmobQuery queryWithClassName:@"ITObject"];
    //设置查询条件为 type = 0
    [query whereKey:@"type" equalTo:@(self.type).stringValue];
    //设置请求条数
    query.limit = 10;
    //设置排序
    switch (self.type) {
        case 0:
            [query orderByDescending:@"createdAt"];
            break;
        case 1://问题
            [query orderByDescending:@"showCount"];
            break;
        case 2://项目
            [query orderByDescending:@"commentCount"];
            break;
    }
  
    
    
    
//    设置包含user
    [query includeKey:@"user"];
    
    //查询指定某个用户的
    if (self.user) {
        
        [query whereKey:@"user" equalTo:self.user];
    }
    
    
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
      
       
        //请求到数据后 初始化数组
        self.itObjs = [NSMutableArray array];
        
        for (BmobObject *bObj in array) {
            TRITObject *itObj = [[TRITObject alloc]initWithBmobObject:bObj];
            [self.itObjs addObject:itObj];
        }
      
        [self.tableView reloadData];
      
        //结束动画
        [self.tableView.pullToRefreshView stopAnimating];
        
    }];
    
    
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.itObjs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LYHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
  
    
    cell.itObj = self.itObjs[indexPath.row];
  
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //计算每行的高度
    TRITObject *itObj = self.itObjs[indexPath.row];
    
    
    
    return itObj.contentHeight + 64;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TRDetailViewController *vc = [TRDetailViewController new];
    
    vc.itObj = self.itObjs[indexPath.row];
    
    [vc.itObj addShowCount];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
