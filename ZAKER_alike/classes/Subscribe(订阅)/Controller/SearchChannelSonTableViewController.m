//
//  SearchChannelSonTableViewController.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/16.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SearchChannelSonTableViewController.h"
#import "SonChannelCell.h"
#import "SonChannelItem.h"
#import "SubArticleListViewController.h"
@interface SearchChannelSonTableViewController ()<UISearchBarDelegate>
//@property(nonatomic,strong)NSArray *sons;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,assign)BOOL isSearching;
@property(nonatomic,strong)NSMutableArray *searchArray;
@property(nonatomic,strong)NSMutableArray *channelsArray;
@end

@implementation SearchChannelSonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    self.isSearching = NO;
    //self.sons = [SonChannelItem mj_keyValuesArrayWithObjectArray:self.item.sons];
    [self.tableView registerNib:[UINib nibWithNibName:@"SonChannelCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //去除cell分割线的空白
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 方法 methods
//设置导航栏
-(void)setNavi{
    
    CGFloat width = SQSW - 70;
    //设置右边的searchBar
    UISearchBar * searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, width, 40)];
    searchBar.delegate = self;
    [searchBar setPlaceholder:@"搜索文章和频道"];
    //searchBar.showsCancelButton = YES;
    
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.layer.cornerRadius = 14.f;
    searchField.layer.masksToBounds = YES;
    [searchField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    UIBarButtonItem * searchButton = [[UIBarButtonItem alloc]initWithCustomView:searchBar];
    self.navigationItem.rightBarButtonItem = searchButton;
    
     self.searchBar = searchBar;
    //设置左边的返回按钮
    UIBarButtonItem *bt = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrowLeft-gray-32"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackToLast)];
    self.navigationItem.leftBarButtonItem = bt;
}


// UISearchBarDelegate定义的方法，用户单击取消按钮时激发该方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //NSLog(@"----searchBarCancelButtonClicked------");
    // 取消搜索状态
    self.isSearching = NO;
    [self.tableView reloadData];
}

// UISearchBarDelegate定义的方法，当搜索文本框内文本改变时激发该方法
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    self.isSearching = YES;
    self.searchArray = [NSMutableArray array];
    for (CollectionCellItem *item in self.sons) {
        if ([[item valueForKey:@"title"] containsString:searchText]) {
            [self.searchArray addObject:item];
        }
    }
    [self.tableView reloadData];
    //NSLog(@"----textDidChange------");
    
}

-(void)goBackToLast{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearching == NO) {
        return self.sons.count;
    }else{
        return self.searchArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SonChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.isSearching == NO) {
        cell.item = self.sons[indexPath.row];
    }else{
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCellItem *item = self.sons[indexPath.row];
    SubArticleListViewController *vc = [SubArticleListViewController new];
    vc.item = item;
    vc.api_url = [item valueForKey:@"api_url"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}




@end
