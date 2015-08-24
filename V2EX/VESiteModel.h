//
//  VESiteModel.h
//  V2EX
//
//  Created by wengjia on 15/8/23.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface VESiteInfoModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * slogan;
@property (nonatomic, copy) NSString * describe;
@property (nonatomic, copy) NSString * domain;

+ (NSURLSessionDataTask *)siteInfoWithBlock:(void (^)(id siteInfo, NSError *error))block;
@end

@interface VESiteStatsModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString * topic_max;
@property (nonatomic, copy) NSString * member_max;

+ (NSURLSessionDataTask *)siteStatsWithBlock:(void (^)(id siteStats, NSError *error))block;
@end

