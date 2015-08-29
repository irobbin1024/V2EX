//
//  VENodesOperator.h
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VENodesOperator : NSObject

+ (NSURLSessionDataTask *)nodeWithBlock:(void (^)(NSArray * nodes, NSError *error))block;

@end
