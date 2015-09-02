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
    VETopicListTypeNodes,
}VETopicListType;

@interface VETopicListControllerUtil : NSObject

+ (void) setInstanceNodeName:(NSString *)nodeName;

+ (NSString *)titleWithTopicListType:(VETopicListType)topicListType;
+ (NSString *)urlWithTopicListType:(VETopicListType)topicListType;
+ (NSDictionary *)paramsWithTopicListType:(VETopicListType)topicListType;
@end
