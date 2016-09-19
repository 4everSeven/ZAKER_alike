//
//  SearchChannelGroupItem.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/16.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchChannelGroupItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *is_end;
@property (nonatomic, strong) NSString *father_id;
@property (nonatomic, strong) NSString *list_icon;
@property (nonatomic, strong) NSArray *sons;
@property (nonatomic, strong) NSArray *channels;
@end
