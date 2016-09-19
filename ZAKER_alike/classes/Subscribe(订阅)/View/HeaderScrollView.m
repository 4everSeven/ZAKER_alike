//
//  HeaderScrollView.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/2.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "HeaderScrollView.h"
#import "HeaderRotationItem.h"
#import "WebUtils.h"
#import "PromoteItem.h"
#import "UIView+Navi.h"
#import "WebViewForAdViewController.h"
#import "SubArticleListViewController.h"
@interface HeaderScrollView()<SDCycleScrollViewDelegate>
@property(nonatomic,strong)SDCycleScrollView *sdcycle;
@property(nonatomic,strong)SDCycleScrollView *sdcycleForFun;
//用来装获取的网络数据
@property(nonatomic,strong)NSArray *array;
//用来装玩乐模块的网络数据
@property(nonatomic,strong)NSArray *funArray;
@property(nonatomic,strong)NSMutableArray *actuallyArray;
@end
@implementation HeaderScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self sdcycle];
        
    }
    return self;
}

-(instancetype)initWithFrameForFun:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self sdcycleForFun];
    }
    return self;
}



//创建封装好的循环滚动播放页
- (SDCycleScrollView *)sdcycle {
	if(_sdcycle == nil) {
		_sdcycle = [[SDCycleScrollView alloc] initWithFrame:self.bounds];
        [WebUtils requestHeaderScrollWithCompletion:^(id obj) {
            //NSArray *items = [obj mutableCopy];
            self.array = obj;
            self.actuallyArray = [NSMutableArray array];
            NSMutableArray *imageUrls = [NSMutableArray array];
            NSMutableArray *titleUrls = [NSMutableArray array];
            for (HeaderRotationItem *item in self.array) {
                NSDictionary *tag = item.tag_info;
                if ([tag[@"text"] isEqualToString:@"频道"] || [tag[@"text"] isEqualToString:@"广告"] ) {
                    [imageUrls addObject:item.promotion_img];
                    [titleUrls addObject:item.title];
                    [self.actuallyArray addObject:item];
                }
            //[self.url addObject:item.block_api_url];
            }
            _sdcycle.imageURLStringsGroup = imageUrls;
            _sdcycle.titlesGroup = titleUrls;
            _sdcycle.autoScrollTimeInterval = 2.5;
        }];
        _sdcycle.delegate = self;
        _sdcycle.currentPageDotImage = [UIImage imageNamed:@"HeadLineCurrentPageIndicator"];
        _sdcycle.pageDotImage = [UIImage imageNamed:@"HeadLinePageIndicator"];
        [self addSubview:_sdcycle];
	}
	return _sdcycle;
}

//循环滚动播放页（玩乐模块）
-(SDCycleScrollView *)sdcycleForFun{
    if(_sdcycleForFun == nil) {
        _sdcycleForFun = [[SDCycleScrollView alloc] initWithFrame:self.bounds];
       [WebUtils requestHeaderScrollForFunWithCompletion:^(id obj) {
           self.funArray = obj;
           NSMutableArray *imageUrls = [NSMutableArray array];
           for (PromoteItem *item in self.funArray) {
               [imageUrls addObject:item.promotion_img];
           }
           _sdcycleForFun.imageURLStringsGroup = imageUrls;
           _sdcycleForFun.autoScrollTimeInterval = 2.5;
       }];
        _sdcycleForFun.delegate = self;
        _sdcycleForFun.currentPageDotImage = [UIImage imageNamed:@"HeadLineCurrentPageIndicator"];
        _sdcycleForFun.pageDotImage = [UIImage imageNamed:@"HeadLinePageIndicator"];
        
        [self addSubview:_sdcycleForFun];
    }
    return _sdcycleForFun;
}

//点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (cycleScrollView == self.sdcycle) {
       // HeaderRotationItem *item = self.array[index];
        HeaderRotationItem *item = self.actuallyArray[index];
        NSDictionary *tag = item.tag_info;
        //如果是广告，跳转到webVC
        if ([tag[@"text"] isEqualToString:@"广告"]) {
            WebViewForAdViewController *vc = [WebViewForAdViewController new];
            NSDictionary *web = item.web;
            vc.urlPath = web[@"url"];
            [[self naviController] pushViewController:vc animated:YES];
        }
        //如果是频道，跳转到频道
        if ([tag[@"text"] isEqualToString:@"频道"]) {
            SubArticleListViewController *vc = [SubArticleListViewController new];
            vc.api_url = item.block_api_url;
             [[self naviController] pushViewController:vc animated:YES];
        }
    }
}

@end
