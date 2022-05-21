//
//  FriendUserModel.h
//  KOKO_APP
//
//  Created by Jim Huang on 2022/5/21.
//

#import <Foundation/Foundation.h>

@interface FriendUserModel : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSDate *updateTimes;

// 0:送出邀請, 1:已完成 2:等待接受邀請
@property NSInteger status;

// 是否出現星星
@property BOOL isTop;

- (instancetype)initWithUserName:(NSString *)userName userID:(NSString *)userID status:(NSInteger)status updateTimes:(NSDate *)updateTimes isTop:(BOOL)isTop;

@end
