//
//  NSString+Extend.h
//  KOKO_APP
//
//  Created by Jim Huang on 2022/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(Extend)

+ (NSString *)localization:(NSString *)key;
- (BOOL)isEmpty;

@end

NS_ASSUME_NONNULL_END
