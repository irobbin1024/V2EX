//
//  VETopicTableViewCell.h
//  V2EX
//
//  Created by baiyang on 8/25/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VETopicModel.h"

static NSString * VETopicTableViewCellIdentifier = @"VETopicTableViewCellIdentifier";

@interface VETopicTableViewCell : UITableViewCell

@property (nonatomic, strong) VETopicModel * topicModel;

- (void)setupWithTopicModel:(VETopicModel *)topicModel;

+ (CGFloat)heightWithTopicModel:(VETopicModel *)topicModel;

@end
