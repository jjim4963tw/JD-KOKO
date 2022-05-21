//
//  FriendUserModel.m
//  KOKO_APP
//
//  Created by Jim Huang on 2022/5/21.
//

#import "FriendUserModel.h"

@implementation FriendUserModel

- (instancetype)initWithUserName:(NSString *)userName userID:(NSString *)userID status:(NSInteger)status updateTimes:(NSDate *)updateTimes isTop:(BOOL)isTop {
    self = [super init];
    
    if (self) {
        self.userName = userName;
        self.userID = userID;
        self.status = status;
        self.updateTimes = updateTimes;
        self.isTop = isTop;
    }
    
    return self;
}
@end
