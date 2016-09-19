//
//  TRCommentView.m
//  ITSNS
//
//  Created by tarena on 16/8/30.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import "TRCommentView.h"
#import "Utils.h"
@implementation TRCommentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.commentTV = [[YYTextView alloc]initWithFrame:CGRectMake(LYMargin, 0, frame.size.width-2*LYMargin, 0)];
        self.commentTV.userInteractionEnabled = NO;
        self.commentTV.font = [UIFont systemFontOfSize:15];
        self.commentTV.textAlignment = NSTextAlignmentCenter;
        
        [Utils faceMappingWithText:self.commentTV];
        self.commentTV.editable = NO;
        
        [self addSubview:self.commentTV];
        
     
        
        self.imagesView = [[TRImagesView alloc]initWithFrame:CGRectMake(LYMargin, 0, LYSW-2*LYMargin, 0)];
        [self addSubview:self.imagesView];
//        self.commentTV.backgroundColor = [UIColor yellowColor];
//        self.imagesView.backgroundColor = [UIColor cyanColor];
    }
    return self;
}

-(void)setComment:(TRComment *)comment{
    _comment = comment;
 
    self.commentTV.text = comment.text;
    if (comment.text.length>0) {
        self.commentTV.height = self.commentTV.textLayout.textBoundingSize.height;
    }else{//如果没有文本 则高度为0 避免复用时出错
        self.commentTV.height = 0;
    }
    
    
    
    
    //设置显示图片
    if (comment.imagePaths.count>0) {
        self.imagesView.hidden = NO;
        
        self.imagesView.imagePaths = comment.imagePaths;
        
        self.imagesView.top = self.commentTV.bounds.size.height+LYMargin;
        
        
        self.imagesView.height =  comment.imagesHeight;
        
        
        
    }else{
        self.imagesView.hidden = YES;
    }
    
    
    
    
    
}

 

@end
