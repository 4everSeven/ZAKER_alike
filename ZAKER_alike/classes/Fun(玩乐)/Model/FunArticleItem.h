//
//  FunArticleItem.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/12.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunArticleItem : NSObject
//"pk": "57d225399490cb954f000026",
//"title": "出门在外的花钱逻辑，谁还没有一套呢？| 好奇心研究所",
//"app_ids": "12249",
//"date": "",
//"auther_name": "好奇心研究所",
//"weburl": "http://iphone.myzaker.com/l.php?l=57d225399490cb954f000026",
//"is_full": "NO",
//"content": "",
//"full_url": "http://iphone.myzaker.com/zaker/article_mongo.php?app_id=12249&pk=57d225399490cb954f000026&m=1473412054",
//"full_arg": "_appid,_bsize",
//"tpl_info": {
//    "url": "http://zkres.myzaker.com/static/tpl/tpl_02.zip?t=201606281403",
//    "name": "tpl_02",
//    "update": "201606281403"
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *auther_name;
@property(nonatomic,strong)NSString *weburl;
@property(nonatomic,strong)NSString *full_url;
@end
