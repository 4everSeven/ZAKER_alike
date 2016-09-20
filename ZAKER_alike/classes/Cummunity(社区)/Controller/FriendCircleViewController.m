//
//  FriendCircleViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/15.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "FriendCircleViewController.h"
#import "SignInViewController.h"
#import "SignUpViewController.h"
#import "FriendCircleCell.h"
#import "FriendItem.h"
#import <SVPullToRefresh.h>
#import "DetailViewController.h"
@interface FriendCircleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTop;

@property(nonatomic,strong)UITableView *mainTableView;
@property (nonatomic, strong)NSMutableArray *itObjs;
@end

@implementation FriendCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.layer.cornerRadius = 20;
    self.loginButton.layer.masksToBounds = YES;
    [self.loginButton setTintColor:[UIColor whiteColor]];
    self.loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.loginButton.backgroundColor = MainRed;
    
    self.signInButton.layer.cornerRadius = 20;
    self.signInButton.layer.masksToBounds = YES;
    [self.signInButton setTintColor:[UIColor whiteColor]];
    self.signInButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.signInButton.backgroundColor = MainBgColor;
    
    //[self.mainTableView registerNib:[UINib nibWithNibName:@"FriendCircleCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
//    //添加登录成功的监听
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(signIn) name:@"登录成功" object:nil];
}

//-(void)signIn{
//    if ([BmobUser currentUser]) {
//        [self mainTableView];
//        [self loadObjs];
//        NSLog(@"ssss");
//        __block __weak __typeof(&*self)weakSelf = self;
//        //下拉刷新
//        [self.mainTableView addPullToRefreshWithActionHandler:^{
//            [weakSelf loadObjs];
//        }];
//        //上拉加载
//        [self.mainTableView addInfiniteScrollingWithActionHandler:^{
//            [weakSelf loadMoreObjs];
//        }];
//        //self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        //去除分割线左边的空白
//        if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
//            [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
//        }
//        
//        if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
//            [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
//        }
//    }else{
//        [self.mainTableView removeFromSuperview];
//    }
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //NSLog(@"chuxianle ");
    if ([BmobUser currentUser]) {
        //[self mainTableView];
        [self setMainTab];
        [self loadObjs];
         __block __weak __typeof(&*self)weakSelf = self;
        //下拉刷新
        [self.mainTableView addPullToRefreshWithActionHandler:^{
            [weakSelf loadObjs];
        }];
        //上拉加载
        [self.mainTableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf loadMoreObjs];
        }];
        //self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //去除分割线左边的空白
        if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }else{
        [self.mainTableView removeFromSuperview];
    }
}
//登录
- (IBAction)loginClicked:(UIButton *)sender {
    SignInViewController *vc = [SignInViewController new];
 [self.navigationController pushViewController:vc animated:YES];
    //[self presentViewController:vc animated:YES completion:nil];
}

//注册
- (IBAction)signUpClicked:(id)sender {
    SignUpViewController *vc = [SignUpViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    //[self presentViewController:vc animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//加载数据
-(void)loadObjs{
    BmobQuery *query = [BmobQuery queryWithClassName:@"ITObject"];
    //设置请求条数
    query.limit = 10;
    //设置排序
    [query orderByDescending:@"createdAt"];
    //    设置包含user
    [query includeKey:@"user"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //请求到数据后 初始化数组
        self.itObjs = [NSMutableArray array];
        
        for (BmobObject *bObj in array) {
            FriendItem *itObj = [[FriendItem alloc]initWithBmobObject:bObj];
            [self.itObjs addObject:itObj];
        }
        [self.mainTableView reloadData];
        [self.mainTableView.pullToRefreshView stopAnimating];
    }];
}

//加载更多的数据
-(void)loadMoreObjs{
    BmobQuery *query = [BmobQuery queryWithClassName:@"ITObject"];
    //跳过已有数据的个数
    query.skip = self.itObjs.count;
    //设置请求条数
    query.limit = 10;
    //设置排序
    [query orderByDescending:@"createdAt"];
    //    设置包含user
    [query includeKey:@"user"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {

        for (BmobObject *bObj in array) {
            FriendItem *itObj = [[FriendItem alloc]initWithBmobObject:bObj];
            [self.itObjs addObject:itObj];
        }
        [self.mainTableView reloadData];
        [self.mainTableView.infiniteScrollingView stopAnimating];
    }];

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itObjs.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.item = self.itObjs[indexPath.row];
   // cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendItem *item = self.itObjs[indexPath.row];
    return item.totalHeight + 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendItem *item = self.itObjs[indexPath.row];
    DetailViewController *vc = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    vc.item= item;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setMainTab{
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:mainTableView];
    mainTableView.contentInset = UIEdgeInsetsMake(35, 0, 114, 0);
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundColor = MainBgColor;
    [mainTableView registerNib:[UINib nibWithNibName:@"FriendCircleCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.mainTableView = mainTableView;
}


@end
