//
//  VESiteModel.m
//  V2EX
//
//  Created by wengjia on 15/8/23.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VESiteModel.h"
#import "VEAPIClient.h"

@implementation VESiteInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"title" : @"title",
             @"slogan" : @"slogan",
             @"describe" :@"description",
             @"domain" : @"domain",
             };
}

#pragma mark Data

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

@end

@implementation VESiteStatsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"topic_max" : @"topic_max",
             @"member_max" : @"member_max",
             };
}

+ (NSValueTransformer *)topic_maxJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        return  [[NSNumberFormatter alloc] stringFromNumber:value];
    } reverseBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithLong:[value longLongValue]];
    }];
}

+ (NSValueTransformer *)member_maxJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        return  [[NSNumberFormatter alloc] stringFromNumber:value];
    } reverseBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithLong:[value longLongValue]];
    }];
}

#pragma mark Data

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
