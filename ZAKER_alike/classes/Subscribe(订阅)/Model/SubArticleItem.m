//
//  SubArticleItem.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/5.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SubArticleItem.h"

@implementation SubArticleItem
//修改名字
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"open_type" : @"special_info.open_type",
             @"icon_url" : @"special_info.icon_url",
             @"discussionTitle" : @"special_info.discussion.title",
             @"discussionApi_url" : @"special_info.discussion.api_url",
             
             };
}
@end
