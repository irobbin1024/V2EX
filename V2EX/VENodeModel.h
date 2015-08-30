//
//  VENodeModel.h
//  V2EX
//
//  Created by 翁佳 on 15-8-13.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import "MTLModel.h"
#import "Mantle.h"

@interface VENodeModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) NSInteger nodeID;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSURL * url;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * titleAlternative;
@property (nonatomic, assign) NSInteger topics;
@property (nonatomic, copy) NSString * header;
@property (nonatomic, copy) NSString * footer;
@property (nonatomic, copy) NSDate * created;
@property (nonatomic, copy) NSURL * avatarMini;
@property (nonatomic, copy) NSURL * avatarNormal;
@property (nonatomic, copy) NSURL * avatarLarge;


@end
