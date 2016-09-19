//
//  HotArticleItem.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/10.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotArticleItem : NSObject
//"title": "巫山云雨枉断肠：女摄影师Erika Lust记录的性爱",/*标题*/
//"date": "2016-06-13 10:31",/*时间*/
//"author_name": "POCO摄影",/*作者*/
//"thumbnail_pic_s": "http://09.imgmini.eastday.com/mobile/20160613/20160613103108_7b015493398e7fd13dda3a5c
//e315b1c8_1_mwpm_03200403.jpeg",/*图片1*/
//"thumbnail_pic_s02": "http://09.imgmini.eastday.com/mobile/20160613/20160613103108_7b015493398e7fd13dda3a5ce315
//b1c8_1_mwpl_05500201.jpeg",/*图片2*/
//"thumbnail_pic_s03": "http://09.imgmini.eastday.com/mobile/20160613/20160613103108_7b015493398e7fd13dda3a5ce315
//b1c8_1_mwpl_05500201.jpeg",/*图片3*/
//"url": "http://mini.eastday.com/mobile/160613103108379.html?qid=juheshuju",/*新闻链接*/
//"uniquekey": "160613103108379",/*唯一标识*/
//"type": "头条",/*类型一*/
//"realtype": "娱乐"/*类型二*/
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *author_name;
@property(nonatomic,strong)NSString *thumbnail_pic_s;
@property(nonatomic,strong)NSString *thumbnail_pic_s02;
@property(nonatomic,strong)NSString *thumbnail_pic_s03;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *block_color;
@end
