//
//  DetailTableHeaderView.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/20.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "DetailTableHeaderView.h"

@implementation DetailTableHeaderView

-(void)setItem:(FriendItem *)item{
    _item = item;
    //设置头像
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    NSString *headPath = [item.user objectForKey:@"headPath"];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    [self addSubview:headImageView];
    
    //设置昵称
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 100, 18)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    [nameLabel setTextColor:[UIColor blueColor]];
    nameLabel.text = [item.user objectForKey:@"username"];
    [nameLabel sizeToFit];
    [self addSubview:nameLabel];
    
    //设置时间
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(nameLabel.frame), 100, 12)];
    dateLabel.font = [UIFont systemFontOfSize:10];
    dateLabel.text = [item createdTime];
    [self addSubview:dateLabel];
    
    //设置内容
    CGFloat contentHeight = [self getHeighWithTitle:item.detail font:[UIFont systemFontOfSize:15] width:(SQSW - 20) numberOfLines:0];
    UILabel *contentlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, SQSW - 20, contentHeight)];
    contentlabel.font = [UIFont systemFontOfSize:15];
    contentlabel.text = item.detail;
    contentlabel.numberOfLines = 0;
    [self addSubview:contentlabel];
    
    //设置图像
    UIView *viewForImage = [[UIView alloc]initWithFrame:CGRectMake(0, contentHeight + 60, SQSW, 0)];
    int count = (int)item.imagePaths.count;
    CGRect frame = viewForImage.frame;
    //设置图片的显示
    //判断图片的显示张数
    if (item.imagePaths == nil) {
        
    }else if (count == 1){//一张图片
        frame.size.height = 300;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SQSW, frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [viewForImage addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:item.imagePaths[0]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    }else if (count == 2 || count == 4){//2张图片或者四张图片
        frame.size.height = 183 * (count / 2) + 10 * (count / 2 - 1);
        CGFloat width = (SQSW - 10) / 2;
        for (int i = 0; i < count; i++) {
            int hang = i / 2;
            int lie = i % 2;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width + 10) * lie, (183+ 10) * hang, width, 183)];
            [viewForImage addSubview:imageView];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:item.imagePaths[i]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
        }
    }else if (count >= 3){//3张图片或者以上
        frame.size.height = 123 * (count / 3) + 10 * (count / 3 - 1);
        CGFloat width = (SQSW - 20) / 3;
        for (int i = 0; i < count; i++) {
            int hang = i / 3;
            int lie = i % 3;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width + 10) * lie, (123 + 10) * hang, width, 123)];
            [viewForImage addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:item.imagePaths[i]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
        }
    }
    viewForImage.frame = frame;
    [self addSubview:viewForImage];
}


- (CGFloat )getHeighWithTitle:(NSString *)title font:(UIFont *)font width:(float)width numberOfLines:(NSInteger)num{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = num;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}


@end
