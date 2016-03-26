//
//  VEMoreView.h
//  V2EX
//
//  Created by baiyang on 16/3/26.
//  Copyright © 2016年 owl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VEMoreViewActionDelegate <NSObject>

- (void)shareAction;
- (void)collectAction;
- (void)reportAction;

@end

@interface VEMoreView : UIView

@property (nonatomic, weak) id<VEMoreViewActionDelegate> actionDelegate;

- (void)show;
- (void)dismiss;

@end
