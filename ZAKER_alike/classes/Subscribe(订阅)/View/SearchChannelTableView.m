//
//  SearchChannelTableView.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/16.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SearchChannelTableView.h"
#import "SearchChannelGroupItem.h"
#import "WebUtils.h"
#import "SearchChannelCell.h"
#import <SVProgressHUD.h>
#import "UIView+Navi.h"
#import "SearchChannelSonTableViewController.h"
#import "SonChannelItem.h"
#import "CollectionCellItem.h"
@interface SearchChannelTableView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *itemsArray;

@end
@implementation SearchChannelTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [SVProgressHUD show];
        self.delegate = self;
        self.dataSource = self;
        [self loadData];
        [self registerNib:[UINib nibWithNibName:@"SearchChannelCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        //cell的分割线顶格
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}

-(void)loadData{
    [WebUtils requestSearchChannelGroupWithCompletion:^(id obj) {
        self.itemsArray = obj;
        [self reloadData];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - UITableViewDataSource delegateMethods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemsArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    SearchChannelGroupItem *item = self.itemsArray[indexPath.row];
    cell.item = item;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchChannelGroupItem *item = self.itemsArray[indexPath.row];
    SearchChannelSonTableViewController *vc = [SearchChannelSonTableViewController new];
    NSArray *sons = [CollectionCellItem mj_keyValuesArrayWithObjectArray:item.sons];
    vc.sons = sons;
    [[self naviController]pushViewController:vc animated:YES];
}


@end
