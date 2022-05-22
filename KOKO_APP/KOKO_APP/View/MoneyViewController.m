//
//  MoneyViewController.m
//  KOKO_APP
//
//  Created by Jim Huang on 2022/5/20.
//

#import "MoneyViewController.h"
#import "FriendListViewController.h"


@interface MoneyViewController ()

@end

@implementation MoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"請選擇模式" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionNoFriend = [UIAlertAction actionWithTitle:@"無好友畫面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FriendListViewController *view = [[self.tabBarController.viewControllers[1] childViewControllers] firstObject];
        view.userURLString = @"https://dimanyen.github.io/friend4.json";
        self.tabBarController.selectedIndex = 1;
    }];
    [controller addAction:actionNoFriend];
    
    UIAlertAction *actionNoFriend1 = [UIAlertAction actionWithTitle:@"只有好友列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FriendListViewController *view = [[self.tabBarController.viewControllers[1] childViewControllers] firstObject];
        view.userURLString = @"https://dimanyen.github.io/friend1.json";
        self.tabBarController.selectedIndex = 1;
    }];
    
    [controller addAction:actionNoFriend1];
    
    UIAlertAction *actionNoFriend2 = [UIAlertAction actionWithTitle:@"好友列表含邀請" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FriendListViewController *view = [[self.tabBarController.viewControllers[1] childViewControllers] firstObject];
        view.userURLString = @"https://dimanyen.github.io/friend3.json";
        self.tabBarController.selectedIndex = 1;
    }];
    [controller addAction:actionNoFriend2];
    
    [self presentViewController:controller animated:YES completion:nil];
}

@end
