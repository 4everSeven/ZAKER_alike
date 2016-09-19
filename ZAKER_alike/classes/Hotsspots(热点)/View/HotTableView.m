//
//  HotTableView.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/10.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "HotTableView.h"
#import "HotArticleItem.h"
#import "WebUtils.h"
#import "hotCell1.h"
#import "HotCell2.h"
#import "WebViewForAdViewController.h"
#import <SVProgressHUD.h>
#import "UIView+Navi.h"
#import <SVPullToRefresh.h>
@interface HotTableView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *hotItems;


@end
@implementation HotTableView
//-(instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.delegate = self;
//        self.dataSource = self;
//        [SVProgressHUD show];
//        [self registerNib:[UINib nibWithNibName:@"hotCell1" bundle:nil] forCellReuseIdentifier:@"cell"];
//    }
//    return self;
//}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [SVProgressHUD show];
        [self loadData];
        [self registerNib:[UINib nibWithNibName:@"hotCell1" bundle:nil] forCellReuseIdentifier:@"cell"];
        [self registerNib:[UINib nibWithNibName:@"HotCell2" bundle:nil] forCellReuseIdentifier:@"cell2"];
         __block __weak __typeof(&*self)weakSelf = self;
        [self addPullToRefreshWithActionHandler:^{
            [weakSelf loadData];
        }];
    }
    return self;
}

-(void)loadData{
    [WebUtils requestHotItemWithCompletion:^(id obj) {
        self.hotItems = obj;
       // NSLog(@"count:%ld",self.hotItems.count);
        [self reloadData];
        [self.pullToRefreshView stopAnimating];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - UITableViewDataSource delegateMethods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hotItems.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    hotCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    HotArticleItem *item = self.hotItems[indexPath.row];
    cell.item = item;
    if (indexPath.row % 6 == 0) {
        HotCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        HotArticleItem *item2 = self.hotItems[indexPath.row];
        cell2.item = item2;
        return cell2;
    }else{
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate delegateMethods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 6 == 0 ) {
        return 140;
    }else{
        return 80;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HotArticleItem *item = self.hotItems[indexPath.row];
    WebViewForAdViewController *vc = [WebViewForAdViewController new];
    vc.urlPath = item.url;
    [[self naviController]pushViewController:vc animated:YES];
}


@end
