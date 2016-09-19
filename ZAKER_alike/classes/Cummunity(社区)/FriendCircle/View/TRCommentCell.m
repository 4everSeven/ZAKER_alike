//
//  TRCommentCell.m
//  ITSNS
//
//  Created by tarena on 16/8/30.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import "TRCommentCell.h"
#import "Utils.h"
@implementation TRCommentCell

- (void)awakeFromNib {
  
    self.commentView = [[TRCommentView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headIV.frame)+LYMargin, LYSW, 0)];
    [self addSubview:self.commentView];
}


-(void)setComment:(TRComment *)comment{
    _comment = comment;
    
    self.nameLabel.text = [comment.user objectForKey:@"nick"];
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:[comment.user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
    
    self.timeLabel.text = comment.createdTime;
    
    self.audioBtn.hidden = comment.voicePath ? NO : YES;
    self.commentView.comment = comment;
    
    self.commentView.height = [comment contentHeight];
    
}
- (IBAction)playAction:(id)sender {
    [Utils playVoiceWithPath:self.comment.voicePath];
    
}
@end
