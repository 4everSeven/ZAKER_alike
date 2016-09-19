//
//  SearchSelectedTopItem.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/16.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SearchSelectedTopItem.h"

@implementation SearchSelectedTopItem
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"api_url":@[@"block_info.api_url",@"block_topic.api_url"],
             
             };
}
@end
