//
//  SearchChannelCell.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/16.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SearchChannelCell.h"
@interface SearchChannelCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;

@end
@implementation SearchChannelCell

-(void)setItem:(SearchChannelGroupItem *)item{
    _item = item;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.list_icon]];
    self.channelNameLabel.text = item.title;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
