//
//  FunItems.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/8.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleContentItem.h"
#import "SubArticleItem.h"
@interface FunItems : NSObject
@property (nonatomic, strong) NSDictionary *article;
@property (nonatomic, strong) NSString *click_stat_url;
@property (nonatomic, strong) NSDictionary *pic;
@property (nonatomic, strong) NSString *pk;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *content;
@end
