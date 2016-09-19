//
//  SubArtiListCell3.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/6.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCellItem.h"
@interface SubArtiListCell3 : UICollectionViewCell
@property (nonatomic, strong) CollectionCellItem *item;

@property (nonatomic, strong) NSArray *articlesArray;
@property (nonatomic, strong) NSString *topImageURL;
@property(nonatomic,strong)NSString *block_color;
@end
