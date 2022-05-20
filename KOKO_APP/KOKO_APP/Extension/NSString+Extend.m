//
//  NSString+Extend.m
//  KOKO_APP
//
//  Created by Jim Huang on 2022/5/20.
//

#import "NSString+Extend.h"

@implementation NSString(Extend)

+ (NSString *)localization:(NSString *)key {
    return [NSBundle.mainBundle localizedStringForKey:key value:@"" table:@"InfoPlist"];
}

- (BOOL)isEmpty {
    return !self || [self isEqualToString:@""];
}

@end
