//
//  VETopicListControllerUtil.m
//  V2EX
//
//  Created by 翁佳 on 15-9-1.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "VETopicListControllerUtil.h"

@implementation VETopicListControllerUtil

+ (NSString *)titleWithTopicListType:(VETopicListType)topicListType {
    NSString * titleString = @"";
    switch (topicListType) {
        case VETopicListTypeHot:
            titleString = @"最热";
            break;
        case VETopicListTypeLastest:
            titleString = @"最新";
            
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
        default:
            break;
    }
    return urlString;
}
@end
