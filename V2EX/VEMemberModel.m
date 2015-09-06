//
//  VEMemberModel.m
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "VEMemberModel.h"

@implementation VEMemberModel

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"memberID" : @"id",
             @"userName" : @"username",
             @"tagLine" : @"tagline",
             @"avatarMini" : @"avatar_mini",
             @"avatarNormal" : @"avatar_normal",
             @"avatarLarge" : @"avatar_large",
             @"url" : @"url",
             @"website" : @"website",
             @"twitter" : @"twitter",
             @"psn" : @"psn",
             @"github" : @"github",
             @"btc" : @"btc",
             @"location" : @"location",
             @"bio" : @"bio",
             @"created" : @"created"};
}

+ (NSValueTransformer *)avatarMiniJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)avatarNormalJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)avatarLargeJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)createdJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *dateInterval, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithTimeIntervalSince1970:[dateInterval doubleValue]];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
    }];
}

@end
