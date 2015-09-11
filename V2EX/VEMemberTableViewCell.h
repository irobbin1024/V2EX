//
//  VEMemberTableViewCell.h
//  V2EX
//
//  Created by wengjia on 15/9/5.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kVEMemberTableViewCellIdentifier = @"kVEMemberTableViewCellIdentifier";


@interface VEMemberTableViewCell : UITableViewCell

- (void)setupWithTitle:(NSString *) title Context:(id) context IsShowImage:(BOOL) isShowImage;
@end
