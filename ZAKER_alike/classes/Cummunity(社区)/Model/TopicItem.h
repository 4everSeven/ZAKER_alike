//
//  TopicItem.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/13.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicItem : NSObject
//跳转请求链接
@property (nonatomic, strong) NSString *api_url;
@property (nonatomic, strong) NSString *large_pic;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *pk;
@property (nonatomic, strong) NSString *post_count;
@property (nonatomic, strong) NSString *subscribe_count;
//小标题
@property (nonatomic, strong) NSString *stitle;
//标题
@property (nonatomic, strong) NSString *title;
@end
