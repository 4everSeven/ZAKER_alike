//
//  FunSectionHeaderItem.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/8.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunSectionHeaderItem : NSObject
@property (nonatomic, strong) NSDictionary *banner;

/** 模型数组 */
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *pk;
@property (nonatomic, strong) NSString *rank;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *show_more;
@property (nonatomic, strong) NSString *style;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSMutableArray *itemsArray;

//在info字典中
@property(nonatomic,strong)NSString *next_url;

@end
