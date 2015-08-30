//
//  VETopicModel.m
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "VETopicModel.h"
#import "VEAPIClient.h"

@implementation VETopicModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"topicID" : @"id",
             @"title" : @"title",
             @"url" : @"url",
             @"content" : @"content",
             @"contentRendered" : @"content_rendered",
             @"replies" : @"replies",
             @"member" : @"member",
             @"node" : @"node",
             @"created" : @"created",
             @"lastModified" : @"last_modified",
             @"lastTouched" : @"last_touched"};
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)memberJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:VEMemberModel.class];
}

+ (NSValueTransformer *)nodeJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:VENodeModel.class];
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

+ (NSValueTransformer *)lastTouchedJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *dateInterval, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithTimeIntervalSince1970:[dateInterval doubleValue]];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
    }];
}

- (NSString *)formatterReplies {
    if (self.replies > 10000) {
        return [NSString stringWithFormat:@"%ldw", self.replies / 10000];
    } else if (self.replies > 1000) {
        return [NSString stringWithFormat:@"%ldk", self.replies / 1000];
    } else {
        return [NSString stringWithFormat:@"%ld", self.replies];
    }
}

@end
