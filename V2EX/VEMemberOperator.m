//
//  VEMemberOperator.m
//  V2EX
//
//  Created by wengjia on 15/9/5.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VEMemberOperator.h"
#import "VEAPIClient.h"

@implementation VEMemberOperator

+ (NSURLSessionDataTask *)memberDetailWithMember:(VEMemberModel *)member Block:(void (^)(VEMemberModel * member, NSError *error)) block {
    
    return [[VEAPIClient sharedClient] GET:@"/api/members/show.json" parameters:@{@"id" : @(member.memberID)} success:^(NSURLSessionDataTask *task, id JSON) {
        NSError *error;
        __autoreleasing VEMemberModel *tempModel = [MTLJSONAdapter modelOfClass:[VEMemberModel class] fromJSONDictionary:JSON error:&error];
        if (error == nil) {
            NSArray *keysofJSONProperties = [[[VEMemberModel class] JSONKeyPathsByPropertyKey] allKeys];
            for (id key in keysofJSONProperties) {
                [member mergeValueForKey:key fromModel:tempModel];
            }
        }
        if (block) {
            block(member, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(member, error);
        }
    }];
}

@end