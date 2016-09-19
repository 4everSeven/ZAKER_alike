//
//  SearchSelectedChannelItem.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/16.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchSelectedChannelItem : NSObject
//大标题
@property (nonatomic, strong) NSString *title;
//小标题
@property (nonatomic, strong) NSString *stitle;
//跳转链接
@property (nonatomic, strong) NSString *api_url;
//图标颜色
@property (nonatomic, strong) NSString *block_color;
//图片url
@property (nonatomic, strong) NSString *large_pic;
//该频道的类型
@property (nonatomic, strong) NSString *data_type;
@end
