//
//  HeaderScrollViewForFun.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/15.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "HeaderScrollViewForFun.h"
#import <SDCycleScrollView.h>
#import "WebUtils.h"
#import "PromoteItem.h"
#import "UIView+Navi.h"
#import "WebViewForAdViewController.h"
@interface HeaderScrollViewForFun()<SDCycleScrollViewDelegate>
@property(nonatomic,strong)SDCycleScrollView *sdcycleForFun;

//用来装获取的网络数据
@property(nonatomic,strong)NSArray *funArray;

@end
@implementation HeaderScrollViewForFun

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self sdcycleForFun];
        
    }
    return self;
}//循环滚动播放页（玩乐模块）

////循环滚动播放页（玩乐模块）
//-(SDCycleScrollView *)sdcycleForFun{
//    if(_sdcycleForFun == nil) {
//        _sdcycleForFun = [[SDCycleScrollView alloc] initWithFrame:self.bounds];
//        [WebUtils requestHeaderScrollForFunWithCompletion:^(id obj) {
//            self.funArray = obj;
//            NSMutableArray *imageUrls = [NSMutableArray array];
//            for (PromoteItem *item in self.funArray) {
//                [imageUrls addObject:item.promotion_img];
//            }
//            _sdcycleForFun.imageURLStringsGroup = imageUrls;
//            _sdcycleForFun.autoScrollTimeInterval = 2.5;
//        }];
//        _sdcycleForFun.delegate = self;
//        _sdcycleForFun.currentPageDotImage = [UIImage imageNamed:@"HeadLineCurrentPageIndicator"];
//        _sdcycleForFun.pageDotImage = [UIImage imageNamed:@"HeadLinePageIndicator"];
//        
//        [self addSubview:_sdcycleForFun];
//    }
//    return _sdcycleForFun;
//}

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
            //NSLog(@"image:%@",_sdcycleForFun.imageURLStringsGroup);
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
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    PromoteItem *item = self.funArray[index];
    //跳转
    WebViewForAdViewController *vc = [WebViewForAdViewController new];
    
    if ([item.type isEqualToString:@"a"]) {
        NSDictionary *air = item.article;
       NSString *webUrl = air[@"weburl"];
        vc.urlPath = webUrl;
    }else{
        NSDictionary *web = item.web;
        NSString *webUrl = web[@"url"];
        vc.urlPath = webUrl;
    }
    
    [[self naviController]pushViewController:vc animated:YES];
}






@end
