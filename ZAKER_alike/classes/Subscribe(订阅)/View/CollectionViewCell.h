//
//  CollectionViewCell.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/5.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCellItem.h"
@interface CollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)CollectionCellItem *item;

@property(nonatomic,assign,getter=isEditing)BOOL editing;

@property(nonatomic,assign)NSInteger channelIndex;

@property (nonatomic, weak) UIButton *tickButton;

@property (weak, nonatomic) IBOutlet UIButton *delButton;

@end
