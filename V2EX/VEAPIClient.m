//
//  VEAPIClient.m
//  
//
//  Created by baiyang on 15/7/24.
//
//

#import "VEAPIClient.h"

@implementation VEAPIClient

+ (instancetype)sharedClient {
    static VEAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[VEAPIClient alloc] initWithBaseURL:[NSURL URLWithString:VEAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedClient;
}

@end
