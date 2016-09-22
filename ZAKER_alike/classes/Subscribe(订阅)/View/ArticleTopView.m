//
//  ArticleTopView.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/7.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "ArticleTopView.h"
#import "UIColor+Hex.h"
@interface ArticleTopView()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *authorLabel;
@end
@implementation ArticleTopView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 48, self.frame.size.width - 20, 24)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
        [self addSubview:self.titleLabel];
        
        self.authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 73, self.frame.size.width - 20, 20)];
        
        self.authorLabel.textColor = [UIColor whiteColor];
        self.authorLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.authorLabel];
    }
    return self;
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    CGRect frameTitle = self.titleLabel.frame;
//    frameTitle.size.width = self.frame.size.width - 20;
//    self.titleLabel.frame = frameTitle;
//    self.titleLabel.center = self.center;
//    
//    self.authorLabel.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame), self.frame.size.width - 20, 24);
//    
//}


-(void)setItem:(SubArticleItem *)item{
    _item = item;
    self.titleLabel.text = item.title;
    //[self.titleLabel sizeToFit];
//    self.titleLabel.center = self.center;
//    CGRect frame = self.titleLabel.frame;
//    frame.origin.y = 48;
//    self.titleLabel.frame = frame;
   // NSLog(@"frame:y:%f,h:%f",self.titleLabel.frame.origin.y,self.authorLabel.frame.size.height);
    self.authorLabel.text = item.auther_name;
    
    
    self.titleLabel.text = item.title;
    self.authorLabel.text = item.auther_name;
    self.backgroundColor = [UIColor colorWithHexString:item.block_color];
    if (item.block_color == nil) {
        self.backgroundColor = [UIColor blueColor];
    }
    
}

@end
