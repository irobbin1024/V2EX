//
//  VEReplieTableViewCell.h
//  V2EX
//
//  Created by baiyang on 8/29/15.
//  Copyright (c) 2015 owl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VETopicModel.h"
#import "VEReplieModel.h"

static NSString * const kVEReplieTableViewCellIdentifier = @"kVEReplieTableViewCellIdentifier";

@interface VEReplieTableViewCell : UITableViewCell

@property (nonatomic, strong) VEReplieModel * replieModel;

- (void)setupWithReplie:(VEReplieModel *)replie;


@end
