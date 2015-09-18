//
//  VEFeedbackContactTableViewCell.h
//  V2EX
//
//  Created by 赖隆斌 on 15/9/18.
//  Copyright © 2015年 owl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kVEFeedbackContactTableViewCellIdentifier @"VEFeedbackContactTableViewCell"

@interface VEFeedbackContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;

@end
