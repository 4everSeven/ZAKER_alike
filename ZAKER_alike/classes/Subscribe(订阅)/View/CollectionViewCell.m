//
//  CollectionViewCell.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/5.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "CollectionViewCell.h"
#import "UIColor+Hex.h"
@interface CollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *channelImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *isEditingImageView;

@end
@implementation CollectionViewCell

-(void)setItem:(CollectionCellItem *)item{
    _item = item;
    
    //设置频道标题
    self.titleLabel.text = [item valueForKey:@"title"];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    
    //设置频道的图片，因为需要图片的颜色以及有最后一个添加内容的关系，所以需要作出改变
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[item valueForKey:@"pic"]]];
    UIImage *image = [UIImage imageWithData:data];
    self.channelImageView.tintColor = [UIColor colorWithHexString:[item valueForKey:@"block_color"]];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    //判断是不是最后一个cell
    if ([[item valueForKey:@"pic"] hasPrefix:@"http"]) {
        self.channelImageView.image = image;
    } else {
        self.channelImageView.image = [UIImage imageNamed:[item valueForKey:@"pic"]];
    }
    
    
   // self.isEditingImageView.hidden = YES;
    
    // NSLog(@"buttonframeW:%f,H:%f",self.isEditingImageView.frame.size.width,self.isEditingImageView.frame.size.height);
}

- (void)awakeFromNib {
//    self.tickButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    CGRect frame = self.isEditingImageView.frame;
//   self.tickButton.frame = CGRectMake(self.frame.size.width - 30, 0, 30, 30);
//    [self addSubview:self.tickButton];
//    self.tickButton.hidden = YES;
    self.layer.borderWidth = .5;
    self.layer.borderColor = MainBgColor.CGColor;
    self.delButton.hidden = YES;
}

-(void)setChannelIndex:(NSInteger)channelIndex{
    _channelIndex = channelIndex;
    self.delButton.tag = channelIndex;
}

//- (void)setSelected:(BOOL)selected
//{
//    UIImage *image = self.isEditingImageView.image;
//    
//    if (selected) {
//        //self.ttickImageView.image = [image imageWithTintColor:[UIColor redColor]]
//        [self.tickButton setImage:image forState:UIControlStateNormal];
//        self.tickButton.hidden = NO;
//    } else {
////        self.ttickImageView.image = [image imageWithTintColor:[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1]];
//        //        self.ttickImageView.image = image;
//    }
//    [super setSelected:selected];
//}
//
//- (void)setEditing:(BOOL)editing
//{
//    UIImage *image = self.isEditingImageView.image;
//    
//    if (editing) {
//        [self.tickButton setImage:image forState:UIControlStateNormal];
//        self.tickButton.hidden = NO;
//        NSLog(@"sss");
//    } else {
//        self.tickButton.hidden = YES;
//    }
//}




@end
