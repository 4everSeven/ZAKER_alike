//
//  FunTableView.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/8.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "FunTableView.h"
#import "HeaderScrollView.h"
#import "WebUtils.h"
#import "FunItems.h"
#import "FunSectionHeaderItem.h"
#import "FunTableViewCell.h"
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import "ArticleContentItem.h"
#import "AirticleViewController.h"
#import "SubArticleItem.h"
#import "UIView+Navi.h"
#import "FunArticleItem.h"
#import "HeaderScrollViewForFun.h"
#import <SVPullToRefresh.h>
@interface FunTableView()<UITableViewDataSource,UITableViewDelegate>
//@property(nonatomic,strong)HeaderScrollView *headerScrollView;
@property(nonatomic,strong)HeaderScrollViewForFun *headerScrollView;
@property(nonatomic,strong)NSMutableArray *sectionsArray;

@property(nonatomic,strong)NSString *nextUrl;

@end
@implementation FunTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.groupsArray = [NSMutableArray array];
        [SVProgressHUD show];

        [self setHeader];
        [self loadData];

        [self registerNib:[UINib nibWithNibName:@"FunTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        self.delegate = self;
        self.dataSource = self;
        
        // 取出底部cell的分割线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //下拉刷新
         __block __weak __typeof(&*self)weakSelf = self;
        [self addPullToRefreshWithActionHandler:^{
            [weakSelf loadData];
        }];
        
        //上拉加载
        [self addInfiniteScrollingWithActionHandler:^{
            //[weakSelf setHeader];
            [weakSelf loadMoreData];
        }];
    }
    return self;
}


#pragma mark - 方法 methods
//加载网络数据
-(void)loadData{
//    [WebUtils requestFunItemWithCompletion:^(id obj) {
//        self.sectionsArray = obj;
//        [self reloadData];
//        [SVProgressHUD dismiss];
//    }];
    
    [WebUtils requestFunItemRealWithCompletion:^(NSArray *array, NSString *url) {
        self.sectionsArray = [array mutableCopy];
        self.nextUrl = url;
        [self reloadData];
        [self.pullToRefreshView stopAnimating];
        [SVProgressHUD dismiss];
    }];
}

-(void)loadMoreData{
    [WebUtils requestMoreFunItemWithUrl:self.nextUrl andCompletion:^(NSArray *array, NSString *url) {
        [self.sectionsArray addObjectsFromArray:array];
        self.nextUrl = url;
        [self reloadData];
        [self.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark - UITableViewDataSource delegateMethods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    FunSectionHeaderItem *item = self.sectionsArray[0];
    NSArray *items = [item valueForKey:@"items"];
    return items.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    FunSectionHeaderItem *item = self.sectionsArray[indexPath.section];
    NSArray *items = [item valueForKey:@"items"];
    NSArray *mjItems = [FunItems mj_objectArrayWithKeyValuesArray:items];
    FunItems *funItem = mjItems[indexPath.row];
    cell.item = funItem;
    return cell;
}

#pragma mark - UITableView delegateMethods
//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

//组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

//组头view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *view = [[UIImageView alloc] init];
    
    FunSectionHeaderItem *item = self.sectionsArray[section];
    NSDictionary *banner = [item valueForKey:@"banner"];
    [view sd_setImageWithURL:[NSURL URLWithString:banner[@"url"]]];
    
    return view;
}

//组脚的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

//组脚view
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer setBackgroundColor:[UIColor whiteColor]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FunSectionHeaderItem *item = self.sectionsArray[indexPath.section];
    NSArray *items = [item valueForKey:@"items"];
    NSArray *mjItems = [FunItems mj_objectArrayWithKeyValuesArray:items];
    FunItems *funItem = mjItems[indexPath.row];
    NSDictionary *subItem = funItem.article;
    AirticleViewController *vc = [[AirticleViewController alloc]initWithNibName:@"AirticleViewController" bundle:nil];
   // vc.item = subItem;
    FunArticleItem *aItem = [FunArticleItem mj_objectWithKeyValues:subItem];
    vc.funItem = aItem;
    [[self naviController]pushViewController:vc animated:YES];
    
}

#pragma mark - 懒加载 lazyLoad
//- (HeaderScrollViewForFun *)headerScrollView {
//    if(_headerScrollView == nil) {
//        _headerScrollView = [[HeaderScrollViewForFun alloc] initWithFrame:CGRectMake(0, 0, SQSW, 180)];

//        self.tableHeaderView = _headerScrollView;
//    }
//    return _headerScrollView;
//}

-(void)setHeader{
    HeaderScrollViewForFun *headerScrollView = [[HeaderScrollViewForFun alloc] initWithFrame:CGRectMake(0, 0, SQSW, 180)];
    self.tableHeaderView = headerScrollView;
    self.headerScrollView = headerScrollView;
}
@end
