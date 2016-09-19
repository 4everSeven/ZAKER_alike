//
//  FunArticleTopView.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/12.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "FunArticleTopView.h"
@interface FunArticleTopView()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *authorLabel;
@end
@implementation FunArticleTopView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 35, self.frame.size.width - 100, 90)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 0;
       // [self.titleLabel sizeToFit];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        
        [self addSubview:self.titleLabel];
        
        self.authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(self.titleLabel.frame), self.frame.size.width - 100, 20)];
        self.authorLabel.textAlignment = NSTextAlignmentCenter;
        self.authorLabel.textColor = [UIColor lightGrayColor];
        self.authorLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.authorLabel];
    }
    return self;
}

-(void)setItem:(FunArticleItem *)item{
    _item = item;
    self.titleLabel.text = item.title;

      self.authorLabel.text = [NSString stringWithFormat:@"----- %@ -----",item.auther_name];
    
//    self.titleLabel.text = item.title;
//    self.authorLabel.text = item.auther_name;
    //self.backgroundColor = [UIColor colorWithHexString:item.block_color];
    self.backgroundColor = [UIColor whiteColor];
}


@end
