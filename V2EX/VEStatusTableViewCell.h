//
//  VEStatusTableViewCell.h
//  V2EX
//
//  Created by baiyang on 8/25/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEStatusModel.h"

static NSString * VEStatusTableViewCellIdentifier = @"VEStatusTableViewCellIdentifier";

@interface VEStatusTableViewCell : UITableViewCell

@property (nonatomic, strong) VEStatusModel * statusModel;

- (void)setupWithStatusModel:(VEStatusModel *)statusModel;

+ (CGFloat)heightWithStatusModel:(VEStatusModel *)statusModel;

@end
