//
//  SelectedTableView.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/13.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SelectedTableView.h"
#import "CummunityTableViewCell.h"
#import "WebUtils.h"
#import "CummunityDetailViewController.h"
#import "UIView+Navi.h"
#import <SVPullToRefresh.h>
@interface   SelectedTableView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *itemsArray;
@property(nonatomic,strong)NSString *nextUrl;

@end
static NSString *identify = @"cell";
@implementation SelectedTableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style url:(NSString*)url{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = MainBgColor;
        [self registerNib:[UINib nibWithNibName:@"CummunityTableViewCell" bundle:nil] forCellReuseIdentifier:identify];

        if (!url) {
            [self loadData];
        }else{
            [self loadDataFromTopicWithUrl:url];
        }
        //去除分割线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    //添加下拉刷新事件
     __block __weak __typeof(&*self)weakSelf = self;
    [self addPullToRefreshWithActionHandler:^{
        if (!url) {
            [weakSelf loadData];
        }else{
            [weakSelf loadDataFromTopicWithUrl:url];
        }

    }];
    
    if (!url) {
        //添加上拉加载事件
        [self addInfiniteScrollingWithActionHandler:^{
            [weakSelf loadMoreData];
        }];
    }
    
    return self;
}


#pragma mark - 方法 methods
-(void)loadData{
//    [WebUtils requestCummunityItemWithCompletion:^(id obj) {
//        self.itemsArray = obj;
//        [self reloadData];
//        //self.contentInset = UIEdgeInsetsMake(60, 0, 108, 0);
//        [self.pullToRefreshView stopAnimating];
//    }];
    [WebUtils requestCummunityItemsssWithCompletion:^(NSArray *array, NSString *url) {
        self.itemsArray = [array mutableCopy];
        self.nextUrl = url;
        [self reloadData];
        [self.pullToRefreshView stopAnimating];
    }];
}

-(void)loadMoreData{
    [WebUtils requestMoreCummunityItemWithUrl:self.nextUrl andCompletion:^(NSArray *array, NSString *url) {
        [self.itemsArray addObjectsFromArray:array];
        self.nextUrl = url;
        [self reloadData];
        [self.infiniteScrollingView stopAnimating];
    }];
}

-(void)loadDataFromTopicWithUrl:(NSString*)url{
    [WebUtils requestCummunityItemWithUrl:url andCompletion:^(id obj) {
        self.itemsArray = obj;
        [self reloadData];
        [self.pullToRefreshView stopAnimating];
    }];
}

#pragma mark - UITableViewDataSource delegateMethods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.itemsArray) {
        return 1;
    }else{
        return self.itemsArray.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CummunityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    
    CummunityItem *item = self.itemsArray[indexPath.row];
    cell.item = item;
    return cell;
}

#pragma mark - UITableViewDelegate delegateMethods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CummunityItem *item = self.itemsArray[indexPath.row];
    //这里加十的目的是空出cell之间的距离
    return item.cellHeight + 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CummunityItem *item = self.itemsArray[indexPath.row];
    CummunityDetailViewController *vc = [CummunityDetailViewController new];
    vc.item = item;
    [[self naviController] pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
