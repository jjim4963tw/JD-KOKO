//
//  FriendListViewController.h
//  KOKO_APP
//
//  Created by Jim Huang on 2022/5/20.
//

#import <UIKit/UIKit.h>

@interface FriendListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnUserKOKOID;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserAvatar;

@property (weak, nonatomic) IBOutlet UITableView *tableViewInvite;
@property (weak, nonatomic) IBOutlet UITableView *tableViewList;

@property (weak, nonatomic) IBOutlet UIButton *btnFriend;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnFriendTop;

@end
