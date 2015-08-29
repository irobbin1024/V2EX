//
//  VENodeModel.m
//  V2EX
//
//  Created by 翁佳 on 15-8-13.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VENodeModel.h"
#import "VEAPIClient.h"

@implementation VENodeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"nodeID" : @"id",
             @"name" : @"name",
             @"url" : @"url",
             @"title" : @"title",
             @"titleAlternative" : @"title_alternative",
             @"topics" : @"topics",
             @"header" : @"header",
             @"footer" : @"footer",
             @"created" : @"created",
             @"avatarMini" : @"avatar_mini",
             @"avatarNormal" : @"avatar_normal",
             @"avatarLarge" : @"avatar_large"
             };
}


+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)createdJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *dateInterval, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithTimeIntervalSince1970:[dateInterval doubleValue]];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
    }];
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

@end



