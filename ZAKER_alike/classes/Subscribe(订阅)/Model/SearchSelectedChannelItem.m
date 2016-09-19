//
//  SearchSelectedChannelItem.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/16.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SearchSelectedChannelItem.h"

@implementation SearchSelectedChannelItem
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    
    return @{
             @"title" : @"block_info.title",
             @"stitle" : @"block_info.stitle",
             @"pic" : @"block_info.pic",
             @"large_pic" : @"block_info.large_pic",
             @"api_url" : @"block_info.api_url",
             @"data_type" : @"block_info.data_type",
             @"block_color" : @"block_info.block_color",
             
             };
}
@end
