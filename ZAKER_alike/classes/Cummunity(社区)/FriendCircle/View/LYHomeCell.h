//
//  LYQuestionCell.h
//  ITSNS
//
//  Created by Ivan on 16/1/13.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTextView.h"
#import "TRITObject.h"
#import "TRITObjectView.h"
@interface LYHomeCell : UITableViewCell

@property (nonatomic, strong)TRITObject *itObj;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *showCountBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;

@property (nonatomic, strong)TRITObjectView *objView;


@end
