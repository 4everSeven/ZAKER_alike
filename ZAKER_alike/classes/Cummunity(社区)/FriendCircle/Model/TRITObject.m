//
//  TRITObject.m
//  ITSNS
//
//  Created by tarena on 16/8/26.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "YYTextView.h"
#import "TRITObject.h"

@implementation TRITObject
- (instancetype)initWithBmobObject:(BmobObject *)bObj
{
    self = [super init];
    if (self) {
        self.bObj = bObj;
        self.title = [bObj objectForKey:@"title"];
         self.detail = [bObj objectForKey:@"detail"];
         self.user = [bObj objectForKey:@"user"];
         self.voicePath = [bObj objectForKey:@"voicePath"];
         self.imagePaths = [bObj objectForKey:@"imagePaths"];
        self.location = [bObj objectForKey:@"location"];
        self.showCount = [[bObj objectForKey:@"showCount"]intValue];
        self.commentCount = [[bObj objectForKey:@"commentCount"]intValue];
        
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


-(float)contentHeight{
    
    if (_contentHeight==0) {
        YYTextView *tv = [[YYTextView alloc]initWithFrame:CGRectMake(LYMargin, 0, LYSW-2*LYMargin, 0)];
 
        tv.font = [UIFont systemFontOfSize:15];
        //计算标题高度
        if (self.title.length>0) {
            tv.text = self.title;
            _contentHeight += tv.textLayout.textBoundingSize.height;
        }
        //计算详情高度
        if (self.detail.length>0) {
            tv.font = [UIFont systemFontOfSize:12];
            tv.text = self.detail;
            _contentHeight += tv.textLayout.textBoundingSize.height;
        }
      //加上图片的高度
        if (self.imagePaths.count>0) {
            _contentHeight += self.imagesHeight;
        }
        
        _contentHeight += 3*LYMargin;
        
        
        
        
    }
    
    return _contentHeight;
    
}

-(float)imagesHeight{
    
    if (_imagesHeight==0) {
        if (self.imagePaths.count==1) {
            _imagesHeight = 200;
        }else{
            NSInteger line = self.imagePaths.count%3==0?self.imagePaths.count/3:self.imagePaths.count/3+1;
            
            _imagesHeight = line *LYImageSize + (line-1)*LYMargin;
            
            
        }
    }
    
    return _imagesHeight;
    
}
-(void)addCommentCount{
    // 字段 commentCount
    [self.bObj incrementKey:@"commentCount"];
    
    // 本地数量也需要增加
    self.commentCount++;
    
    
    //更新时对象类型的字段需要重新赋值
    [self.bObj setObject:self.user forKey:@"user"];
    
    [self.bObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"增加评论量成功！");
            
        }
        
    }];

    
    
}
-(void)addShowCount{
    //让某个整数字段 递增1
    [self.bObj incrementKey:@"showCount"];
    
    // 本地数量也需要增加
    self.showCount++;
    
    
    //更新时对象类型的字段需要重新赋值
    [self.bObj setObject:self.user forKey:@"user"];

    
    
    //    Score
    [self.bObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"增加浏览量成功！");
           
        }
        
    }];
    
    
}
@end
