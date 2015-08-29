//
//  VESiteOperator.m
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "VESiteOperator.h"
#import "VEAPIClient.h"
#import "VESiteModel.h"

@implementation VESiteOperator

+ (NSURLSessionDataTask *)siteInfoWithBlock:(void (^)(id siteInfo, NSError *error))block {
    return [[VEAPIClient sharedClient] GET:@"api/site/info.json" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSError *error;
        VESiteInfoModel *siteInfo = [MTLJSONAdapter modelOfClass:[VESiteInfoModel class] fromJSONDictionary:JSON error:&error];
        if (block) {
            block(siteInfo, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([VESiteInfoModel alloc], error);
        }
    }];
}
+ (NSURLSessionDataTask *)siteStatsWithBlock:(void (^)(id siteStats, NSError *error))block {
    return [[VEAPIClient sharedClient] GET:@"api/site/stats.json" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSError *error;
        VESiteStatsModel *siteStats = [MTLJSONAdapter modelOfClass:[VESiteStatsModel class] fromJSONDictionary:JSON error:&error];
        if (block) {
            block(siteStats, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([VESiteStatsModel alloc], error);
        }
    }];
}

@end
