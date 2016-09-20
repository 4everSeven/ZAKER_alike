//
//  FriendItem.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/17.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendItem : NSObject

@property (nonatomic, copy)NSString *detail;
@property (nonatomic, strong)BmobUser *user;
@property (nonatomic, strong)NSArray *imagePaths;
@property (nonatomic, strong)NSDate *date;
//@property (nonatomic)float contentHeight;
//@property (nonatomic)float imagesHeight;
@property (nonatomic, strong)BmobObject *bObj;

@property(nonatomic,assign)CGFloat totalHeight;
@property(nonatomic,assign)CGFloat detailHeight;

-(instancetype)initWithBmobObject:(BmobObject *)bObj;

-(NSString *)createdTime;
@end
