//
//  VETopicListController.h
//  V2EX
//
//  Created by 翁佳 on 15-9-1.
//  Copyright (c) 2015年 owl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VETopicListControllerUtil.h"

typedef enum {
    VETopicListTip_Success,
    VETopicListTip_Failure,
    VETopicListTip_Exists,
}VETopicListTipType;

@protocol VETopicListDelegate <NSObject>

- (VETopicListTipType)didClickCollectButtonWithName:(NSString *)name;
@end

@interface VETopicListController : UITableViewController

@property (weak, nonatomic) id<VETopicListDelegate> delegate;
@property (nonatomic, assign) VETopicListType topicListType;
@end
