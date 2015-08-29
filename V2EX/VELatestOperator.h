//
//  VELatestOperator.h
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VELatestOperator : NSObject

+ (NSURLSessionDataTask *)latestWithBlock:(void (^)(NSArray *lastests, NSError *error))block;

@end
