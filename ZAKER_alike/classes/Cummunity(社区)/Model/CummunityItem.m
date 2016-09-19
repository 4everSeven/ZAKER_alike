//
//  CummunityItem.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/13.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "CummunityItem.h"

@implementation CummunityItem
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"icon" : @"auther.icon",
             @"name" : @"auther.name",
             @"uid" : @"auther.uid",
             @"user_flag" : @"auther.user_flag[0].pic",
             @"is_official" : @"auther.is_official",
             
             @"discussion_info_url" : @"special_info.discussion_info_url",
             @"discussion_title" : @"special_info.discussion_title",
             @"medias_count" : @"special_info.medias_count",
             @"item_type" : @"special_info.item_type",
             
             @"m_url" : @"medias[0].m_url",
             @"medias_height" : @"medias[0].h",
             @"medias_weight" : @"medias[0].w",
             @"min_url" : @"medias[0].min_url",
             @"raw_url" : @"medias[0].raw_url",
             @"s_url" : @"medias[0].s_url",
             @"url" : @"medias[0].url",
             
             @"sec_min_url" : @"medias[1].url",
             @"thr_min_url" : @"medias[2].url",
             
             };
}

-(CGFloat)cellHeight{
    //首先，计算label上面的高度
    CGFloat topToLabelHeight = 50;
    //计算label的高度
    CGFloat labelHeight = [self getHeighWithTitle:self.content font:[UIFont systemFontOfSize:15] width:SQSW - 20];
    //计算图片所需的高度
    //判断图片的显示张数
    CGFloat picHeight = 0;
    if (!self.m_url) {
        picHeight = 0;
    }else if (self.item_type.intValue == 1){//一张图片
        picHeight = SQSW * self.medias_height.intValue / self.medias_weight.intValue;
        if (picHeight > 300) {
            picHeight = 300;
        }
    }else if (self.item_type.intValue == 2){//2张图片
        picHeight = 183;
            }else if (self.item_type.intValue == 3){//3张图片
        picHeight = 123;
            }
    //计算底部视图的高度
    CGFloat bottomHeight = 60;
    
    return topToLabelHeight + labelHeight + picHeight + bottomHeight;
}

- (CGFloat )getHeighWithTitle:(NSString *)title font:(UIFont *)font width:(float)width {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 3;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}
@end
