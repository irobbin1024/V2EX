//
//  VELatestCell.h
//  V2EX
//
//  Created by wengjia on 15/8/11.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEStatusModel.h"

static NSString * VELatestIdentifier = @"VELatestIdentifier";

@interface VELatestCell : UITableViewCell

@property (nonatomic, strong) VEStatusModel * statusModel;

- (void)setupWithStatusModel:(VEStatusModel *)statusModel;

@end
