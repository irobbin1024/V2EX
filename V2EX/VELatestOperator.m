//
//  VELatestOperator.m
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "VELatestOperator.h"
#import "VEAPIClient.h"
#import "VETopicModel.h"

@implementation VELatestOperator

+ (NSURLSessionDataTask *)latestWithBlock:(void (^)(NSArray *lastests, NSError *error))block {
    return [[VEAPIClient sharedClient] GET:@"api/topics/latest.json" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSError *error;
        NSArray *latests = [MTLJSONAdapter modelsOfClass:[VETopicModel class] fromJSONArray:JSON error:&error];
        
        if (block) {
            block([NSArray arrayWithArray:latests], error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block){
            block([NSArray array], error);
        }
    }];
}

@end
