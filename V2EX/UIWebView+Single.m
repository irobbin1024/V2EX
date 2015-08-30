//
//  UIWebView+Single.m
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "UIWebView+Single.h"
#import <objc/runtime.h>


static NSMutableDictionary * size;

@implementation UIWebView (Single)

+(void)load {
    size = [NSMutableDictionary dictionary];
}


+ (NSString *)sizeIDWithTopicID:(NSInteger)topicID width:(CGFloat)width {
    NSString * sizeID = [NSString stringWithFormat:@"%ld_%lf", topicID, width];
    return sizeID;
}


+ (CGFloat)heightFromCacheWithTopicID:(NSInteger)topicID width:(CGFloat)width {
    NSNumber * height = [size objectForKey:[UIWebView sizeIDWithTopicID:topicID width:width]];
    if (height) {
        return [height floatValue];
    } else {
        return -1;
    }
}

+ (void)writeHeight:(CGFloat)height withTopicID:(NSInteger)topicID width:(CGFloat)width {
    NSString * sizeID = [self.class sizeIDWithTopicID:topicID width:width];
    
    [size setObject:@(height) forKey:sizeID];
}

@end
