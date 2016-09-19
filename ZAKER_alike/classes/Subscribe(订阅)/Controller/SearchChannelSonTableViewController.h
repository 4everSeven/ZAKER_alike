//
//  SearchChannelSonTableViewController.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/16.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchChannelGroupItem.h"
@interface SearchChannelSonTableViewController : UITableViewController
@property(nonatomic,strong)SearchChannelGroupItem *item;
@property(nonatomic,strong)NSArray *sons;
@end
