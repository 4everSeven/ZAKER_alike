//
//  WebUtils.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/2.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "WebUtils.h"
#import "HeaderRotationItem.h"
#import "SubArticleItem.h"
#import "ArticleContentItem.h"
#import "PromoteItem.h"
#import "FunSectionHeaderItem.h"
#import "HotArticleItem.h"
#import "TopicItem.h"
#import "CummunityItem.h"
#import "SearchSelectedTopItem.h"
#import "SearchSelectedChannelItem.h"
#import "SearchChannelGroupItem.h"
@implementation WebUtils
//得到关于订阅部分的头部滚动视图的数据
+(void)requestHeaderScrollWithCompletion:(Block)block{
    // 创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *requestURL = @"http://iphone.myzaker.com/zaker/follow_promote.php?_appid=iphone&_version=6.62";

    //发送请求
    [manager GET:requestURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取dict
        NSDictionary *listDict = responseObject[@"data"];
        NSArray *headerRotations = [HeaderRotationItem mj_objectArrayWithKeyValuesArray:listDict[@"list"]];
        block(headerRotations);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];


}

//得到订阅里面每个cell里的文章数据
+(void)requestSubArticleWithUrl:(NSString *)url andCompletion:(BBlock)block{
    // 创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"_appid"] = @"iphone";
    parameter[@"_udid"] = @"48E21014-9B62-48C3-B818-02F902C1619E";
    parameter[@"_net"] = @"wifi";
    parameter[@"_version"] = @"6.62";
    
    //发送请求
    [manager GET:url parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //获取dic
        NSDictionary *dataDic = responseObject[@"data"];
        
        NSArray *array = [SubArticleItem mj_objectArrayWithKeyValuesArray:dataDic[@"articles"]];
        NSString *url = dataDic[@"ipadconfig"][@"pages"][0][@"diy"][@"bgimage_url"];
        
        block(array,url);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

//得到具体的文章内容
+(void)requestWithUrl:(NSString*)url andCompletion:(Block)block{
    //创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //发送请求
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取dic
        NSDictionary *dataDic = responseObject[@"data"];
        
        ArticleContentItem *item = [ArticleContentItem mj_objectWithKeyValues:dataDic];
        
        block(item);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//得到玩乐模块的头部滚动视图数据
+(void)requestHeaderScrollForFunWithCompletion:(Block)block{
    //创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *requestURL = @"http://wl.myzaker.com/?_appid=iphone&_version=6.62&c=columns";
    //发送请求
    [manager GET:requestURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取dic
        NSDictionary *dataDic = responseObject[@"data"];
        
        NSArray *pics = [PromoteItem mj_objectArrayWithKeyValuesArray:dataDic[@"promote"]];
        
        block(pics);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//得到玩乐模块的网络数据
+(void)requestFunItemWithCompletion:(Block)block{
    //创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *requestURL = @"http://wl.myzaker.com/?_appid=iphone&_version=6.62&c=columns";
    //发送请求
    [manager GET:requestURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取dic
        NSDictionary *dataDic = responseObject[@"data"];
        
        NSArray *array = [FunSectionHeaderItem mj_keyValuesArrayWithObjectArray:dataDic[@"columns"]];
        
        block(array);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
    }];
}

//得到玩乐模块的网络数据
+(void)requestFunItemRealWithCompletion:(BBlock)block{
    //创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *requestURL = @"http://wl.myzaker.com/?_appid=iphone&_version=6.62&c=columns";
    //发送请求
    [manager GET:requestURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取dic
        NSDictionary *dataDic = responseObject[@"data"];
        
        NSArray *array = [FunSectionHeaderItem mj_keyValuesArrayWithObjectArray:dataDic[@"columns"]];
        
        FunSectionHeaderItem *item = [FunSectionHeaderItem mj_objectWithKeyValues:dataDic[@"info"]];
        
        NSString *url = item.next_url;
        block(array,url);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

    
}

//得到玩乐模块的更多网络数据
+(void)requestMoreFunItemWithUrl:(NSString*)url andCompletion:(BBlock)block{
    //创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
       [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取dic
        NSDictionary *dataDic = responseObject[@"data"];
        
        NSArray *array = [FunSectionHeaderItem mj_keyValuesArrayWithObjectArray:dataDic[@"columns"]];
        
        FunSectionHeaderItem *item = [FunSectionHeaderItem mj_objectWithKeyValues:dataDic[@"info"]];
        
        NSString *url = item.next_url;
        
        block(array,url);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//得到热点模块的网络数据
+(void)requestHotItemWithCompletion:(Block)block{
    //创建管理者
    AFHTTPSessionManager *manager= [AFHTTPSessionManager manager];
    
    NSString *requestUrl = @"http://v.juhe.cn/toutiao/index?type=&key=35ff671450906fa9046d81328e17c2bb";
    
    //发送请求
    [manager GET:requestUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // NSArray *dataArray = responseObject[@"data"];
        NSDictionary *resultDic = responseObject[@"result"];
        NSArray *array = [HotArticleItem mj_objectArrayWithKeyValuesArray:resultDic[@"data"]];
        
        block(array);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//得到社区的话题的网络数据
+(void)requestTopicItemWithCompletion:(Block)block{
    //创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *requestUrl = @"http://dis.myzaker.com/api/list_discussion.php";
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"_appid"] = @"iphone";
    para[@"_udid"] = @"48E21014-9B62-48C3-B818-02F902C1619E";
    para[@"_net"] = @"wifi";
    para[@"_version"] = @"6.62";
    
    [manager GET:requestUrl parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取dic
        NSDictionary *dataDic = responseObject[@"data"];
        
        NSArray *array = [TopicItem mj_objectArrayWithKeyValuesArray:dataDic[@"list"]];
        
        block(array);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//得到社区更多的话题的网络数据
+(void)requestMoreTopicItemWithCompletion:(Block)block{
    //创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *requestUrl = @"http://dis.myzaker.com/api/list_discussion.php";
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"_appid"] = @"iphone";
    para[@"_udid"] = @"48E21014-9B62-48C3-B818-02F902C1619E";
    para[@"_net"] = @"wifi";
    para[@"_version"] = @"6.46";
    para[@"act"] = @"more_discussion";
    para[@"except_recommend"] = @"Y";
    
    [manager GET:requestUrl parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取dic
        NSDictionary *dataDic = responseObject[@"data"];
        
        NSArray *array = [TopicItem mj_objectArrayWithKeyValuesArray:dataDic[@"list"]];
        
        block(array);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
////得到精选的网络数据
//+(void)requestCummunityItemWithCompletion:(Block)block{
//    //创建管理者
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    NSString *requestUrl = @"http://dis.myzaker.com/api/get_post_selected.php";
//    NSMutableDictionary *para = [NSMutableDictionary dictionary];
//    para[@"_appid"] = @"iphone";
//    para[@"_udid"] = @"48E21014-9B62-48C3-B818-02F902C1619E";
//    para[@"_net"] = @"wifi";
//    para[@"_version"] = @"6.46";
//    para[@"_lbs_city"] = @"%E5%B9%BF%E5%B7%9E";
//    
//    [manager GET:requestUrl parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //获取dic
//        NSDictionary *dataDic = responseObject[@"data"];
//        
//        NSArray *array = [CummunityItem mj_objectArrayWithKeyValuesArray:dataDic[@"posts"]];
//        block(array);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//}

//得到精选的网络数据
+(void)requestCummunityItemsssWithCompletion:(BBlock)block{
    //创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *requestUrl = @"http://dis.myzaker.com/api/get_post_selected.php";
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"_appid"] = @"iphone";
    para[@"_udid"] = @"48E21014-9B62-48C3-B818-02F902C1619E";
    para[@"_net"] = @"wifi";
    para[@"_version"] = @"6.46";
    para[@"_lbs_city"] = @"%E5%B9%BF%E5%B7%9E";

    [manager GET:requestUrl parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取dic
        NSDictionary *dataDic = responseObject[@"data"];
        
        NSArray *array = [CummunityItem mj_objectArrayWithKeyValuesArray:dataDic[@"posts"]];
        
        NSDictionary *infoDic = dataDic[@"info"];
        
        NSString *str = infoDic[@"next_url"];
        block(array,str);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//从社区的话题板块跳转
+(void)requestCummunityItemWithUrl:(NSString*)url andCompletion:(Block)block;{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *requstUrl = url;
    
    [manager GET:requstUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取dic
        NSDictionary *dataDic = responseObject[@"data"];
        
        NSArray *array = [CummunityItem mj_objectArrayWithKeyValuesArray:dataDic[@"posts"]];
        block(array);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//得到从订阅的搜索的精选的头部视图的网络数据
+(void)requestSearchSelectedTopItemWithCompletion:(Block)block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *requstUrl = @"http://iphone.myzaker.com/zaker/find_promotion.php?_appid=iphone";
    
    [manager GET:requstUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取dic
        NSDictionary *dataDic = responseObject[@"data"];
        NSMutableArray *array = [SearchSelectedTopItem mj_objectArrayWithKeyValuesArray:dataDic[@"list"][0]];
        [array addObjectsFromArray:[SearchSelectedTopItem mj_objectArrayWithKeyValuesArray:dataDic[@"list"][1]]];
        NSArray *itemsArray = array;
        block(itemsArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
    }];
}

//得到从订阅的搜索的精选的频道视图的网络数据
+(void)requestSearchSelectedChannelItemWithCompletion:(Block)block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *requstUrl = @"http://iphone.myzaker.com/zaker/find.php?_appid=iphone&_version=6.62";
    
    [manager GET:requstUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取dic
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *array = [SearchSelectedChannelItem mj_objectArrayWithKeyValuesArray:dataDic[@"list"]];
        block(array);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//得到从订阅的搜索的频道频道视图的网络数据
+(void)requestSearchChannelGroupWithCompletion:(Block)block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *requstUrl = @"http://iphone.myzaker.com/zaker/apps_v3.php?_appid=iphone&_version=6.62";
    
    [manager GET:requstUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取dic
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *array = [SearchChannelGroupItem mj_objectArrayWithKeyValuesArray:dataDic[@"datas"]];
        block(array);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
    }];
}

//得到社区的精选的更多的网络数据
+(void)requestMoreCummunityItemWithUrl:(NSString*)url andCompletion:(BBlock)block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取dic
        NSDictionary *dataDic = responseObject[@"data"];
        
        NSArray *array = [CummunityItem mj_objectArrayWithKeyValuesArray:dataDic[@"posts"]];
        
        NSDictionary *infoDic = dataDic[@"info"];
        
        NSString *str = infoDic[@"next_url"];
        block(array,str);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}

@end
