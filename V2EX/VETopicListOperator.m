//
//  VETopicListOperator.m
//  V2EX
//
//  Created by 翁佳 on 15-9-1.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VETopicListOperator.h"
#import "VETopicListControllerUtil.h"
#import "VEAPIClient.h"
#import "VETopicModel.h"

@implementation VETopicListOperator

+ (NSURLSessionDataTask *)topicListWithType:(VETopicListType)type Block:(void (^)(NSArray *hots, NSError *error))block {
    NSString *urlString = [VETopicListControllerUtil urlWithTopicListType:type];
    return [[VEAPIClient sharedClient] GET:urlString parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSError *error;
        NSArray *topicList = [MTLJSONAdapter modelsOfClass:[VETopicModel class] fromJSONArray:JSON error:&error];
        
        if (block) {
            block([NSArray arrayWithArray:topicList], error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block){
            block([NSArray array], error);
        }
    }];
}
@end
