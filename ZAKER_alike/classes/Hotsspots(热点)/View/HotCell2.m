//
//  HotCell2.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/12.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "HotCell2.h"
@interface HotCell2()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView3;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;



@end
@implementation HotCell2

-(void)setItem:(HotArticleItem *)item{
    _item = item;
    UIImage *image = [UIImage imageNamed:@"IndicatorNetworkErrorHUD"];
    //设置图片
    [self.headImageView1 sd_setImageWithURL:[NSURL URLWithString:item.thumbnail_pic_s] placeholderImage:image];
    NSLog(@"pic1:%@\npic2:%@\npic3:%@",item.thumbnail_pic_s,item.thumbnail_pic_s02,item.thumbnail_pic_s03);
    [self.headImageView2 sd_setImageWithURL:[NSURL URLWithString:item.thumbnail_pic_s02] placeholderImage:image];
    [self.headImageView3 sd_setImageWithURL:[NSURL URLWithString:item.thumbnail_pic_s03] placeholderImage:image];
    
    //设置label
    self.titleLabel.text = item.title;
    self.authorLabel.text = item.author_name;
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
