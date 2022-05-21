//
//  InvitedTableViewCell.h
//  KOKO_APP
//
//  Created by Jim Huang on 2022/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InvitedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UIButton *btnAgreeInvited;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteInvited;


@end

NS_ASSUME_NONNULL_END
