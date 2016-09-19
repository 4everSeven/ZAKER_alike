//
//  AirticleViewController.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/7.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubArticleItem.h"
#import "FunArticleItem.h"
@interface AirticleViewController : UIViewController
@property(nonatomic,strong)SubArticleItem *item;
@property(nonatomic,strong)FunArticleItem *funItem;
@end
