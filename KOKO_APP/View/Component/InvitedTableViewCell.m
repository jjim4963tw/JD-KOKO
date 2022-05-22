//
//  InvitedTableViewCell.m
//  KOKO_APP
//
//  Created by Jim Huang on 2022/5/21.
//

#import "InvitedTableViewCell.h"

@implementation InvitedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.viewContent.backgroundColor = [UIColor whiteColor];
    self.viewContent.layer.cornerRadius = 5.0;
    
    self.viewContent.layer.shadowRadius  = 1.5f;
    self.viewContent.layer.shadowColor   = [UIColor colorWithRed: 0.00 green: 0.00 blue: 0.00 alpha: 0.1].CGColor;
    self.viewContent.layer.shadowOffset  = CGSizeMake(5.0f, 5.0f);
    self.viewContent.layer.shadowOpacity = 0.9f;
    self.viewContent.layer.masksToBounds = NO;

    UIEdgeInsets shadowInsets = UIEdgeInsetsMake(0, 0, 1.5f, 0);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.bounds, shadowInsets)];
    self.viewContent.layer.shadowPath = shadowPath.CGPath;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
