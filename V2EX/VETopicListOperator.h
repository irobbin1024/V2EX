//
//  VETopicListOperator.h
//  V2EX
//
//  Created by 翁佳 on 15-9-1.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VETopicListControllerUtil.h"

@interface VETopicListOperator : NSObject

+ (NSURLSessionDataTask *)topicListWithType:(VETopicListType)type Block:(void (^)(NSArray *hots, NSError *error))block;
@end
