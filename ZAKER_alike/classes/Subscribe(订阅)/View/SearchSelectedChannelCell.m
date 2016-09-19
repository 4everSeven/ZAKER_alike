//
//  SearchSelectedChannelCell.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/16.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SearchSelectedChannelCell.h"
#import "UIColor+Hex.h"
@interface SearchSelectedChannelCell()
@property (weak, nonatomic) IBOutlet UIImageView *channelImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;


@end
@implementation SearchSelectedChannelCell

-(void)setItem:(SearchSelectedChannelItem *)item{
    _item = item;
     // 加载图片, 并变换颜色
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.large_pic]];
    UIImage *image = [UIImage imageWithData:data];
    self.channelImageView.tintColor = [UIColor colorWithHexString:item.block_color];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.channelImageView.image = image;
    self.channelImageView.layer.cornerRadius = self.channelImageView.frame.size.height * 0.415;
    self.channelImageView.layer.masksToBounds = YES;
    self.channelImageView.layer.borderWidth = 0.5;
    self.channelImageView.layer.borderColor = [UIColor colorWithHexString:item.block_color].CGColor;
//NSLog(@"item.pic:%@",item.large_pic);
    self.titleLabel.text = item.title;
    self.subTitleLabel.text = item.stitle;
    
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
