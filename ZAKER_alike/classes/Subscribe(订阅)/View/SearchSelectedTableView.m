//
//  SearchSelectedTableView.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/15.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SearchSelectedTableView.h"
#import "WebUtils.h"
#import "SearchSelectedTopItem.h"
#import "SearchSelectedTopView.h"
#import "SearchSelectedChannelItem.h"
#import "SearchSelectedChannelCell.h"
#import "CollectionCellItem.h"
#import <SVProgressHUD.h>
#import "SubArticleListViewController.h"
#import "UIView+Navi.h"
@interface SearchSelectedTableView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *topItems;
@property(nonatomic,strong)SearchSelectedTopView *topView;
@property(nonatomic,strong)NSArray *channelItems;
@end

@implementation SearchSelectedTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [SVProgressHUD show];
        [self loadTopData];
        [self topView];
        [self loadChannelData];
        self.delegate = self;
        self.dataSource = self;
        //分割线顶格
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        [self registerNib:[UINib nibWithNibName:@"SearchSelectedChannelCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//加载头部视图的数据
-(void)loadTopData{
    [WebUtils requestSearchSelectedTopItemWithCompletion:^(id obj) {
        self.topItems = obj;
        self.topView.items = self.topItems;
        //NSLog(@"%@",self.topItems);
        [self reloadData];
    }];
}

//加载频道视图的数据
-(void)loadChannelData{
    [WebUtils requestSearchSelectedChannelItemWithCompletion:^(id obj) {
        self.channelItems = obj;
        [self reloadData];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - UITableViewDataSource delegateMethods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.channelItems.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchSelectedChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    SearchSelectedChannelItem *item = self.channelItems[indexPath.row];
    
    cell.item = item;
    //cell.contentView.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - UITableViewDelegate delegateMethods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//加载头部视图
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SQSW, 20)];
    view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, 50, 15)];
    [view addSubview:label];
    label.textColor = [UIColor lightGrayColor];
    label.text = @"精选";
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     SearchSelectedChannelItem *item = self.channelItems[indexPath.row];
    CollectionCellItem *collectItem = [CollectionCellItem new];
    collectItem.api_url = item.api_url;
    collectItem.block_color = item.block_color;
    collectItem.title = item.title;
    SubArticleListViewController *vc = [SubArticleListViewController new];
    vc.item = collectItem;
    vc.api_url = [item valueForKey:@"api_url"];
    [[self naviController]pushViewController:vc animated:YES];
}

#pragma mark - 懒加载 lazyLoad
- (SearchSelectedTopView *)topView {
	if(_topView == nil) {
		_topView =  [[NSBundle mainBundle]loadNibNamed:@"SearchSelectedTopView" owner:nil options:nil].lastObject;
        _topView.frame = CGRectMake(0, 0, SQSW, 150);
        self.tableHeaderView = _topView;
	}
	return _topView;
}

@end
