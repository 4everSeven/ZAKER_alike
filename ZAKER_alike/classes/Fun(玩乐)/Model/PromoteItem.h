//
//  PromoteItem.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/8.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
#import "ArticleContentItem.h"
@interface PromoteItem : NSObject
//"pk": "57cf8cdc9490cb8906000038",
//"promotion_img": "http://zkres.myzaker.com/img_upload/editor/img_upload/20160907/up_1473220170_74832_W750H320S62717.jpg",
//"img_height": "320",
//"img_width": "750",
//"title": "",
//"end_time": "1473609600",
//"type": "a",
//"pop_type": "",
//"hide_mask": "N",
//"ads_stat_url": "http://adm.myzaker.com/ads_stat.php?ads_id=57cf8cdc9490cb8906000038&position=weekend_promotion",
//"start_time": "1473220800",
//"article": {
//    "pk": "57cf7f359490cb7106000030",
//    "title": "一周新片指南 从国外引进了猫、狗和鲨鱼",
//    "app_ids": "12112",
//    "date": "2016-09-12 00:00:00",
//    "auther_name": "玩乐",
//    "weburl": "http://iphone.myzaker.com/l.php?l=57cf7f359490cb7106000030",
//    "is_full": "NO",
//    "content": "",
//    "full_url": "http://iphone.myzaker.com/zaker/article_mongo.php?app_id=12112&pk=57cf7f359490cb7106000030&m=1473216309",
//    "full_arg": "_appid,_bsize",
//    "type": "web3",
//    "special_info": {
//        "open_type": "web3",
//        "need_user_info": "Y",
//        "web_url": "http://iphone.myzaker.com/zaker/ad_article.php?_id=57cf8cdc9490cb8906000038&title=%E4%B8%80%E5%91%A8%E6%96%B0%E7%89%87%E6%8C%87%E5%8D%97+%E4%BB%8E%E5%9B%BD%E5%A4%96%E5%BC%95%E8%BF%9B%E4%BA%86%E7%8C%AB%E3%80%81%E7%8B%97%E5%92%8C%E9%B2%A8%E9%B1%BC&open_type=web3&_appid=iphone&need_userinfo=Y&url=http%3A%2F%2Fwlwap.myzaker.com%2F%3Fmodel%3Dtopic%26wl_topic_id%3D57cf7f359490cb710600002f%26target%3Dweb3",
//        "show_jingcai": "N"
//    },
//    "hide_original_text_btn": "Y"
//}
@property(nonatomic,strong)NSString *promotion_img;
@property(nonatomic,strong)NSString *img_height;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSDictionary *web;
@property(nonatomic,strong)NSDictionary *article;
@end
