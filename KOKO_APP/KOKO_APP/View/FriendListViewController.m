//
//  FriendListViewController.m
//  KOKO_APP
//
//  Created by Jim Huang on 2022/5/20.
//

#import "FriendListViewController.h"
#import "FriendListTableViewCell.h"
#import "InvitedTableViewCell.h"
#import "MKNumberBadgeView.h"


#import "FriendUserModel.h"

#import "APIUtility.h"
#import "NSString+Extend.h"
#import "UIImage+Extend.h"


@interface FriendListViewController ()

@property(retain) UIImage *ovilImage;
@property(retain) UIImage *clearImage;

@property (nonatomic, retain) NSMutableArray *inviteList;
@property (nonatomic, retain) NSMutableArray *friendList;
@property (nonatomic, retain) NSMutableArray *chatList;

@property CGFloat btnFriendTopConstant;

@property NSInteger nowSelectedType;
@property BOOL showInviteVisible;

@end


@implementation FriendListViewController

#pragma mark - LifeCycle Function Function

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initContentView];
    [self initNavigationBar];
    [self initUserData];
}


#pragma mark - Init Function

- (void)initContentView {
    self.btnFriendTopConstant = self.constraintBtnFriendTop.constant;
    self.labelUserName.text = @"紫晽";

    self.imageViewUserAvatar.layer.cornerRadius = self.imageViewUserAvatar.frame.size.width / 2;
    self.imageViewUserAvatar.layer.masksToBounds = YES;
    
    self.imageViewSetID.layer.cornerRadius = self.imageViewSetID.frame.size.width / 2;
    self.imageViewSetID.layer.masksToBounds = YES;
    self.imageViewSetID.hidden = NO;

    [self.btnUserKOKOID setTitle:[NSString localization:@"koko_id_setting"] forState:UIControlStateNormal];

    UIButtonConfiguration *configuration = [UIButtonConfiguration filledButtonConfiguration];
    configuration.background.backgroundColor = UIColor.clearColor;
    configuration.titleAlignment = UIButtonConfigurationTitleAlignmentCenter;
    configuration.imagePadding = 5.0;
    configuration.imagePlacement = NSDirectionalRectEdgeBottom;
    self.btnFriend.configuration = configuration;
    self.btnChat.configuration = configuration;
        
    [self.btnFriend setImage:self.ovilImage forState:UIControlStateNormal];
    [self.btnFriend setTitle:[NSString localization:@"button_friends"] forState:UIControlStateNormal];
    [self.btnChat setTitle:[NSString localization:@"button_chats"] forState:UIControlStateNormal];
    
    [self changeChatAndFriendListButtonStyle:self.btnFriend];
    
    // iOS 15 改用此方法設定 style
    UIImage *gradientImage = [UIImage convertGradientToImage:[UIColor colorWithRed: 0.34 green: 0.70 blue: 0.04 alpha: 1.00] endColor:[UIColor colorWithRed: 0.65 green: 0.80 blue: 0.26 alpha: 1.00] frame:self.btnEmptyAddFriend.frame];
    configuration = [UIButtonConfiguration filledButtonConfiguration];
    configuration.background.image = gradientImage;
    configuration.background.cornerRadius = 20.0;
    configuration.image = [UIImage imageNamed:@"icon_add_friend"];
    configuration.imagePlacement = NSDirectionalRectEdgeTrailing;
    configuration.titleAlignment = UIButtonConfigurationTitleAlignmentCenter;
    configuration.title = [NSString localization:@"empty_add_friend_button_title"];
    self.btnEmptyAddFriend.configuration = configuration;
    
    self.labelEmptyTitle.text = [NSString localization:@"empty_title"];
    self.labelEmptyContent.text = [NSString localization:@"empty_content"];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[[NSString localization:@"empty_setup_id"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.labelEmptySetupID.attributedText = attrStr;

    [self.tableViewInvite setHidden:YES];
    [self.tableViewList setHidden:NO];
    [self.ViewEmpty setHidden:YES];
    
    // 當未有好友邀請時，將好友列表上移。
    self.constraintBtnFriendTop.constant = self.btnFriendTopConstant - self.tableViewInvite.frame.size.height - 6;

    self.tableViewList.delegate = self;
    self.tableViewList.dataSource = self;
    self.tableViewInvite.delegate = self;
    self.tableViewInvite.dataSource = self;
    
    self.tableViewList.allowsSelection = NO;
    [self.tableViewList registerNib:[UINib nibWithNibName:@"FriendListTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendListTableViewCell"];
    
    self.tableViewInvite.allowsSelection = NO;
    [self.tableViewInvite registerNib:[UINib nibWithNibName:@"InvitedTableViewCell" bundle:nil] forCellReuseIdentifier:@"InvitedTableViewCell"];
    
    [self setFriendListHeaderView];
    [self setBadgeView];
}

- (void)initNavigationBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initUserData {
    self.nowSelectedType = 0;
    self.showInviteVisible = NO;
    
    if (!self.friendList) {
        self.friendList = [[NSMutableArray alloc] init];
    } else {
        [self.friendList removeAllObjects];
    }
    
    if (!self.chatList) {
        self.chatList = [[NSMutableArray alloc] init];
    } else {
        [self.chatList removeAllObjects];
    }

    if (!self.inviteList) {
        self.inviteList = [[NSMutableArray alloc] init];
    } else {
        [self.inviteList removeAllObjects];
    }
    
    [self getUserData];
    [self getFriendListData];
}


#pragma mark - IBAction Function

- (IBAction)goATMFunction:(UIButton *)sender {
    
}

- (IBAction)goTransferFunction:(UIButton *)sender {
    
}

- (IBAction)goScanQRCodeFucntion:(UIButton *)sender {
    
}

- (IBAction)goSettingKOKOIDFunction:(UIButton *)sender {
    
}

- (IBAction)switchFriendOrCharList:(UIButton *)sender {
    [self changeChatAndFriendListButtonStyle:sender];
    
    self.nowSelectedType = (sender == self.btnFriend) ? 0 : 1;
    [self.tableViewList reloadData];
}

- (IBAction)addFriendFunction:(UIButton *)sender {
}


#pragma mark - UITableView Function

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableViewInvite && self.inviteList.count > 1 && self.showInviteVisible) {
        // 展開邀請列表
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableViewList) {
        // 好友、聊天列表
        if (self.nowSelectedType == 0) {
            if (self.friendList && self.friendList.count > 0) {
                return self.friendList.count;
            }
        } else {
            if (self.chatList && self.chatList.count > 0) {
                return self.chatList.count;
            }
        }
    } else if (tableView == self.tableViewInvite) {
        // 邀請列表
        if (self.inviteList && self.inviteList.count > 0) {
            return self.inviteList.count;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableViewInvite) {
        return 70;
    }
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableViewInvite) {
        return 0;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableViewList) {
        if (self.nowSelectedType == 0) {
            // 好友列表
            return [self cellForFriendListFunctionAtTableView:tableView IndexPath:indexPath];
        } else {
            return [[UITableViewCell alloc] init];
        }
        
    } else if (tableView == self.tableViewInvite) {
        // 邀請列表
        return [self cellForFriendInvitedListFunctionAtTableView:tableView IndexPath:indexPath];
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - UITableView Function

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.3 animations:^{
        if (self.tableViewInvite.isHidden) {
            self.view.frame = CGRectOffset(self.view.frame, 0, -([[UIScreen mainScreen] bounds].size.height * 0.2));
        } else {
            self.view.frame = CGRectOffset(self.view.frame, 0, -([[UIScreen mainScreen] bounds].size.height * 0.38));
        }
    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.2 animations:^{
        if (self.tableViewInvite.isHidden) {
            self.view.frame = CGRectOffset(self.view.frame, 0, ([[UIScreen mainScreen] bounds].size.height * 0.2));
        } else {
            self.view.frame = CGRectOffset(self.view.frame, 0, ([[UIScreen mainScreen] bounds].size.height * 0.38));
        }
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}


#pragma mark - Call API Function

- (void)getUserData {
    // 取得此 User 的資料
    [APIUtility apiConnectionByURL:@"https://dimanyen.github.io/man.json" completion:^(NSMutableDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response && response.count > 0) {
            NSArray *responseArray = [response objectForKey:@"response"];
            NSString *userName = [[responseArray objectAtIndex:0] objectForKey:@"name"];
            NSString *kokoID = [[responseArray objectAtIndex:0]  objectForKey:@"kokoid"];

            self.labelUserName.text = userName;
            
            if ([kokoID isEmpty]) {
                [self.btnUserKOKOID setTitle:[NSString localization:@"koko_id_setting"] forState:UIControlStateNormal];
                self.imageViewSetID.hidden = NO;
            } else {
                [self.btnUserKOKOID setTitle:[NSString stringWithFormat:[NSString localization:@"koko_id_show"], kokoID] forState:UIControlStateNormal];
                self.imageViewSetID.hidden = YES;
            }
        }
    }];
}

/// 取的 User 的好友列表
- (void)getFriendListData {
    [APIUtility apiConnectionByURL:@"https://dimanyen.github.io/friend4.json" completion:^(NSMutableDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response && response.count > 0) {
            NSArray *responseArray = [response objectForKey:@"response"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            for (NSDictionary *userDic in responseArray) {
                NSString *userName = [userDic objectForKey:@"name"];
                NSString *userID = [userDic objectForKey:@"fid"];
                NSInteger status = [[userDic objectForKey:@"status"] integerValue];
                BOOL isTop = [[userDic objectForKey:@"isTop"] isEqualToString:@"1"];
                
                NSString *updateTimeString = [userDic objectForKey:@"updateDate"];
                if ([updateTimeString containsString:@"/"]) {
                    [formatter setDateFormat:@"yyyy/MM/dd"];
                } else {
                    [formatter setDateFormat:@"yyyyMMdd"];
                }
                NSDate *updateDate = [formatter dateFromString:updateTimeString];

                FriendUserModel *model = [[FriendUserModel alloc] initWithUserName:userName userID:userID status:status updateTimes:updateDate isTop:isTop];
                
                if (status == 2) {
                    [self.inviteList addObject:model];
                } else {
                    [self.friendList addObject:model];
                }
            }
            
            // 判斷是否顯示好友列表或顯示 EmptyView
            if (self.friendList.count <= 0) {
                self.tableViewList.hidden = YES;
                self.ViewEmpty.hidden = NO;
            } else {
                [self.tableViewList reloadData];
                self.tableViewList.hidden = NO;
                self.ViewEmpty.hidden = YES;
            }
            
            // 判斷是否顯示好友邀請列表
            if (self.inviteList.count <= 0) {
                self.tableViewInvite.hidden = YES;
                if (self.constraintBtnFriendTop.constant == self.btnFriendTopConstant) {
                    // 當未有好友邀請時，將好友列表上移。
                    self.constraintBtnFriendTop.constant = self.btnFriendTopConstant - self.tableViewInvite.frame.size.height - 6;
                }
            } else {
                [self.tableViewInvite reloadData];
                self.tableViewInvite.hidden = NO;
                if (self.constraintBtnFriendTop.constant != self.btnFriendTopConstant) {
                    self.constraintBtnFriendTop.constant += self.tableViewInvite.frame.size.height + 6;
                }
            }
        } else {
            self.tableViewList.hidden = YES;
            self.ViewEmpty.hidden = NO;
            self.tableViewInvite.hidden = YES;
            if (self.constraintBtnFriendTop.constant == self.btnFriendTopConstant) {
                // 當未有好友邀請時，將好友列表上移。
                self.constraintBtnFriendTop.constant = self.btnFriendTopConstant - self.tableViewInvite.frame.size.height - 6;
            }
        }
        
        [self setBadgeView];
    }];
}


#pragma mark - Private Function

- (void)changeChatAndFriendListButtonStyle:(UIButton *)button {
    if (!self.ovilImage) {
        self.ovilImage = [UIImage createOvalImage:[UIColor colorNamed:@"AccentColor"] endColor:[UIColor colorNamed:@"AccentColor"] frame:self.btnFriend.frame];
    }
    
    if (!self.clearImage) {
        self.clearImage = [UIImage createOvalImage:[UIColor clearColor] endColor:[UIColor clearColor] frame:self.btnFriend.frame];
    }

    if (button == self.btnFriend) {
        [self.btnFriend setImage:self.ovilImage forState:UIControlStateNormal];
        [self.btnChat setImage:self.clearImage forState:UIControlStateNormal];
    } else {
        [self.btnChat setImage:self.ovilImage forState:UIControlStateNormal];
        [self.btnFriend setImage:self.clearImage forState:UIControlStateNormal];
    }
}

- (void)setFriendListHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewList.bounds.size.width, 60.0)];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableViewList.frame.size.width * 0.8, 60)];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = [NSString localization:@"search_bar_hint"];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.tableViewList.frame.size.width * 0.83, (60 - 25) / 2, 25.0, 25.0)];
    imageView.image = [UIImage imageNamed:@"icon_friend_header"];
    
    [view addSubview:self.searchBar];
    [view addSubview:imageView];

    self.tableViewList.tableHeaderView = view;
}

- (void)setBadgeView {
    MKNumberBadgeView *numberBadge = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.btnChat.frame.size.width - 10, -10, 40, self.btnChat.frame.size.height)];
    numberBadge.value = @"99+";
    numberBadge.shadow = NO;
    numberBadge.shine = NO;
    numberBadge.fillColor = [UIColor colorWithRed: 0.98 green: 0.70 blue: 0.86 alpha: 1.00];
    numberBadge.textColor = [UIColor whiteColor];

    for (UIView *subView in self.btnChat.subviews) {
        if ([subView isKindOfClass:[MKNumberBadgeView class]]) {
            [subView removeFromSuperview];
        }
    }
    [self.btnChat addSubview:numberBadge];
    

    for (UIView *subView in self.btnFriend.subviews) {
        if ([subView isKindOfClass:[MKNumberBadgeView class]]) {
            [subView removeFromSuperview];
        }
    }

    if (self.inviteList && self.inviteList.count > 0) {
        MKNumberBadgeView *inviteBadge = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.btnFriend.frame.size.width - 10, -10, 20, self.btnChat.frame.size.height)];
        inviteBadge.value = [NSString stringWithFormat:@"%d", (int) self.inviteList.count];
        inviteBadge.shadow = NO;
        inviteBadge.shine = NO;
        inviteBadge.fillColor = [UIColor colorWithRed: 0.98 green: 0.70 blue: 0.86 alpha: 1.00];
        inviteBadge.textColor = [UIColor whiteColor];
        [self.btnFriend addSubview:inviteBadge];
    }
}

- (FriendListTableViewCell *)cellForFriendListFunctionAtTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {
    FriendUserModel *model = [self.friendList objectAtIndex: [indexPath row]];

    FriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListTableViewCell"];
    if (!cell) {
        cell = [[FriendListTableViewCell alloc] init];
    }
    
    cell.labelUserName.text = model.userName;
    cell.imageViewStar.hidden = !model.isTop;
    
    cell.btnTransfer.hidden = NO;
    cell.viewTransferSpace.hidden = NO;
    if (model.status == 0) {
        cell.btnMore.hidden = YES;
        cell.btnInvite.hidden = NO;
        cell.viewMoreSpace.hidden = YES;
    } else {
        cell.btnMore.hidden = NO;
        cell.btnInvite.hidden = YES;
        cell.viewMoreSpace.hidden = NO;
    }
    
    return cell;
}

- (InvitedTableViewCell *)cellForFriendInvitedListFunctionAtTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {
    FriendUserModel *model = [self.inviteList objectAtIndex: [indexPath row]];

    InvitedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitedTableViewCell"];
    if (!cell) {
        cell = [[InvitedTableViewCell alloc] init];
    }
    
    cell.labelUserName.text = model.userName;
    cell.labelContent.text = [NSString localization:@"label_invite_message"];
    
    return cell;
}

@end
