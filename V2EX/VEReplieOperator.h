//
//  VEReplieOperator.h
//  V2EX
//
//  Created by baiyang on 8/30/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VEReplieOperator : NSObject

+ (NSURLSessionDataTask *)repliesWithPage:(NSInteger)page pageSize:(NSInteger)pageSize topicID:(NSInteger)topicID block:(void (^)(NSArray *replies, NSError *error))block ;

@end
