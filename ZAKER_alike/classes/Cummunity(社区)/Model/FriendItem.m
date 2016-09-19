//
//  FriendItem.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/17.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "FriendItem.h"

@implementation FriendItem
- (instancetype)initWithBmobObject:(BmobObject *)bObj
{
    self = [super init];
    if (self) {
        self.bObj = bObj;
        self.detail = [bObj objectForKey:@"detail"];
        self.user = [bObj objectForKey:@"user"];
        self.imagePaths = [bObj objectForKey:@"imagePaths"];
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

//计算cell的高度
-(CGFloat)totalHeight{
    //首先，计算label上面的高度
    CGFloat topToLabelHeight = 50;
    //计算label的高度
    CGFloat labelHeight = [self getHeighWithTitle:self.detail font:[UIFont systemFontOfSize:15] width:SQSW - 20];
    //计算图片所需的高度
    //判断图片的显示张数
    CGFloat picHeight = 0;
    if (!self.imagePaths) {
        picHeight = 0;
    }else if (self.imagePaths.count == 1){//一张图片
        
            picHeight = 300;
        
    }else if (self.imagePaths.count == 2){//2张图片
        picHeight = 183;
    }else if (self.imagePaths.count >= 3){//dayu3张图片
        picHeight = 123;
    }
    //计算底部视图的高度
    //CGFloat bottomHeight = 60;
    
    return topToLabelHeight + labelHeight + picHeight + 10 ;
}

- (CGFloat )getHeighWithTitle:(NSString *)title font:(UIFont *)font width:(float)width {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 3;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}
@end
