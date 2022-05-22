//
//  FriendListTableViewCell.m
//  KOKO_APP
//
//  Created by Jim Huang on 2022/5/21.
//

#import "FriendListTableViewCell.h"
#import "NSString+Extend.h"

@implementation FriendListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.btnTransfer.layer.cornerRadius = 2.5;
    self.btnTransfer.layer.borderWidth = 1.2;
    self.btnTransfer.layer.borderColor = [UIColor colorNamed:@"AccentColor"].CGColor;
    [self.btnTransfer setTitle:[NSString localization:@"button_transfer"] forState:UIControlStateNormal];
    
    self.btnInvite.layer.cornerRadius = 2.5;
    self.btnInvite.layer.borderWidth = 1.2;
    self.btnInvite.layer.borderColor = [UIColor colorWithRed: 0.60 green: 0.60 blue: 0.60 alpha: 1.00].CGColor;
    [self.btnInvite setTitle:[NSString localization:@"button_invitation"] forState:UIControlStateNormal];
    
    self.imageViewUserAvatar.layer.cornerRadius = self.imageViewUserAvatar.frame.size.width / 2;
    self.imageViewUserAvatar.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
