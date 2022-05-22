//
//  APIUtility.h
//  KOKO_APP
//
//  Created by Jim Huang on 2022/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIUtility : NSObject

+ (void)apiConnectionByURL:(NSString *)urlString completion:(void (^)(NSMutableDictionary *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
