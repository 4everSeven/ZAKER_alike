//
//  FunTableViewCell.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/8.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "FunTableViewCell.h"
@interface FunTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *LGView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation FunTableViewCell


-(void)setItem:(FunItems *)item{
    _item = item;
    self.titleLabel.text = item.title;
    self.contentLabel.text = item.content;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:item.pic[@"url"]]];
    
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 3;
    [super setFrame:frame];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
