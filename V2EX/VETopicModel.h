//
//  VETopicModel.h
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"
#import "VEMemberModel.h"
#import "VENodeModel.h"

@interface VETopicModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger topicID;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * contentRendered;
@property (nonatomic, assign) NSInteger replies;
@property (nonatomic, strong) VEMemberModel * member;
@property (nonatomic, strong) VENodeModel * node;
@property (nonatomic, strong) NSDate * created;
@property (nonatomic, strong) NSDate * lastModified;
@property (nonatomic, strong) NSDate * lastTouched;

@property (nonatomic, strong, readonly) NSString * formatterReplies;


@end
