//
//  FriendListTableViewCell.h
//  KOKO_APP
//
//  Created by Jim Huang on 2022/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewStar;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnTransfer;
@property (weak, nonatomic) IBOutlet UIButton *btnInvite;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;

@property (weak, nonatomic) IBOutlet UIView *viewTransferSpace;
@property (weak, nonatomic) IBOutlet UIView *viewMoreSpace;


@end

NS_ASSUME_NONNULL_END
