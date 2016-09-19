//
//  FriendCircleCell.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/17.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "FriendCircleCell.h"
@interface FriendCircleCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *detailView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property(nonatomic,strong)NSArray *imagePaths;
@end
@implementation FriendCircleCell

-(void)setItem:(FriendItem *)item{
    _item = item;
    //设置昵称
    self.nameLabel.text = [item.user objectForKey:@"username"];
    NSString *headPath = [item.user objectForKey:@"headPath"];
    //设置头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    //设置时间
    self.timeLabel.text = [item createdTime];
    
    //设置内容
    self.contentLabel.text = item.detail;
    
    self.imagePaths = item.imagePaths;
  //  NSLog(@"imagePath:%@",self.imagePaths);
    
    
    for (UIImageView *iv in self.detailView.subviews) {
        [iv removeFromSuperview];
    }
    //设置图片的显示
    //判断图片的显示张数
    if (self.imagePaths == nil) {
        self.contentViewHeight.constant = 0;
        //[self.detailView removeFromSuperview];
    }else if (self.imagePaths.count == 1){//一张图片
        self.contentViewHeight.constant = 300;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SQSW, self.contentViewHeight.constant)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.detailView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imagePaths[0]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    }else if (self.imagePaths.count == 2){//2张图片
        self.contentViewHeight.constant = 183;
        CGFloat width = (SQSW - 10) / 2;
        for (int i = 0; i < 2; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width + 10) * i, 0, width, 183)];
            [self.detailView addSubview:imageView];
            if (i == 0) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.imagePaths[i]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
            }
            if (i == 1) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.imagePaths[i]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
            }
        }
    }else if (self.imagePaths.count >= 3){//3张图片或者3张以上
        self.contentViewHeight.constant = 123;
        CGFloat width = (SQSW - 20) / 3;
        for (int i = 0; i < 3; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width + 10) * i, 0, width, 123)];
            [self.detailView addSubview:imageView];
            if (i == 0) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.imagePaths[i]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
            }
            if (i == 1) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.imagePaths[i]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
            }
            if (i == 2) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.imagePaths[i]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
            }
        }
    }
}

//- (void)setFrame:(CGRect)frame
//{
//    frame.size.height -= 10;
//    [super setFrame:frame];
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
