//
//  CummunityTableViewCell.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/13.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "CummunityTableViewCell.h"
@interface CummunityTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *tabButton;
@property (weak, nonatomic) IBOutlet UIButton *eyeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@end
@implementation CummunityTableViewCell

-(void)setItem:(CummunityItem *)item{
    _item = item;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.icon]];
    self.nickNameLabel.text = item.name;
    if (!item.user_flag) {
        self.tagImageView.hidden = YES;
    }else{
        [self.tagImageView sd_setImageWithURL:[NSURL URLWithString:item.user_flag]];
    }
    if (!item.discussion_title) {
        self.tabButton.hidden = YES;
    }else{
        [self.tabButton setTitle:item.discussion_title forState:UIControlStateNormal];
        self.tabButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    self.contentLabel.text = item.content;
    self.timeLabel.text = [self dateString:item.list_date];
    if (![self dateString:item.list_date]) {
        self.timeLabel.text = @"几天前";
    }
    [self.eyeButton setTitle:[NSString stringWithFormat:@"%.1fK",item.hot_num.floatValue / 1000] forState:UIControlStateNormal];
    [self.commentButton setTitle:item.comment_count forState:UIControlStateNormal];
    [self.likeButton setTitle:item.like_num forState:UIControlStateNormal];
    
    for (UIView *view in self.picView.subviews) {
        [view removeFromSuperview];
    }
    
    //判断图片的显示张数
    if (!item.m_url) {
        self.picViewHeight.constant = 0;
    }else if (item.item_type.intValue == 1){//一张图片
        self.picViewHeight.constant = SQSW * item.medias_height.intValue / item.medias_weight.intValue;
        if (self.picViewHeight.constant > 300) {
            self.picViewHeight.constant = 300;
        }
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SQSW, self.picViewHeight.constant)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.picView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    }else if (item.item_type.intValue == 2){//2张图片
        self.picViewHeight.constant = 183;
        CGFloat width = (SQSW - 10) / 2;
        for (int i = 0; i < 2; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width + 10) * i, 0, width, 183)];
            [self.picView addSubview:imageView];
            if (i == 0) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
            }
            if (i == 1) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:item.sec_min_url] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
            }
        }
    }else if (item.item_type.intValue == 3){//3张图片
        self.picViewHeight.constant = 123;
         CGFloat width = (SQSW - 10) / 2;
        for (int i = 0; i < 3; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width + 10) * i, 0, width, 123)];
            [self.picView addSubview:imageView];
            if (i == 0) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
            }
            if (i == 1) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:item.sec_min_url] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
            }
            if (i == 2) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:item.thr_min_url] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
            }
        }
    }
    
    //self.contentV = self.contentView;
}

- (NSString *)dateString:(NSString *)dateStr
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    if (!date) {
        return @"";
    }
    int minites = [[NSDate date] timeIntervalSinceDate:date]/60;
    if (minites < 0) {
        return @"";
    }
    if (minites < 60) {//不到一小时
        return [NSString stringWithFormat:@"%d分钟前",minites];
    }
    else if(minites < 60 * 24)//不到一天
    {
        return [NSString stringWithFormat:@"%d小时前",minites / 60];
    }
    else if(minites < 60 * 24 * 3)//不大于三天
    {
        return [NSString stringWithFormat:@"%d天前",minites / 60 / 24];
    }
    
    return @"";
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 10;
    [super setFrame:frame];
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
