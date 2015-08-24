//
//  VEStatusModel.m
//  
//
//  Created by baiyang on 15/7/27.
//
//

#import "VEStatusModel.h"
#import "VEAPIClient.h"

@implementation VEStatusMemberModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"userID" : @"id",
             @"userName" : @"user_name",
             @"tagLine" : @"tag_line",
             @"avatarMini" : @"avatar_mini",
             @"avatarNormal" : @"avatar_normal",
             @"avatarLarge" : @"avatar_large",};
}

+ (NSValueTransformer *)avatarMiniSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)avatarNormalSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)avatarLargeSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end

@implementation VEStatusNodeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"nodeID" : @"id",
             @"name" : @"name",
             @"title" : @"title",
             @"titleAlternative" : @"title_alternative",
             @"url" : @"url",
             @"avatarMini" : @"avatar_mini",
             @"avatarNormal" : @"avatar_normal",
             @"avatarLarge" : @"avatar_large",};
}

+ (NSValueTransformer *)urlSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)avatarMiniSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)avatarNormalSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)avatarLargeSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end

@implementation VEStatusModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"stautsID" : @"id",
             @"title" : @"title",
             @"url" : @"url",
             @"content" : @"content",
             @"contentRendered" : @"content_rendered",
             @"replies" : @"replies",
             @"member" : @"member",
             @"node" : @"node",
             @"created" : @"created",
             @"lastModified" : @"last_modified",
             @"lastTouched" : @"last_touched"};
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)memberJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:VEStatusMemberModel.class];
}

+ (NSValueTransformer *)nodeJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:VEStatusNodeModel.class];
}

+ (NSValueTransformer *)createdJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *dateInterval, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithTimeIntervalSince1970:[dateInterval doubleValue]];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
    }];
}

+ (NSValueTransformer *)lastModifiedJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *dateInterval, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithTimeIntervalSince1970:[dateInterval doubleValue]];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
    }];
}

+ (NSValueTransformer *)lastTouchedJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *dateInterval, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithTimeIntervalSince1970:[dateInterval doubleValue]];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
    }];
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ";
    return dateFormatter;
}

#pragma mark - Data

+ (NSURLSessionDataTask *)hotsWithBlock:(void (^)(NSArray *hots, NSError *error))block {
    return [[VEAPIClient sharedClient] GET:@"api/topics/hot.json" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSError * error;
        NSArray *hots = [MTLJSONAdapter modelsOfClass:[VEStatusModel class] fromJSONArray:JSON error:&error];
        
        if (block) {
            block([NSArray arrayWithArray:hots], error);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

+ (NSURLSessionDataTask *)latestWithBlock:(void (^)(NSArray *lastests, NSError *error))block {
    return [[VEAPIClient sharedClient] GET:@"api/topics/latest.json" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSError *error;
        NSArray *latests = [MTLJSONAdapter modelsOfClass:[VEStatusModel class] fromJSONArray:JSON error:&error];
        
        if (block) {
            block([NSArray arrayWithArray:latests], error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block){
            block([NSArray array], error);
        }
    }];
}


@end
