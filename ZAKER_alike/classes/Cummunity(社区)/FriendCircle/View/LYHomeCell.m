//
//  LYQuestionCell.m
//  ITSNS
//
//  Created by Ivan on 16/1/13.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "LYUserInfoViewController.h"
#import "XHDrawerController.h"
#import "AppDelegate.h"
#import "LYHomeCell.h"
@implementation LYHomeCell
//初始化方法
-(void)awakeFromNib{
    //设置Cell选中背景颜色
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = LYGreenColor;
    //设置按钮的显示效果
    self.showCountBtn.layer.borderWidth = self.commentBtn.layer.borderWidth = .5;
    self.showCountBtn.layer.cornerRadius = self.commentBtn.layer.cornerRadius = 3;
    self.showCountBtn.layer.masksToBounds =  self.commentBtn.layer.masksToBounds = YES;
    self.showCountBtn.layer.borderColor =  self.commentBtn.layer.borderColor = [UIColor grayColor].CGColor;
    

 
  //头像的点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction)];
    [self.headIV addGestureRecognizer:tap];
    self.headIV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction)];
    [self.nameLabel addGestureRecognizer:nameTap];
    self.nameLabel.userInteractionEnabled = YES;
    
    
    //创建itobjView
    self.objView = [[TRITObjectView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headIV.frame)+LYMargin, LYSW, 0)];
    
    [self addSubview:self.objView];
    
 
}
-(void)userInfoAction{
    //点击用户头像做的事儿
    
    LYUserInfoViewController *vc = [LYUserInfoViewController new];
    
    vc.user = self.itObj.user;
    
    
    //得到当前的导航控制器
    XHDrawerController *dc =  (XHDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UITabBarController *tc = (UITabBarController *)dc.centerViewController;
    UINavigationController *nc = tc.selectedViewController;
    
    [nc pushViewController:vc animated:YES];

    
    
}



-(void)setItObj:(TRITObject *)itObj{
    _itObj = itObj;
    //隐藏 图片 位置 录音的按钮
    self.audioBtn.hidden = self.imageBtn.hidden = self.locationBtn.hidden = YES;
    if (itObj.location) {
        self.locationBtn.hidden = NO;
    }
    if (itObj.voicePath) {
        self.audioBtn.hidden = NO;
    }
    if (itObj.imagePaths.count>0) {
        self.imageBtn.hidden = NO;
    }
    //设置昵称
    self.nameLabel.text = [itObj.user objectForKey:@"nick"];
    NSString *headPath = [itObj.user objectForKey:@"headPath"];
    //设置头像
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"loadingImage.png"]];
    //设置时间
    self.timeLabel.text = [itObj createdTime];
    
    
    //设置真正消息内容
    self.objView.itObj = itObj;
    
    self.objView.height = self.objView.titleTV.bounds.size.height+self.objView.detailTV.bounds.size.height+3*LYMargin+itObj.imagesHeight;
//    NSLog(@"%f",self.objView.height);
    
 
    //显示浏览量
    [self.showCountBtn setTitle:[NSString stringWithFormat:@"%d",itObj.showCount] forState:UIControlStateNormal];
    
    //显示评论量
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%d",itObj.commentCount] forState:UIControlStateNormal];
    
}



 
@end
