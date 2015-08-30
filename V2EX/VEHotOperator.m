//
//  VEHotOperator.m
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "VEHotOperator.h"
#import "VEAPIClient.h"
#import "VETopicModel.h"

@implementation VEHotOperator

+ (NSURLSessionDataTask *)hotsWithBlock:(void (^)(NSArray *hots, NSError *error))block {
    return [[VEAPIClient sharedClient] GET:@"api/topics/hot.json" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSError * error;
        NSArray *hots = [MTLJSONAdapter modelsOfClass:[VETopicModel class] fromJSONArray:JSON error:&error];
        
        if (block) {
            block([NSArray arrayWithArray:hots], error);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

@end
