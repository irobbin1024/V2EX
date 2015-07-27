//
//  VEHotCell.h
//  
//
//  Created by baiyang on 15/7/27.
//
//

#import <UIKit/UIKit.h>
#import "VEStatusModel.h"

static NSString * VEHotCellIdentifier = @"VEHotCellIdentifier";

@interface VEHotCell : UITableViewCell

@property (nonatomic, strong) VEStatusModel * statusModel;

- (void)setupWithStatusModel:(VEStatusModel *)statusModel;

+ (CGFloat)heightWithStatusModel:(VEStatusModel *)statusModel;

@end
