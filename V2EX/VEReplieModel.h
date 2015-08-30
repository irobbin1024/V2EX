//
//  VEReplieModel.h
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"
#import "VEMemberModel.h"

@interface VEReplieModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger replieID;
@property (nonatomic, assign) NSInteger thanks;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * contentRendered;
@property (nonatomic, strong) VEMemberModel * member;
@property (nonatomic, strong) NSDate * created;
@property (nonatomic, strong) NSDate * lastModified;

@end
