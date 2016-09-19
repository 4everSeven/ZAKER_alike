//
//  SubArticleListViewController.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/5.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCellItem.h"

@interface SubArticleListViewController : UIViewController
@property(nonatomic,strong)CollectionCellItem *item;
@property(nonatomic,strong)NSString *api_url;
@property(nonatomic,assign)BOOL goFromSubArticle;
@property(nonatomic,strong)NSString *block_color;
@end
