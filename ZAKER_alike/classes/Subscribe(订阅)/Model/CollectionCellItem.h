//
//  CollectionCellItem.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/5.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionCellItem : NSObject
@property (nonatomic, strong) NSString *need_userinfo;
//block 标题
@property (nonatomic, strong) NSString *block_title;
//block 图标颜色 注意是16进制
@property (nonatomic, strong) NSString *block_color;
//跳转链接
@property (nonatomic, strong) NSString *api_url;
//图标
@property (nonatomic, strong) NSString *pic;
//标题
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *pk;
@property (nonatomic, strong) NSString *is_end;
@property (nonatomic, strong) NSString *block_bg_key;
//大图
@property (nonatomic, strong) NSString *large_pic;

@end
