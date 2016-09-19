//
//  TRComment.h
//  ITSNS
//
//  Created by tarena on 16/8/30.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRComment : NSObject
@property (nonatomic, copy)NSString *text;
@property (nonatomic, strong)BmobUser *user;
@property (nonatomic, copy)NSString *voicePath;
@property (nonatomic, strong)NSArray *imagePaths;
@property (nonatomic, strong)NSDate *date;

@property (nonatomic)float contentHeight;
@property (nonatomic)float imagesHeight;

@property (nonatomic, strong)BmobObject *bObj;
-(instancetype)initWithBmobObject:(BmobObject *)bObj;

-(NSString *)createdTime;

+(NSArray *)arrayWithBmobObjectArray:(NSArray *)array;
@end
