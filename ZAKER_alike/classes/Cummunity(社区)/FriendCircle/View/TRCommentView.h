//
//  TRCommentView.h
//  ITSNS
//
//  Created by tarena on 16/8/30.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRComment.h"
#import "YYTextView.h"
#import "TRImagesView.h"
@interface TRCommentView : UIView
@property (nonatomic, strong)YYTextView *commentTV;

@property (nonatomic, strong)TRComment *comment;
@property (nonatomic, strong)TRImagesView *imagesView;
@end
