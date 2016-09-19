//
//  ArticleContentItem.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/7.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleContentItem : NSObject
//具体的文章内容
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *content_format;
@property (nonatomic, strong) NSString *disclaimer;
@property (nonatomic, strong) NSArray *media;
@end
