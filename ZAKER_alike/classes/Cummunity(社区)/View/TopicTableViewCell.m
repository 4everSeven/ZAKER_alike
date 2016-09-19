//
//  TopicTableViewCell.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/13.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "TopicTableViewCell.h"
@interface TopicTableViewCell()

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButton;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@end
@implementation TopicTableViewCell

-(void)setItem:(TopicItem *)item{
    _item = item;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.pic]];
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
