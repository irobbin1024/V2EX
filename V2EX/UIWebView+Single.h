//
//  UIWebView+Single.h
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kGetWebViewContentSizeSuccessNitification @"kGetWebViewContentSizeSuccessNitification"

@interface UIWebView (Single)

+ (NSString *)sizeIDWithTopicID:(NSInteger)topicID width:(CGFloat)width;
+ (CGFloat)heightFromCacheWithTopicID:(NSInteger)topicID width:(CGFloat)width;
+ (void)writeHeight:(CGFloat)height withTopicID:(NSInteger)topicID width:(CGFloat)width;


@end
