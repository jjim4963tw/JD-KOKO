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
@property (nonatomic, retain) NSMutableArray *searchList;


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
    
    self.labelEmptyTitle.text = [NSString localization:@"empty_title"];
    self.labelEmptyContent.text = [NSString localization:@"empty_content"];
    
    [self.labelEmptySetupID setHTMLText:[NSString localization:@"empty_setup_id"]];
    self.labelEmptySetupID.linkDelegate = self;

    [self.tableViewInvite setHidden:YES];
    [self.tableViewList setHidden:NO];
    [self.ViewEmpty setHidden:YES];
    
    // 當未有好友邀請時，將好友列表上移。
    self.constraintBtnFriendTop.constant = self.btnFriendTopConstant - self.tableViewInvite.frame.size.height - 6;
    
    self.ovilImage = [UIImage createOvalImage:[UIColor colorNamed:@"AccentColor"] endColor:[UIColor colorNamed:@"AccentColor"] frame:self.btnFriend.frame];
    self.clearImage = [UIImage createOvalImage:[UIColor clearColor] endColor:[UIColor clearColor] frame:self.btnFriend.frame];

    [self initButton];
    [self changeChatAndFriendListButtonStyle:self.btnFriend];
    [self initTableView];
    [self setFriendListHeaderView];
    [self setBadgeView];
}

- (void)initButton {
    [self.btnUserKOKOID setTitle:[NSString localization:@"koko_id_setting"] forState:UIControlStateNormal];

    [self.btnFriend setImage:self.ovilImage forState:UIControlStateNormal];
    [self.btnFriend setTitle:[NSString localization:@"button_friends"] forState:UIControlStateNormal];
    [self.btnChat setImage:self.clearImage forState:UIControlStateNormal];
    [self.btnChat setTitle:[NSString localization:@"button_chats"] forState:UIControlStateNormal];

    // iOS 15 改用此方法設定 style
    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *configuration = [UIButtonConfiguration filledButtonConfiguration];
        configuration.background.backgroundColor = UIColor.clearColor;
        configuration.titleAlignment = UIButtonConfigurationTitleAlignmentCenter;
        configuration.imagePadding = 5.0;
        configuration.imagePlacement = NSDirectionalRectEdgeBottom;
        self.btnFriend.configuration = configuration;
        self.btnChat.configuration = configuration;
    } else {
        CGSize imageViewSize = self.btnFriend.imageView.frame.size;
        self.btnFriend.titleEdgeInsets = UIEdgeInsetsMake(-(imageViewSize.height + 5), -imageViewSize.width, 0, 0);
        CGSize textSize = [[NSString localization:@"button_friends"] sizeWithAttributes:@{NSFontAttributeName: self.btnFriend.titleLabel.font}];
        self.btnFriend.imageEdgeInsets = UIEdgeInsetsMake((textSize.height + 5), 0, 0, -textSize.width);
        self.btnFriend.contentEdgeInsets = UIEdgeInsetsMake(imageViewSize.height, 0, imageViewSize.height, 0);
        
        imageViewSize = self.btnChat.imageView.frame.size;
        self.btnChat.titleEdgeInsets = UIEdgeInsetsMake(-(imageViewSize.height + 5), -imageViewSize.width, 0, 0);
        textSize = [[NSString localization:@"button_chats"] sizeWithAttributes:@{NSFontAttributeName: self.btnChat.titleLabel.font}];
        self.btnChat.imageEdgeInsets = UIEdgeInsetsMake((textSize.height + 5), 0, 0, -textSize.width);
        self.btnChat.contentEdgeInsets = UIEdgeInsetsMake(imageViewSize.height, 0, imageViewSize.height, 0);
    }

    UIImage *gradientImage = [UIImage convertGradientToImage:[UIColor colorWithRed: 0.34 green: 0.70 blue: 0.04 alpha: 1.00] endColor:[UIColor colorWithRed: 0.65 green: 0.80 blue: 0.26 alpha: 1.00] frame:self.btnEmptyAddFriend.frame];
    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *configuration = [UIButtonConfiguration filledButtonConfiguration];
        configuration.background.image = gradientImage;
        configuration.background.cornerRadius = 20.0;
        configuration.image = [UIImage imageNamed:@"icon_add_friend"];
        configuration.imagePlacement = NSDirectionalRectEdgeTrailing;
        configuration.titleAlignment = UIButtonConfigurationTitleAlignmentCenter;
        configuration.title = [NSString localization:@"empty_add_friend_button_title"];

        self.btnEmptyAddFriend.configuration = configuration;
    } else {
        self.btnEmptyAddFriend.layer.cornerRadius = 20.0;
        self.btnEmptyAddFriend.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.btnEmptyAddFriend.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.btnEmptyAddFriend.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    
        UIEdgeInsets inset = self.btnEmptyAddFriend.imageEdgeInsets;
        inset.left = -100;
        self.btnEmptyAddFriend.imageEdgeInsets = inset;
        [self.btnEmptyAddFriend setBackgroundImage:gradientImage forState:UIControlStateNormal];
        [self.btnEmptyAddFriend setImage:[UIImage imageNamed:@"icon_add_friend"] forState:UIControlStateNormal];
        [self.btnEmptyAddFriend setTitle:[NSString localization:@"empty_add_friend_button_title"] forState:UIControlStateNormal];
    }
}

- (void)initTableView {
    self.tableViewList.delegate = self;
    self.tableViewList.dataSource = self;
    self.tableViewInvite.delegate = self;
    self.tableViewInvite.dataSource = self;
    
    self.tableViewList.allowsSelection = NO;
    [self.tableViewList registerNib:[UINib nibWithNibName:@"FriendListTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendListTableViewCell"];
    [self.tableViewInvite registerNib:[UINib nibWithNibName:@"InvitedTableViewCell" bundle:nil] forCellReuseIdentifier:@"InvitedTableViewCell"];
    
    [self setRefreshControl];
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
    
    if (![self.userURLString isEqualToString:@"https://dimanyen.github.io/friend4.json"]) {
        [self getUserData];
    }
    [self getFriendListData:self.userURLString];
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
    [self setRefreshControl];
    [self.tableViewList reloadData];
}

- (IBAction)addFriendFunction:(UIButton *)sender {
}

- (void)agreeInviteFunction:(id)sender event:(id)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableViewInvite];
    NSIndexPath *indexPath = [self.tableViewInvite indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath != nil) {
        // TODO: 接受交友邀請
    }
}

- (void)deleteInviteFunction:(id)sender event:(id)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableViewInvite];
    NSIndexPath *indexPath = [self.tableViewInvite indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath != nil) {
        // TODO: 刪除交友邀請
    }
}

- (void)friendTransferFunction:(id)sender event:(id)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableViewList];
    NSIndexPath *indexPath = [self.tableViewList indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath != nil) {
        // TODO: 轉帳給好友
    }
}

- (void)friendMoreFunction:(id)sender event:(id)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableViewList];
    NSIndexPath *indexPath = [self.tableViewList indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath != nil) {
        // TODO: 好友列表更多
    }
}


#pragma mark - UITableView Function

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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
        if (self.inviteList) {
            if (self.inviteList.count > 1 && !self.showInviteVisible) {
                return 1;
            } else {
                return self.inviteList.count;
            }
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableViewInvite) {
        if (!self.showInviteVisible && self.inviteList && self.inviteList.count > 1) {
            return 70 + 10;
        } else {
            return 70;
        }
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
    if (tableView == self.tableViewInvite) {
        self.showInviteVisible = !self.showInviteVisible;
        [self.tableViewInvite reloadData];
    }
}


#pragma mark - UISearchBar Delegate Function

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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!searchText || [searchText isEmpty]) {
        // 當搜尋欄為空時，須還原原本的資料
        if ([self.searchList count] > 0) {
            if (self.nowSelectedType == 0) {
                self.friendList = [[NSMutableArray alloc] initWithArray:self.searchList];
                [self.searchList removeAllObjects];
            } else {
                self.chatList = [[NSMutableArray alloc] initWithArray:self.searchList];
                [self.searchList removeAllObjects];
            }
            
            [self.tableViewList reloadData];
        }
    } else {
        if (self.nowSelectedType == 0) {
            // 搜尋 Model 中是否有符合的名稱。
            self.searchList = [[NSMutableArray alloc] initWithArray:self.friendList];
            [self.friendList removeAllObjects];
            
            for (FriendUserModel *model in self.searchList) {
                if ([model.userName containsString:searchText]) {
                    [self.friendList addObject:model];
                }
            }

            [self.tableViewList reloadData];
        } else {
            self.searchList = [[NSMutableArray alloc] initWithArray:self.chatList];
            [self.chatList removeAllObjects];
            
            // TODO: Chat 方法
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}


#pragma mark - UISearchBar Delegate Function

/// HTML Label tapped Link function
/// @param linkString a href link
- (void)tappedLinkTextFunction:(NSURL *)linkString {
    [[UIApplication sharedApplication] openURL:linkString options:@{} completionHandler:nil];
}


#pragma mark - Call API Function

/// 取得此 User 的資料
- (void)getUserData {
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

/// 取得 User 的好友列表
- (void)getFriendListData:(NSString *)urlString {
    [APIUtility apiConnectionByURL:urlString completion:^(NSMutableDictionary * _Nonnull response, NSError * _Nonnull error) {
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
                    BOOL isExist = NO;
                    FriendUserModel *removeModel = nil;
                    for (int i = 0 ; i < self.friendList.count ; i++) {
                        FriendUserModel *tempModel = [self.friendList objectAtIndex:i];
                        if ([model.userID isEqualToString:tempModel.userID]) {
                            // 判斷如有重複的 FID，取更新時間較新的資料
                            if ([model.updateTimes compare:tempModel.updateTimes] == NSOrderedDescending) {
                                removeModel = tempModel;
                            }
                            
                            isExist = YES;
                            break;
                        }
                    }

                    if (removeModel != nil) {
                        [self.friendList removeObject:removeModel];
                    }
                    
                    if (!isExist || (isExist && removeModel != nil)) {
                        [self.friendList addObject:model];
                    }
                }
            }
            
            /// 當為 friend1.json ，依需求需要整合 friend2.json 的列表
            if ([urlString isEqualToString:@"https://dimanyen.github.io/friend1.json"]) {
                [self getFriendListData:@"https://dimanyen.github.io/friend2.json"];
            } else {
                [self changeChatAndFriendListStyle:response];
            }
        } else {
            [self changeChatAndFriendListStyle:nil];
        }
    }];
}


#pragma mark - Private Function

/// 更新現在選擇的好友或聊天按鈕下的橫條圖片
/// @param button  Chat or Friend
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

/// update Friend or Char List constraint and is hidden
/// @param response Get Friend or Chat List API Response
- (void)changeChatAndFriendListStyle:(NSMutableDictionary *)response {
    if (response && response.count > 0) {
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
    
    if (self.tableViewList.refreshControl) {
        [self.tableViewList.refreshControl endRefreshing];
    }
    
    [self setBadgeView];
}

/// set searchbar
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

/// 設定通知小圓點
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

/// 設定好友列表的下拉更新
- (void)setRefreshControl {
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    control.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString localization:@"refresh_text"]];
    [control addTarget:self action:@selector(refreshFriendOrChatList) forControlEvents:UIControlEventValueChanged];
    
    if (self.nowSelectedType == 0) {
        self.tableViewList.refreshControl = control;
    } else {
        self.tableViewList.refreshControl = nil;
    }
}

- (void)refreshFriendOrChatList {
    if (self.nowSelectedType == 0) {
        [self getFriendListData:self.userURLString];
    } else if (self.nowSelectedType == 1) {
        // TODO: Chat Refresh Function
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
    
    [cell.btnTransfer addTarget:self action:@selector(friendTransferFunction:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnMore addTarget:self action:@selector(friendMoreFunction:event:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [cell.btnAgreeInvited addTarget:self action:@selector(agreeInviteFunction:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDeleteInvited addTarget:self action:@selector(deleteInviteFunction:event:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.showInviteVisible && self.inviteList && self.inviteList.count > 1) {
        cell.viewExpandable.hidden = NO;
        cell.viewContent.layer.shadowPath = nil;
    } else {
        cell.viewExpandable.hidden = YES;
        cell.viewExpandable.layer.shadowPath = nil;

        UIEdgeInsets shadowInsets = UIEdgeInsetsMake(1.5f, 0, 1.5f, 0);
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(cell.viewContent.bounds, shadowInsets)];
        if (!cell.viewContent.layer.shadowPath) {
            cell.viewContent.layer.shadowPath = shadowPath.CGPath;
        }
    }

    return cell;
}

@end
