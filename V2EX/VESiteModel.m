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


@end
