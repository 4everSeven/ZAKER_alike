//
//  TRITObjectView.h
//  ITSNS
//
//  Created by tarena on 16/8/26.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTextView.h"
#import "TRITObject.h"
#import "TRImagesView.h"
@interface TRITObjectView : UIView

@property (nonatomic, strong)YYTextView *titleTV;
@property (nonatomic, strong)YYTextView *detailTV;
@property (nonatomic, strong)TRITObject *itObj;
@property (nonatomic, strong)TRImagesView *imagesView;
@end
