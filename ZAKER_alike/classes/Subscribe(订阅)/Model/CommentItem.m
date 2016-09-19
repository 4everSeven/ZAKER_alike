//
//  CommentItem.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/17.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "CommentItem.h"

@implementation CommentItem
+(NSArray *)arrayWithBmobObjectArray:(NSArray *)array{
    NSMutableArray *comments = [NSMutableArray array];
    for (BmobObject *bObj in array) {
        CommentItem *c = [[CommentItem alloc]initWithBmobObject:bObj];
        [comments addObject:c];
    }
    return comments;
    
}
- (instancetype)initWithBmobObject:(BmobObject *)bObj
{
    self = [super init];
    if (self) {
        self.bObj = bObj;
        self.text = [bObj objectForKey:@"text"];
        self.user = [bObj objectForKey:@"user"];
        self.date = bObj.updatedAt;
        
    }
    return self;
}

-(NSString *)createdTime{
    
    
    
    //得到微博发送的Date对象
    NSDate *createDate = self.date;
    NSDate *nowDate = [NSDate new];
    //微博时间
    long createTime = [createDate timeIntervalSince1970];
    //当前时间
    long nowTime = [nowDate timeIntervalSince1970];
    
    long time = nowTime - createTime;
    
    if (time<60) {
        return @"刚刚";
    }else if (time>=60&&time<3600){
        
        return [NSString stringWithFormat:@"%ld分钟前",time/60];
    }else if (time>=3600&&time<3600*24){
        
        return [NSString stringWithFormat:@"%ld小时前",time/3600];
    }else{
        NSDateFormatter *f = [NSDateFormatter new];
        f.dateFormat = @"MM月dd日 HH:mm";
        return [f stringFromDate:createDate];
        
    }

}

-(CGFloat)commentHeight{
    //首先，计算label上面的高度
    CGFloat topToLabelHeight = 50;
    //计算label的高度
    CGFloat labelHeight = [self getHeighWithTitle:self.text font:[UIFont systemFontOfSize:15] width:SQSW - 20];
    
    return topToLabelHeight + labelHeight;
}

- (CGFloat )getHeighWithTitle:(NSString *)title font:(UIFont *)font width:(float)width {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

@end
