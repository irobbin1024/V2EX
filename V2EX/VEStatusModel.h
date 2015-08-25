//
//  VEStatusModel.h
//  
//
//  Created by baiyang on 15/7/27.
//
//

#import "MTLModel.h"
#import "Mantle.h"

@interface VEStatusMemberModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * tagLine;
@property (nonatomic, copy) NSURL * avatarMini;
@property (nonatomic, copy) NSURL * avatarNormal;
@property (nonatomic, copy) NSURL * avatarLarge;

@end

@interface VEStatusNodeModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger nodeID;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * titleAlternative;
@property (nonatomic, copy) NSURL * url;
@property (nonatomic, copy) NSURL * avatarMini;
@property (nonatomic, copy) NSURL * avatarNormal;
@property (nonatomic, copy) NSURL * avatarLarge;

@end

@interface VEStatusModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger stautsID;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSURL * url;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * contentRendered;
@property (nonatomic, assign) NSInteger replies;
@property (nonatomic, strong) VEStatusMemberModel * member;
@property (nonatomic, strong) VEStatusNodeModel * node;
@property (nonatomic, strong) NSDate * created;
@property (nonatomic, strong) NSDate * lastModified;
@property (nonatomic, strong) NSDate * lastTouched;

+ (NSURLSessionDataTask *)hotsWithBlock:(void (^)(NSArray *hots, NSError *error))block;
+ (NSDateFormatter *)dateFormatter;
+ (NSURLSessionDataTask *)latestWithBlock:(void (^)(NSArray *lastests, NSError *error))block;

@end
