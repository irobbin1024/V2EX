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


#pragma mark Data

+ (NSURLSessionDataTask *)nodeWithBlock:(void (^)(NSArray * nodes, NSError *error))block {
    return [[VEAPIClient sharedClient] GET:@"api/nodes/all.json" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSError *error;
        NSArray * nodes = [MTLJSONAdapter modelsOfClass:[VENodeModel class] fromJSONArray:JSON error:&error];
        
        if(block) {
            block([NSArray arrayWithArray:nodes], error);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if(block) {
            block([NSArray array], error);
        }
    }];
}
@end



