//
//  CommentItem.h
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/17.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentItem : NSObject
@property (nonatomic, copy)NSString *text;
@property (nonatomic, strong)BmobUser *user;
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, strong)BmobObject *bObj;
@property(nonatomic,assign)CGFloat commentHeight;
-(instancetype)initWithBmobObject:(BmobObject *)bObj;

-(NSString *)createdTime;

+(NSArray *)arrayWithBmobObjectArray:(NSArray *)array;


@end
