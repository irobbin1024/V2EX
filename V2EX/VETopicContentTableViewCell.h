//
//  VETopicContentTableViewCell.h
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VETopicModel.h"

static const NSInteger kReplieTableViewCellDefaultHeight = 0;
static NSString * const kVETopicContentTableViewCellIdentifier = @"kVETopicContentTableViewCellIdentifier";

@interface VETopicContentTableViewCell : UITableViewCell

@property (nonatomic, strong) VETopicModel * topic;
@property (nonatomic, weak) UIViewController * viewController;

- (void)setupWithTopic:(VETopicModel *)topic;

+ (CGFloat)heightWithTopic:(VETopicModel *)topic;

@end
