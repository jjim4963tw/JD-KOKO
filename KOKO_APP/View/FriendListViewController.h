//
//  FriendListViewController.h
//  KOKO_APP
//
//  Created by Jim Huang on 2022/5/20.
//

#import <UIKit/UIKit.h>

@interface FriendListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnUserKOKOID;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSetID;

@property (weak, nonatomic) IBOutlet UITableView *tableViewInvite;
@property (weak, nonatomic) IBOutlet UITableView *tableViewList;

@property (weak, nonatomic) IBOutlet UIButton *btnFriend;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;

@property (weak, nonatomic) IBOutlet UIView *ViewEmpty;
@property (weak, nonatomic) IBOutlet UILabel *labelEmptyTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelEmptyContent;
@property (weak, nonatomic) IBOutlet UIButton *btnEmptyAddFriend;
@property (weak, nonatomic) IBOutlet UILabel *labelEmptySetupID;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnFriendTop;

@property (strong, nonatomic) NSString *userURLString;


@end
