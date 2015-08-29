//
//  VEMemberModel.m
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "VEMemberModel.h"

@implementation VEMemberModel

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"memberID" : @"id",
             @"userName" : @"username",
             @"tagLine" : @"tagline",
             @"avatarMini" : @"avatar_mini",
             @"avatarNormal" : @"avatar_normal",
             @"avatarLarge" : @"avatar_large",
             @"website" : @"website",
             @"twitter" : @"twitter",
             @"location" : @"location",
             @"bio" : @"bio"};
}

+ (NSValueTransformer *)avatarMiniJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)avatarNormalJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)avatarLargeJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)websiteJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)twitterJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
