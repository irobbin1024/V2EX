//
//  VETopicListControllerUtil.h
//  V2EX
//
//  Created by 翁佳 on 15-9-1.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    VETopicListTypeHot,
    VETopicListTypeLastest,
}VETopicListType;

@interface VETopicListControllerUtil : NSObject

+ (NSString *)titleWithTopicListType:(VETopicListType)topicListType;
+ (NSString *)urlWithTopicListType:(VETopicListType)topicListType;
@end
