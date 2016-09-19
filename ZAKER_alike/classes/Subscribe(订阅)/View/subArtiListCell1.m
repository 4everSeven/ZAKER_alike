//
//  subArtiListCell1.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/6.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "subArtiListCell1.h"
#import "UIImageView+WebCache.h"
#import "CollectionViewCell.h"
#import "UIColor+Hex.h"
#import "SubArticleItem.h"
#import "AirticleViewController.h"
#import "UIView+Navi.h"

@interface subArtiListCell1()
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIView *contentView1;
@property (weak, nonatomic) IBOutlet UIImageView *artiImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1HeightConstranint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleConstraint;

@property (weak, nonatomic) IBOutlet UIView *contentView2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel2;

@property (weak, nonatomic) IBOutlet UIView *contentView3;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel3;

@property (weak, nonatomic) IBOutlet UIView *contentView4;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel4;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel4;

@property (weak, nonatomic) IBOutlet UIView *contentView5;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel5;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel5;

@property (weak, nonatomic) IBOutlet UIView *contentView6;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel6;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel6;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *authors;
@property (nonatomic, strong) NSArray *contentViews;

@end
@implementation subArtiListCell1

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.authorLabel1.textColor = [UIColor clearColor];
  //加了这个之后不会有警告
    self.artiImageView.clipsToBounds = YES;
}

//设置头部的背景颜色
-(void)setItem:(CollectionCellItem *)item{
    _item = item;
    NSString *blockColor =[item valueForKey:@"block_color"];
    //NSLog(@"");
    self.artiImageView.backgroundColor = [UIColor colorWithHexString:blockColor];
    //如果是从顶部的滚动视图传过来的话，执行这个
    if (item == nil) {
        self.artiImageView.backgroundColor = [UIColor colorWithRed:34/255.0 green:50/255.0 blue:78/255.0 alpha:1];
    }
}

//-(void)setBlock_color:(NSString *)block_color{
//    _block_color = block_color;
//    self.artiImageView.backgroundColor = [UIColor colorWithHexString:block_color];
//}

//设置头部的背景图片
-(void)setTopImageURL:(NSString *)topImageURL{
    _topImageURL = topImageURL;
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:topImageURL]];
}

//设置各个文章视图
-(void)setArticlesArray:(NSArray *)articlesArray{
    _articlesArray = articlesArray;
    

    
    //设置需要一直重用的几个中间变量
    SubArticleItem *article = [SubArticleItem new];
    UILabel *titleLabel = [[UILabel alloc] init];
    UILabel *authorLabel = [[UILabel alloc] init];
    
    for (int i = 0; i < articlesArray.count; ++i) {
        article = articlesArray[i];
        if (article.title) {
            titleLabel = self.titles[i];
            titleLabel.text = article.title;
        }
        if (article.auther_name) {
            authorLabel = self.authors[i];
           // authorLabel.text = [NSString stringWithFormat:@"%@  %@", article.auther_name, [self compareCurrentTime:article.date]];
            
            authorLabel.text = [NSString stringWithFormat:@"%@  %@", article.auther_name, [self dateString:article.date]];
            
        }
        if (i == 0) {
            if (article.thumbnail_pic) {
                [self.artiImageView sd_setImageWithURL:[NSURL URLWithString:article.thumbnail_pic]];
                self.artiImageView.contentMode = UIViewContentModeScaleAspectFill;
                self.artiImageView.clipsToBounds = YES;
                self.titleConstraint.constant = 10;
                self.view1HeightConstranint.constant = 230;
            } else {
                [self.artiImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
                self.titleConstraint.constant = 60;
                self.view1HeightConstranint.constant = 150;
            }
//            if ([article.open_type isEqualToString:@"discussion"]) {
//                [self.typeImageView sd_setImageWithURL:[NSURL URLWithString:article.icon_url]];
//                self.typeImageView.hidden = NO;
//            } else {
//                [self.typeImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
//                self.typeImageView.hidden = YES;
//            }
        }
        
    }
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

//跳转到具体的文章界面
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch =  [touches anyObject];
    
    __block SubArticleItem *article = [[SubArticleItem alloc] init];
    [self.contentViews enumerateObjectsUsingBlock:^(id  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint curP = [touch locationInView:view];
        if ([view pointInside:curP withEvent:event]) {
            article = self.articlesArray[idx];
            
            //如果不是讨论话题的话，则跳转
            if (![article.open_type isEqualToString:@"discussion"]) {
                AirticleViewController *vc = [[AirticleViewController alloc] init];
                vc.item = self.articlesArray[idx];
                NSString *blockColor =[self.item valueForKey:@"block_color"];
                vc.item.block_color = blockColor;
                
                
                if (self.item == nil) {
                    vc.item.block_color = @"#22324E";
                }
                //[[self navControllerForView:view] pushViewController:vc animated:YES];
                //[[view navigationController] pushViewController:vc animated:YES];
             [[view naviController]pushViewController:vc animated:YES];
            } else {
                
            }
        }
    }];
}

//获取view的navi
- (UINavigationController *)navControllerForView:(UIView*)view{
    
    UIResponder *responder = view;
    
    while ((responder = [responder nextResponder]))
        
        if ([responder isKindOfClass: [UINavigationController class]])
            
            return (UINavigationController *)responder;
    
    //如果没有发现，那么return nil
    return nil;
}

#pragma mark - 懒加载 lazyLoad
- (NSArray *)titles {
    if(_titles == nil) {
        _titles = @[self.titleLabel1,
                    self.titleLabel2,
                    self.titleLabel3,
                    self.titleLabel4,
                    self.titleLabel5,
                    self.titleLabel6];
    }
    return _titles;
}

- (NSArray *)authors {
    if(_authors == nil) {
        _authors = @[self.authorLabel1,
                     self.authorLabel2,
                     self.authorLabel3,
                     self.authorLabel4,
                     self.authorLabel5,
                     self.authorLabel6];
    }
    return _authors;
}

- (NSArray *)contentViews {
    if(_contentViews == nil) {
        _contentViews = @[self.contentView1,
                          self.contentView2,
                          self.contentView3,
                          self.contentView4,
                          self.contentView5,
                          self.contentView6];
    }
    return _contentViews;
}
@end
