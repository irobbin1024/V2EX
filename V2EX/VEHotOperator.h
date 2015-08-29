//
//  VEHotOperator.h
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VEHotOperator : NSObject

+ (NSURLSessionDataTask *)hotsWithBlock:(void (^)(NSArray *hots, NSError *error))block;

@end
