//
//  VEMemberModel.h
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"

@interface VEMemberModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger memberID;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * tagLine;
@property (nonatomic, copy) NSURL * avatarMini;
@property (nonatomic, copy) NSURL * avatarNormal;
@property (nonatomic, copy) NSURL * avatarLarge;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * website;
@property (nonatomic, copy) NSString * twitter;
@property (nonatomic, copy) NSString * psn;
@property (nonatomic, copy) NSString * github;
@property (nonatomic, copy) NSString * btc;
@property (nonatomic, copy) NSString * location;
@property (nonatomic, copy) NSString * bio;
@property (nonatomic, copy) NSDate * created;
@end
