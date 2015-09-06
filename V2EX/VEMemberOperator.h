//
//  VEMemberOperator.h
//  V2EX
//
//  Created by wengjia on 15/9/5.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VEMemberModel.h"

@interface VEMemberOperator : NSObject

+ (NSURLSessionDataTask *)memberDetailWithMember:(VEMemberModel *)member Block:(void (^)(VEMemberModel * member, NSError *error)) block;

@end
