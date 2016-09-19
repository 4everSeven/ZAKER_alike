//
//  TRImagesView.m
//  ITSNS
//
//  Created by tarena on 16/8/26.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "PhotoBroswerVC.h"
#import "TRImagesView.h"

@implementation TRImagesView


-(void)setImagePaths:(NSArray *)imagePaths{
    _imagePaths = imagePaths;
    
    
    //复用时删除之前所有的图片
    for (UIImageView *iv in self.subviews) {
        [iv removeFromSuperview];
    }
    
    
    if (imagePaths.count==1) {//1张
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
        [iv sd_setImageWithURL:[NSURL URLWithString:imagePaths[0]] placeholderImage:[UIImage imageNamed:@"loadingImage.png"]];
        [self addSubview:iv];
        
        //            ******************
        iv.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [iv addGestureRecognizer:tapAction];
        //            ******************
        
        
    }else{//多张
        
        for (int i=0; i<imagePaths.count; i++) {
            
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(i%3*(LYImageSize+LYMargin), i/3*(LYImageSize+LYMargin), LYImageSize, LYImageSize)];
            [iv sd_setImageWithURL:[NSURL URLWithString:imagePaths[i]] placeholderImage:[UIImage imageNamed:@"loadingImage.png"]];
           
            [self addSubview:iv];
            
//            ******************
            iv.tag = i;
            iv.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [iv addGestureRecognizer:tapAction];
//            ********************
        }
        
        
    }
    
    
    
}

//*****************************
-(void)tapAction:(UITapGestureRecognizer *)tap{
    
    UIImageView *iv = (UIImageView *)tap.view;
    //[UIApplication sharedApplication].keyWindow.rootViewController 得到的是当前程序window的根页面
    
    
    
    [PhotoBroswerVC show:[UIApplication sharedApplication].keyWindow.rootViewController type:PhotoBroswerVCTypeZoom index:iv.tag photoModelBlock:^NSArray *{
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:self.imagePaths.count];
        
        
        for (NSUInteger i = 0; i< self.imagePaths.count; i++) {
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            
            NSString *path = self.imagePaths[i];
            
            //设置查看大图的时候的图片地址
            pbModel.image_HD_U = path;
            
            //源图片的frame
            UIImageView *imageV =(UIImageView *) self.subviews[i];
            pbModel.sourceImageView = imageV;
            [modelsM addObject:pbModel];
        }
        return modelsM;

    }];
    
}
//************************




@end
