//
//  TRITObjectView.m
//  ITSNS
//
//  Created by tarena on 16/8/26.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import "TRITObjectView.h"
#import "Utils.h"
@implementation TRITObjectView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        self.titleTV = [[YYTextView alloc]initWithFrame:CGRectMake(LYMargin, LYMargin, frame.size.width-2*LYMargin, 0)];
        self.titleTV.userInteractionEnabled = NO;
        self.titleTV.font = [UIFont systemFontOfSize:15];
        self.titleTV.textAlignment = NSTextAlignmentCenter;
        
        [Utils faceMappingWithText:self.titleTV];
        self.titleTV.editable = NO;
     
        [self addSubview:self.titleTV];
        
        self.detailTV = [[YYTextView alloc]initWithFrame:CGRectMake(LYMargin, 0, self.titleTV.bounds.size.width, 0)];
          self.detailTV.userInteractionEnabled = NO;
        self.detailTV.font = [UIFont systemFontOfSize:12];
        [Utils faceMappingWithText:self.detailTV];
        self.detailTV.editable = NO;
     
        self.detailTV.textColor = [UIColor grayColor];
        [self addSubview:self.detailTV];
        
        self.imagesView = [[TRImagesView alloc]initWithFrame:CGRectMake(LYMargin, 0, LYSW-2*LYMargin, 0)];
        [self addSubview:self.imagesView];

    }
    return self;
}

-(void)setItObj:(TRITObject *)itObj{
    _itObj = itObj;
    
    
    self.titleTV.text = itObj.title;
    if (itObj.title.length>0) {
         self.titleTV.height = self.titleTV.textLayout.textBoundingSize.height;
    }else{//如果没有文本 则高度为0 避免复用时出错
        self.titleTV.height = 0;
    }
   
    
    self.detailTV.text = itObj.detail;
    if (itObj.detail.length>0) {
        self.detailTV.top = CGRectGetMaxY(self.titleTV.frame)+LYMargin;
        self.detailTV.height = self.detailTV.textLayout.textBoundingSize.height;
    }else{//如果没有文本 则高度为0 避免复用时出错
        self.detailTV.height = 0;
    }
   
    
    //设置显示图片
    if (itObj.imagePaths.count>0) {
        self.imagesView.hidden = NO;
        
        self.imagesView.imagePaths = itObj.imagePaths;
        
        self.imagesView.top = self.titleTV.bounds.size.height+self.detailTV.bounds.size.height+3*LYMargin;
      
        
        self.imagesView.height =  itObj.imagesHeight;

        
        
    }else{
        self.imagesView.hidden = YES;
    }
    
    
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
