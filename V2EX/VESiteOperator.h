//
//  VESiteOperator.h
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VESiteOperator : NSObject

+ (NSURLSessionDataTask *)siteInfoWithBlock:(void (^)(id siteInfo, NSError *error))block;
+ (NSURLSessionDataTask *)siteStatsWithBlock:(void (^)(id siteStats, NSError *error))block;

@end
