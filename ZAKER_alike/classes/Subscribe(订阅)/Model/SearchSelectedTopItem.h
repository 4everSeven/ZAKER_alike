//
//  SearchSelectedTopItem.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/16.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchSelectedTopItem : NSObject

@property (nonatomic, strong) NSDictionary *block_info;
@property (nonatomic, strong) NSDictionary *block_topic;
@property (nonatomic, strong) NSString *api_url;
@property (nonatomic, strong) NSString *promotion_img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@end
