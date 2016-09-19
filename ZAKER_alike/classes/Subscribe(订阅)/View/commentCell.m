//
//  commentCell.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/17.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "commentCell.h"
@interface commentCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;



@end
@implementation commentCell

- (void)awakeFromNib {
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width / 2;
    self.headerImageView.layer.masksToBounds = YES;
}

-(void)setItem:(CommentItem *)item{
    _item = item;
    self.nameLabel.text = [item.user objectForKey:@"username"];
    self.timeLabel.text = [item createdTime];
    self.detailLabel.text = item.text;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[item.user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
