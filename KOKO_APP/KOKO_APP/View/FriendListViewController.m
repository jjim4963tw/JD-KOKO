//
//  FriendListViewController.m
//  KOKO_APP
//
//  Created by Jim Huang on 2022/5/20.
//

#import "FriendListViewController.h"
#import "APIUtility.h"

#import "NSString+Extend.h"
#import "UIImage+Extend.h"


@interface FriendListViewController ()

@property(retain) UIImage *ovilImage;
@property(retain) UIImage *clearImage;

@end


#pragma mark - LifeCycle Function Function

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initContentView];
    [self initNavigationBar];
    [self initUserData];
}


#pragma mark - Init Function

- (void)initContentView {
    self.labelUserName.text = @"User";

    self.imageViewUserAvatar.layer.cornerRadius = self.imageViewUserAvatar.frame.size.width / 2;
    self.imageViewUserAvatar.layer.masksToBounds = YES;

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
    self.constraintBtnFriendTop.constant = self.constraintBtnFriendTop.constant - self.tableViewInvite.frame.size.height - 6;
}

- (void)initNavigationBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initUserData {
    [APIUtility apiConnectionByURL:@"https://dimanyen.github.io/man.json" completion:^(NSMutableDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response && response.count > 0) {
            NSArray *responseArray = [response objectForKey:@"response"];
            NSString *userName = [[responseArray objectAtIndex:0] objectForKey:@"name"];
            NSString *kokoID = [[responseArray objectAtIndex:0]  objectForKey:@"kokoid"];

            self.labelUserName.text = userName;
            
            if ([kokoID isEmpty]) {
                [self.btnUserKOKOID setTitle:[NSString localization:@"koko_id_setting"] forState:UIControlStateNormal];
            } else {
                [self.btnUserKOKOID setTitle:[NSString stringWithFormat:[NSString localization:@"koko_id_show"], kokoID] forState:UIControlStateNormal];
            }
        }
    }];
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
}

- (IBAction)addFriendFunction:(UIButton *)sender {
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

@end
