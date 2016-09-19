//
//  TopicTableView.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/13.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "TopicTableView.h"
#import "TopicTableViewCell.h"
#import "WebUtils.h"
#import "TopicItem.h"
#import "SelectedTableView.h"
#import "SelectedViewController.h"
#import "UIView+Navi.h"
#import <SVPullToRefresh.h>
@interface TopicTableView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *itemsArray;
@property(nonatomic,assign)NSInteger loadMoreCount;

@end
static NSString *cellIdetifier = @"cell";
@implementation TopicTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"TopicTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdetifier];
        [self loadData];
    }
    __block __weak __typeof(&*self)weakSelf = self;
    [self addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
    return self;
    
    
}

#pragma mark - 方法 methods
//加载网络数据
-(void)loadData{
    [WebUtils requestTopicItemWithCompletion:^(id obj) {
        self.itemsArray = obj;
        [self reloadData];
    }];
}

//加载更多的网络数据，只能请求一次
-(void)loadMoreData{
    if (self.loadMoreCount == 1) {
        return;
    }
    [WebUtils requestMoreTopicItemWithCompletion:^(id obj) {
        [self.itemsArray addObjectsFromArray:obj];
        [self reloadData];
        self.loadMoreCount ++;
        [self.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark - UITableViewDataSource delegateMethods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.itemsArray) {
        return 1;
    }
    return self.itemsArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier forIndexPath:indexPath];
    TopicItem *item = self.itemsArray[indexPath.row];
    cell.item = item;
    return cell;
}

#pragma mark - UITableViewDelegate delegateMethods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicItem *item = self.itemsArray[indexPath.row];
    SelectedViewController *vc = [SelectedViewController new];
    vc.apiUrl = item.api_url;
    vc.naviTitle = item.title;
   // NSLog(@"fun api_url:%@",item.api_url);
    [[self naviController] pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
