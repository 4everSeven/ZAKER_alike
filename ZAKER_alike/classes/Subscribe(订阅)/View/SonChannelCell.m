//
//  SonChannelCell.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/9/16.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "SonChannelCell.h"
@interface SonChannelCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *subButton;
@property(nonatomic,strong)NSMutableArray *channelsArray;

@end
@implementation SonChannelCell

-(void)setItem:(CollectionCellItem *)item{
    _item = item;
    self.titleLabel.text = [item valueForKey:@"title"];
    //从用户偏好设置中取出数据
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = [ud objectForKey:@"channelsArray"];
    self.channelsArray = [(NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    for (CollectionCellItem *it in self.channelsArray) {
        if ([[it valueForKey:@"title"] isEqualToString:[item valueForKey:@"title"]]) {
            [self.subButton setImage:[UIImage imageNamed:@"SubscriptionBlockCellSelect-0-black"] forState:UIControlStateNormal];
            self.subButton.userInteractionEnabled = NO;
        }
    }
}
- (IBAction)addChannel:(UIButton *)sender {
    //从用户偏好设置中取出数据
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = [ud objectForKey:@"channelsArray"];
    self.channelsArray = [(NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    [self.channelsArray insertObject:self.item atIndex:self.channelsArray.count - 1];
    
   // NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //[ud setValue:self.channelsArray forKey:@"channelsArray"];
    [ud setObject:[NSKeyedArchiver archivedDataWithRootObject:self.channelsArray] forKey:@"channelsArray"];
    [ud synchronize];
    
    [sender setImage:[UIImage imageNamed:@"SubscriptionBlockCellSelect-0-black"] forState:UIControlStateNormal];
    sender.userInteractionEnabled = NO;
}

- (void)awakeFromNib {
    // Initialization code
     [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
