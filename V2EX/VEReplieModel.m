//
//  VEReplieModel.m
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "VEReplieModel.h"

@implementation VEReplieModel

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"replieID" : @"id",
             @"thanks" : @"thanks",
             @"content" : @"content",
             @"contentRendered" : @"content_rendered",
             @"member" : @"member",
             @"created" : @"created",
             @"lastModified" : @"last_modified"};
}

+ (NSValueTransformer *)memberJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:VEMemberModel.class];
}

+ (NSValueTransformer *)createdJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *dateInterval, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithTimeIntervalSince1970:[dateInterval doubleValue]];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
    }];
}

+ (NSValueTransformer *)lastModifiedJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *dateInterval, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithTimeIntervalSince1970:[dateInterval doubleValue]];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
    }];
}

@end
