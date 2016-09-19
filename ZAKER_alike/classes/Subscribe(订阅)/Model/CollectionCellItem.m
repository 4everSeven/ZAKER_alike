//
//  CollectionCellItem.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/5.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "CollectionCellItem.h"

//@property (nonatomic, strong) NSString *need_userinfo;
////block 标题
//@property (nonatomic, strong) NSString *block_title;
////block 图标颜色 注意是16进制
//@property (nonatomic, strong) NSString *block_color;
////跳转链接
//@property (nonatomic, strong) NSString *api_url;
////图标
//@property (nonatomic, strong) NSString *pic;
////标题
//@property (nonatomic, strong) NSString *title;
//
//@property (nonatomic, strong) NSString *pk;
//@property (nonatomic, strong) NSString *is_end;
//@property (nonatomic, strong) NSString *block_bg_key;
////大图
//@property (nonatomic, strong) NSString *large_pic;
@implementation CollectionCellItem
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.need_userinfo forKey:@"need_userinfo"];
    [aCoder encodeObject:self.block_title forKey:@"block_title"];
    [aCoder encodeObject:self.block_color forKey:@"block_color"];
    [aCoder encodeObject:self.api_url forKey:@"api_url"];
    [aCoder encodeObject:self.pic forKey:@"pic"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.pk forKey:@"pk"];
    [aCoder encodeObject:self.is_end forKey:@"is_end"];
    [aCoder encodeObject:self.block_bg_key forKey:@"block_bg_key"];
    [aCoder encodeObject:self.large_pic forKey:@"large_pic"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.need_userinfo = [aDecoder decodeObjectForKey:@"need_userinfo"];
        self.block_title = [aDecoder decodeObjectForKey:@"block_title"];
        self.block_color = [aDecoder decodeObjectForKey:@"block_color"];
        self.api_url = [aDecoder decodeObjectForKey:@"api_url"];
        self.pic = [aDecoder decodeObjectForKey:@"pic"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.pk = [aDecoder decodeObjectForKey:@"pk"];
        self.is_end = [aDecoder decodeObjectForKey:@"is_end"];
        self.block_bg_key = [aDecoder decodeObjectForKey:@"block_bg_key"];
        self.large_pic = [aDecoder decodeObjectForKey:@"large_pic"];
        
    }
    return self;
    
}
@end
