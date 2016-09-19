//
//  hotCell1.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/10.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "hotCell1.h"
#import <UIImageView+WebCache.h>
@interface hotCell1()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@end

@implementation hotCell1

-(void)setItem:(HotArticleItem *)item{
    _item = item;
    UIImage *image = [UIImage imageNamed:@"IndicatorNetworkErrorHUD"];
    //设置图片
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:item.thumbnail_pic_s] placeholderImage:image];
    //设置label
    self.titleLabel.text = item.title;
    self.authorLabel.text = item.author_name;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
