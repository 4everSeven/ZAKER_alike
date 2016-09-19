//
//  SearchSelectedTopView.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/15.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SearchSelectedTopView.h"
#import <UIButton+WebCache.h>
#import "SearchSelectedTopItem.h"
#import "CollectionCellItem.h"
#import "SearchChannelGroupItem.h"
#import "UIView+Navi.h"
#import "SearchChannelSonTableViewController.h"
#import "SubArticleListViewController.h"
//#import <AFNetworking.h>
@interface SearchSelectedTopView()
@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property(nonatomic,strong)NSArray *buttons;
@end
@implementation SearchSelectedTopView

-(void)setItems:(NSArray *)items{
    _items = items;
    [items enumerateObjectsUsingBlock:^(SearchSelectedTopItem  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.buttons[idx] sd_setBackgroundImageWithURL:[NSURL URLWithString:obj.promotion_img] forState:UIControlStateNormal];
        UIButton *button = self.buttons[idx];
        button.tag = 10+idx;
        //为按钮添加点击事件
        [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

-(void)clicked:(UIButton*)sender{
    if (sender.tag == 10) {//顶部视图
        SearchSelectedTopItem *item = self.items[0];
         SearchChannelGroupItem *groupItem = [SearchChannelGroupItem new];
        SearchChannelSonTableViewController *vc = [SearchChannelSonTableViewController new];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:item.api_url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dataDic = responseObject[@"data"];
            NSArray *array = [CollectionCellItem mj_objectArrayWithKeyValuesArray:dataDic[@"list"]];
            groupItem.sons = array;
            vc.sons = array;
           // NSLog(@"sons:%@",groupItem.sons);
            vc.item = groupItem;
               [[self naviController]pushViewController:vc animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"错误");
        }];
    }
    if (sender.tag == 11) {//左边的按钮
        SearchSelectedTopItem *item = self.items[1];
        CollectionCellItem *collectItem = [CollectionCellItem new];
        SubArticleListViewController *vc = [SubArticleListViewController new];
//        collectItem.block_color = item.block_info[]
        collectItem.api_url = item.api_url;
        vc.item = collectItem;
        vc.api_url = [item valueForKey:@"api_url"];
         [[self naviController]pushViewController:vc animated:YES];
    }
    if (sender.tag == 12) {//右边的按钮
        SearchSelectedTopItem *item = self.items[2];
        CollectionCellItem *collectItem = [CollectionCellItem new];
        SubArticleListViewController *vc = [SubArticleListViewController new];
        //        collectItem.block_color = item.block_info[]
        collectItem.api_url = item.api_url;
        vc.item = collectItem;
        vc.api_url = [item valueForKey:@"api_url"];
        [[self naviController]pushViewController:vc animated:YES];
    }
}


- (NSArray *)buttons {
	if(_buttons == nil) {
        _buttons = @[self.topButton,self.leftButton,self.rightButton];
	}
	return _buttons;
}

@end
