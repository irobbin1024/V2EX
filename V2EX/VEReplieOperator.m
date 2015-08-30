//
//  VEReplieOperator.m
//  V2EX
//
//  Created by baiyang on 8/30/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "VEReplieOperator.h"
#import "VEAPIClient.h"
#import "MTLJSONAdapter.h"
#import "VEReplieModel.h"

@implementation VEReplieOperator


+ (NSURLSessionDataTask *)repliesWithPage:(NSInteger)page pageSize:(NSInteger)pageSize topicID:(NSInteger)topicID block:(void (^)(NSArray *replies, NSError *error))block {
    
    return [[VEAPIClient sharedClient] GET:@"/api/replies/show.json" parameters:@{@"page" : @(page), @"page_size" : @(pageSize), @"topic_id" : @(topicID)} success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSError * error;
        NSArray *replies = [MTLJSONAdapter modelsOfClass:[VEReplieModel class] fromJSONArray:JSON error:&error];
        
        if (block) {
            block([NSArray arrayWithArray:replies], error);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
	
}

@end
