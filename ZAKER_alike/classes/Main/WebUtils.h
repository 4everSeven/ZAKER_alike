//
//  WebUtils.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/2.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^Block)(id obj);
typedef void(^BBlock)(NSArray *array,NSString *url);

@interface WebUtils : NSObject
//得到关于订阅部分的头部滚动视图的数据
+(void)requestHeaderScrollWithCompletion:(Block)block;
//得到订阅里面每个cell里的文章数据
+(void)requestSubArticleWithUrl:(NSString*)url andCompletion:(BBlock)block;
//得到具体的文章内容
+(void)requestWithUrl:(NSString*)url andCompletion:(Block)block;
//得到玩乐模块的头部滚动视图数据
+(void)requestHeaderScrollForFunWithCompletion:(Block)block;
//得到玩乐模块的网络数据
+(void)requestFunItemWithCompletion:(Block)block;
//得到玩乐模块的网络数据
+(void)requestFunItemRealWithCompletion:(BBlock)block;
//得到玩乐模块的更多网络数据
+(void)requestMoreFunItemWithUrl:(NSString*)url andCompletion:(BBlock)block;
//得到热点模块的网络数据
+(void)requestHotItemWithCompletion:(Block)block;
//得到社区的话题的网络数据
+(void)requestTopicItemWithCompletion:(Block)block;
//得到社区更多的话题的网络数据
+(void)requestMoreTopicItemWithCompletion:(Block)block;
//得到精选的网络数据
//+(void)requestCummunityItemWithCompletion:(Block)block;
//从社区的话题板块跳转
+(void)requestCummunityItemWithUrl:(NSString*)url andCompletion:(Block)block;
//得到从订阅的搜索的精选的头部视图的网络数据
+(void)requestSearchSelectedTopItemWithCompletion:(Block)block;
//得到从订阅的搜索的精选的频道视图的网络数据
+(void)requestSearchSelectedChannelItemWithCompletion:(Block)block;
//得到从订阅的搜索的频道频道视图的网络数据
+(void)requestSearchChannelGroupWithCompletion:(Block)block;
//得到社区的精选的更多的网络数据
+(void)requestMoreCummunityItemWithUrl:(NSString*)url andCompletion:(BBlock)block;
//得到精选的网络数据
+(void)requestCummunityItemsssWithCompletion:(BBlock)block;
@end
