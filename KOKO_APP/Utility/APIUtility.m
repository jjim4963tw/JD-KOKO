//
//  APIUtility.m
//  KOKO_APP
//
//  Created by Jim Huang on 2022/5/20.
//

#import "APIUtility.h"
#import "AFNetworking.h"

@implementation APIUtility

+ (void)apiConnectionByURL:(NSString *)urlString completion:(void (^)(NSMutableDictionary *, NSError *))completion {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSMutableDictionary *response = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            if (response && response.count > 0 && [response objectForKey:@"response"]) {
                if (completion) {
                    completion(response, nil);
                }
            } else {
                if (completion) {
                    completion(nil, nil);
                }
            }
        } else {
            if (completion) {
                completion(nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

@end
