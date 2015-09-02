//
//  VETopicListControllerUtil.m
//  V2EX
//
//  Created by 翁佳 on 15-9-1.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VETopicListControllerUtil.h"
static NSString *node_Name;

@implementation VETopicListControllerUtil

+ (NSString *)titleWithTopicListType:(VETopicListType)topicListType {
    NSString * titleString = @"";
    switch (topicListType) {
        case VETopicListTypeHot:
            titleString = @"最热";
            break;
        case VETopicListTypeLastest:
            titleString = @"最新";
            break;
        case VETopicListTypeNodes:
            titleString = @"话题";
        default:
            break;
    }
    return titleString;
}

+ (NSString *)urlWithTopicListType:(VETopicListType)topicListType {
    NSString * urlString = @"";
    switch (topicListType) {
        case VETopicListTypeHot:
            urlString = @"api/topics/hot.json";
            break;
        case VETopicListTypeLastest:
            urlString = @"api/topics/latest.json";
            break;
        case VETopicListTypeNodes:
            urlString = @"/api/topics/show.json";
            break;
        default:
            break;
    }
    return urlString;
}

+ (NSDictionary *)paramsWithTopicListType:(VETopicListType)topicListType {
    NSDictionary *parameters;
    switch (topicListType) {
        case VETopicListTypeNodes:{
            if (node_Name){
                parameters = @{@"node_name": node_Name};};
            break;
        }
        default:
            break;
    }
    return parameters;
}

+ (void) setInstanceNodeName:(NSString *)nodeName {
    node_Name = nodeName;
}
@end
