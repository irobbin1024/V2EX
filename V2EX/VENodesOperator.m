//
//  VENodesOperator.m
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "VENodesOperator.h"
#import "VEAPIClient.h"
#import "VENodeModel.h"

@implementation VENodesOperator

+ (NSURLSessionDataTask *)nodeWithBlock:(void (^)(NSArray * nodes, NSError *error))block {
    return [[VEAPIClient sharedClient] GET:@"api/nodes/all.json" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSError *error;
        NSArray *nodes = [MTLJSONAdapter modelsOfClass:[VENodeModel class] fromJSONArray:JSON error:&error];
        
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
