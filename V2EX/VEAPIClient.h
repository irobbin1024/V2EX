//
//  VEAPIClient.h
//  
//
//  Created by baiyang on 15/7/24.
//
//

#import "AFHTTPSessionManager.h"

static NSString * const VEAPIBaseURLString = @"http://www.v2ex.com/";

@interface VEAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
